JEKYLL_VERSION=4.1.0

start:
	docker run --rm \
		-v="$(shell pwd):/srv/jekyll" \
		-p 4000:4000 \
		-it jekyll/jekyll:${JEKYLL_VERSION} \
		jekyll server --watch --drafts --config _config.yml,_local_config.yml
