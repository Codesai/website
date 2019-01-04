configure:
	git remote add ghpages git@github.com:Codesai/codesai.github.io.git

start:
	docker-compose up

publish:
	git subtree push --prefix _site ghpages master