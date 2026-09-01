export DOCKER_BUILDKIT=1
export COMPOSE_DOCKER_CLI_BUILD=1

.PHONY: start shell stop test test-links test-playwright lighthouse update-visual-baselines _test-image

start: stop _start
shell: stop _shell

_start:
	docker compose up --build

_shell:
	docker compose build web
	docker compose run web sh

stop:
	docker compose down -v

_test-image:
	docker compose build web

test: test-links test-playwright

test-links: _test-image
	docker compose run --rm -e CWS_TEST_SUITE=links -e CWS_TEST_INJECT_BROKEN_LINK web bash scripts/test-site.sh

test-playwright: _test-image
	docker compose run --rm -e CWS_TEST_SUITE=playwright -e CWS_TEST_BASE_URL web bash scripts/test-site.sh

lighthouse:
	scripts/run-lighthouse.sh

update-visual-baselines: _test-image
	docker compose run --rm -e CWS_TEST_SUITE=playwright -e CWS_UPDATE_VISUAL_BASELINES=1 web bash scripts/test-site.sh
