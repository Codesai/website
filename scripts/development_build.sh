#!/usr/bin/env bash

set -euo pipefail

rm -rf _i18n/en/_posts
mkdir -p _i18n/en/_posts
cp -a _i18n/es/_posts/. _i18n/en/_posts/

rm -rf _i18n/en/_labs
mkdir -p _i18n/en/_labs
cp -a _i18n/es/_labs/. _i18n/en/_labs/

bundle exec jekyll serve --host 0.0.0.0 --force_polling --config _config.yml,_local_config.yml
