# Codesai website

Jekyll based website for Codesai


### Setup

#### Docker

1. Clone the repository
2. Navigate to the jekyll site folder in a terminal
3. Run `docker-compose up`
4. You may access the local website at `localhost:4000`
5. Start coding and jekyll will automatically build after you save changes

If you experience problems with jekyll automatic builds you can start another terminal and run `docker exec -it {name} bash`. You may now use `jekyll build` on demand.
To check the name of your docker container you can run `docker ps`, it may be something like {name_of_jekyll_folder}_web_1.

### Your own environment

1. Clone the repository
2. Install ruby
3. Navigate to the jekyll folder in a terminal.
4. Run `bundle install`
5. Run `jekyll build`
6. Run `jekyll serve`, if on windows run `jekyll serve --force_polling` instead
7. You may access the local website at `localhost:4000`
8. Start coding and jekyll will automatically build after you save changes

If you experience problems with jekyll automatic builds you can start another terminal, navigate to the jekyll site folder and run `jekyll build` on demand.