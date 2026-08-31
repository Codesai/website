#!/usr/bin/env bash

set -euo pipefail

test_root="$(mktemp -d)"
source_dir="$test_root/source"
server_pid=""

cleanup() {
  if [[ -n "$server_pid" ]]; then
    kill "$server_pid" 2>/dev/null || true
    wait "$server_pid" 2>/dev/null || true
  fi
  rm -rf "$test_root"
}
trap cleanup EXIT INT TERM

mkdir -p "$source_dir"
tar \
  --exclude='./.git' \
  --exclude='./_site' \
  --exclude='./.jekyll-cache' \
  --exclude='./.sass-cache' \
  --exclude='./node_modules' \
  -C /app -cf - . | tar -C "$source_dir" -xf -

mkdir -p "$source_dir/_i18n/en/_posts"
cp -a "$source_dir/_i18n/es/_posts/." "$source_dir/_i18n/en/_posts/"

cd "$source_dir"
bundle exec jekyll build --trace

es_source_count="$(find _i18n/es/_posts -type f | wc -l)"
en_source_count="$(find _i18n/en/_posts -type f | wc -l)"
[[ "$es_source_count" -eq "$en_source_count" ]] || {
  echo "ES/EN post source counts differ: $es_source_count != $en_source_count" >&2
  exit 1
}

es_built_count="$(find _site/posts -type f -name '*.html' | wc -l)"
en_built_count="$(find _site/en/posts -type f -name '*.html' | wc -l)"
[[ "$es_built_count" -gt 0 && "$es_built_count" -eq "$en_built_count" ]] || {
  echo "ES/EN generated post counts differ: $es_built_count != $en_built_count" >&2
  exit 1
}

if [[ "${CWS_TEST_INJECT_BROKEN_LINK:-}" == "1" ]]; then
  printf '<a href="/definitely-missing-cws-test">broken test link</a>\n' >> _site/index.html
fi

bundle exec ruby /app/scripts/prepare-proof-tree.rb _site netlify.toml
bundle exec htmlproofer _site \
  --disable-external \
  --no-enforce-https \
  --allow-missing-href \
  --ignore-missing-alt \
  --root-dir "$PWD/_site"

bundle exec ruby /app/scripts/test-http-server.rb _site 4173 &
server_pid="$!"

for _attempt in {1..50}; do
  if curl --silent --fail --output /dev/null http://127.0.0.1:4173/; then
    break
  fi
  sleep 0.1
done

[[ "$(curl --silent --output /dev/null --write-out '%{http_code}' http://127.0.0.1:4173/)" == "200" ]]
[[ "$(curl --silent --output /dev/null --write-out '%{http_code}' http://127.0.0.1:4173/en/)" == "200" ]]

for missing_path in /missing-cws-test /en/missing-cws-test; do
  response_file="$test_root/404-response.html"
  [[ "$(curl --silent --output "$response_file" --write-out '%{http_code}' "http://127.0.0.1:4173$missing_path")" == "404" ]]
  grep -q 'class="error-404"' "$response_file"
done

playwright_args=("--config=$source_dir/playwright.config.js")
if [[ "${CWS_UPDATE_VISUAL_BASELINES:-}" == "1" ]]; then
  playwright_args+=("--update-snapshots")
fi

CWS_TEST_BASE_URL=http://127.0.0.1:4173 \
PLAYWRIGHT_OUTPUT_DIR="$test_root/playwright-results" \
NODE_PATH=/opt/codesai-tests/node_modules \
npm --prefix /opt/codesai-tests run test:e2e -- "${playwright_args[@]}"

if [[ "${CWS_UPDATE_VISUAL_BASELINES:-}" == "1" ]]; then
  mkdir -p /app/tests/e2e/visual.spec.js-snapshots
  cp -a "$source_dir/tests/e2e/visual.spec.js-snapshots/." \
    /app/tests/e2e/visual.spec.js-snapshots/
fi

echo "Site validation passed ($es_built_count posts in each language)."
