#!/usr/bin/env bash

set -euo pipefail

readonly LIGHTHOUSE_VERSION="13.4.1"
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly PROJECT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

url="http://localhost:4000/"
profile="both"
runs=3
output_base="docs/lighthouse-local"

usage() {
  printf '%s\n' \
    "Usage: scripts/run-lighthouse.sh [options]" \
    "" \
    "Options:" \
    "  --url URL       URL to audit (default: http://localhost:4000/)" \
    "  --mobile        Run only the mobile profile (default: both profiles)" \
    "  --desktop       Run only the desktop profile (default: both profiles)" \
    "  --runs N        Odd number of sequential runs (default: 3)" \
    "  --output PATH   Report name prefix (default: docs/lighthouse-local)" \
    "  --help          Show this help"
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --url)
      [[ $# -ge 2 ]] || { printf 'Missing value for --url\n' >&2; exit 2; }
      url="$2"
      shift 2
      ;;
    --desktop)
      profile="desktop"
      shift
      ;;
    --mobile)
      profile="mobile"
      shift
      ;;
    --runs)
      [[ $# -ge 2 ]] || { printf 'Missing value for --runs\n' >&2; exit 2; }
      runs="$2"
      shift 2
      ;;
    --output)
      [[ $# -ge 2 ]] || { printf 'Missing value for --output\n' >&2; exit 2; }
      output_base="${2%.html}"
      shift 2
      ;;
    --help|-h)
      usage
      exit 0
      ;;
    *)
      printf 'Unknown option: %s\n' "$1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

if [[ ! "$runs" =~ ^[1-9][0-9]*$ ]] || (( runs % 2 == 0 )); then
  printf -- '--runs must be a positive odd number\n' >&2
  exit 2
fi

for command_name in curl google-chrome node npm npx; do
  command -v "$command_name" >/dev/null 2>&1 || {
    printf 'Required command not found: %s\n' "$command_name" >&2
    exit 1
  }
done

if [[ "$output_base" != /* ]]; then
  output_base="$PROJECT_DIR/$output_base"
fi

export LANG=C
export LC_ALL=C
export TZ=UTC

timestamp="$(date +%Y%m%d-%H%M%S)"
mkdir -p "$(dirname "$output_base")"

curl --fail --silent --show-error --output /dev/null "$url"

temporary_dir="$(mktemp -d)"
trap 'rm -rf "$temporary_dir"' EXIT

run_profile() {
  local current_profile="$1"
  local output="${output_base}-${current_profile}-${timestamp}.html"
  local scores_file="$temporary_dir/${current_profile}-scores.tsv"
  local median_position
  local selected_run
  local run
  local lighthouse_args

  printf '\nLighthouse %s · %s · %s sequential runs\n' \
    "$LIGHTHOUSE_VERSION" "$current_profile" "$runs"

  for ((run = 1; run <= runs; run++)); do
    printf 'Run %s/%s...\n' "$run" "$runs"

    lighthouse_args=(
      "$url"
      "--only-categories=performance,accessibility,best-practices,seo"
      "--output=html"
      "--output=json"
      "--output-path=$temporary_dir/${current_profile}-run-$run"
      "--chrome-path=/usr/bin/google-chrome"
      "--chrome-flags=--headless --no-sandbox --disable-dev-shm-usage"
      "--throttling-method=simulate"
      "--quiet"
    )

    if [[ "$current_profile" == "desktop" ]]; then
      lighthouse_args+=("--preset=desktop")
    fi

    npx --yes "lighthouse@$LIGHTHOUSE_VERSION" "${lighthouse_args[@]}"
  done

  : > "$scores_file"
  for ((run = 1; run <= runs; run++)); do
    node -e '
      const report = require(process.argv[1]);
      const score = Math.round(report.categories.performance.score * 100);
      process.stdout.write(`${score}\t${process.argv[2]}\n`);
    ' "$temporary_dir/${current_profile}-run-$run.report.json" "$run" >> "$scores_file"
  done

  median_position=$((runs / 2 + 1))
  selected_run="$(sort -n -k1,1 -k2,2 "$scores_file" | sed -n "${median_position}p" | cut -f2)"
  cp "$temporary_dir/${current_profile}-run-$selected_run.report.html" "$output"

  printf '\nRun\tPerf\tA11y\tBest practices\tSEO\tLCP ms\tTBT ms\tCLS\n'
  for ((run = 1; run <= runs; run++)); do
    node -e '
      const report = require(process.argv[1]);
      const categories = report.categories;
      const audits = report.audits;
      const values = [
        process.argv[2],
        Math.round(categories.performance.score * 100),
        Math.round(categories.accessibility.score * 100),
        Math.round(categories["best-practices"].score * 100),
        Math.round(categories.seo.score * 100),
        Math.round(audits["largest-contentful-paint"].numericValue),
        Math.round(audits["total-blocking-time"].numericValue),
        audits["cumulative-layout-shift"].numericValue.toFixed(3),
      ];
      process.stdout.write(`${values.join("\t")}\n`);
    ' "$temporary_dir/${current_profile}-run-$run.report.json" "$run"
  done

  printf '\nSaved %s median run %s to %s\n' \
    "$current_profile" "$selected_run" "$output"
}

if [[ "$profile" == "both" ]]; then
  run_profile mobile
  run_profile desktop
else
  run_profile "$profile"
fi
