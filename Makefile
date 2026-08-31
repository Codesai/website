export DOCKER_BUILDKIT=1
export COMPOSE_DOCKER_CLI_BUILD=1

start: stop _start
shell: stop _shell

_start:
	docker compose up --build

_shell:
	docker compose build web
	docker compose run web sh

stop:
	docker compose down -v

test:
	docker compose build web
	docker compose run --rm -e CWS_TEST_INJECT_BROKEN_LINK web bash scripts/test-site.sh
