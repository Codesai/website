FROM ruby:2.7-alpine3.15

RUN echo "@testing http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories


RUN apk update && apk add --no-cache build-base pngcrush optipng pngquant oxipng@testing advancecomp jpegoptim jhead@testing libjpeg-turbo-utils gifsicle nodejs npm

RUN npm install -g svgo

RUN gem install bundler

WORKDIR /app

COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.Gemfile.lock
RUN bundle install

COPY . .

