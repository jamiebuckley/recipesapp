FROM ruby:3.1.2-alpine

ENV BUNDLER_VERSION=2.0.2

RUN apk add --update --no-cache \
    build-base \
    nodejs \
      yarn \
      postgresql-dev  \
      postgresql-client \
      vips \
    tzdata

RUN gem install bundler

WORKDIR /app

COPY Gemfile Gemfile.lock ./

RUN bundle check || bundle install

COPY package.json yarn.lock ./

RUN yarn install --check-files

COPY . ./

RUN yarn build

RUN yarn build:css

ENTRYPOINT ["./entrypoints/docker-entrypoint.sh"]