#!/usr/bin/env bash

set -euo pipefail

mkdir -p _i18n/en/_posts
cp -a _i18n/es/_posts/. _i18n/en/_posts/

bundle exec jekyll serve --host 0.0.0.0 --force_polling --config _config.yml,_local_config.yml
