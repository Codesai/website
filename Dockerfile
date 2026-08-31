FROM ruby:4.0.6-bookworm

ARG NODE_VERSION=24.20.0

RUN set -eux; \
    case "$(dpkg --print-architecture)" in \
        amd64) node_arch='x64' ;; \
        arm64) node_arch='arm64' ;; \
        *) echo "Unsupported architecture: $(dpkg --print-architecture)" >&2; exit 1 ;; \
    esac; \
    node_archive="node-v${NODE_VERSION}-linux-${node_arch}.tar.xz"; \
    curl -fsSLO "https://nodejs.org/dist/v${NODE_VERSION}/${node_archive}"; \
    curl -fsSLO "https://nodejs.org/dist/v${NODE_VERSION}/SHASUMS256.txt"; \
    grep " ${node_archive}$" SHASUMS256.txt | sha256sum --check -; \
    tar -xJf "${node_archive}" -C /usr/local --strip-components=1; \
    rm "${node_archive}" SHASUMS256.txt; \
    apt-get update; \
    apt-get install -y --no-install-recommends pngcrush optipng pngquant advancecomp jpegoptim jhead gifsicle; \
    rm -rf /var/lib/apt/lists/*

RUN npm install -g svgo

RUN gem install bundler -v 4.0.16

WORKDIR /app

COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
RUN bundle install --verbose

COPY package.json package-lock.json /opt/codesai-tests/
RUN npm --prefix /opt/codesai-tests ci \
    && /opt/codesai-tests/node_modules/.bin/playwright install --with-deps chromium

COPY . .
