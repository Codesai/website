configure:
	git remote add ghpages git@github.com:Codesai/codesai.github.io.git

start: stop
	docker-compose build
	docker-compose up

publish: stop
	docker-compose build
	docker-compose run web jekyll build
	git subtree add --prefix _site 
	git subtree push --prefix _site ghpages master

stop:
	docker-compose down -v --rmi all