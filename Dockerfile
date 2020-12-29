FROM ruby:3.0.0

WORKDIR /usr/src/app

COPY Gemfile Gemfile.lock ./
RUN bundle install

ENV LC_ALL=C.UTF-8

CMD bundle exec jekyll serve --host 0.0.0.0 --incremental
