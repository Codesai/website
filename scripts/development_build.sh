#!/usr/bin/env bash

set -euo pipefail

bundle exec jekyll serve --host 0.0.0.0 --force_polling --config _config.yml,_local_config.yml
