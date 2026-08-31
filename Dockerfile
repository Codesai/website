FROM ruby:3.1.4

RUN apt-get update && apt-get install -y pngcrush optipng pngquant advancecomp jpegoptim jhead gifsicle nodejs npm

RUN npm install -g svgo

RUN gem install bundler -v 2.4.22

WORKDIR /app

COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
RUN bundle install --verbose

COPY package.json package-lock.json /opt/codesai-tests/
RUN npm --prefix /opt/codesai-tests ci \
    && /opt/codesai-tests/node_modules/.bin/playwright install --with-deps chromium

COPY . .
