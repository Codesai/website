FROM ruby:2.7

RUN apt-get update && apt-get install -y pngcrush optipng pngquant advancecomp jpegoptim jhead gifsicle nodejs npm

RUN npm install -g svgo

RUN gem install bundler

WORKDIR /app

COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
RUN bundle install --verbose

COPY . .

