configure:
	git remote add ghpages git@github.com:Codesai/codesai.github.io.git
	git worktree add _site ghpages

start: stop
	docker-compose build
	docker-compose up

publish: stop
	docker-compose build
	docker-compose run web jekyll build
	cd _site
	git add -A
	git commit "Deployment"
	git push ghpages master --force

stop:
	docker-compose down -v --rmi all