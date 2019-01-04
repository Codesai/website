configure:
	git remote add ghpages git@github.com:Codesai/codesai.github.io.git
	git worktree add _site ghpages

start: clean
	docker-compose build
	docker-compose up

publish: clean
	docker-compose build
	docker-compose run web jekyll build
	cd _site && \
	git add -A && \
	git commit -m "Deployment" && \
	git push ghpages master --force

clean:
	git clean -fdx
	docker-compose down -v --rmi all