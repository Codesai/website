configure:
	git remote add ghpages git@github.com:Codesai/codesai.github.io.git

start:
	docker-compose build
	docker-compose up

publish:
	docker-compose build
	docker-compose run web jekyll build
	git subtree push --prefix _site ghpages master