FROM ruby:2.7-alpine3.15

RUN apk update && apk add --no-cache build-base

RUN gem install bundler

WORKDIR /app

COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.Gemfile.lock
RUN bundle install

COPY . .

