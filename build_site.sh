#!/bin/bash

cp -r _i18n/es/_posts _i18n/en

bundle exec jekyll build

# Netlify provides COMMIT_REF during builds. Publishing it lets CI wait for the
# exact revision under test instead of relying on a fixed deployment delay.
if [ -n "${COMMIT_REF:-}" ]; then
  printf '{"commit":"%s"}\n' "$COMMIT_REF" > _site/deploy-meta.json
fi
