FROM ruby:2.7.0

WORKDIR /usr/src/app

COPY Gemfile Gemfile.lock ./
RUN bundle install

ENV LC_ALL=C.UTF-8

CMD bundle exec jekyll serve --config _config.yml,_guide/_config.yml --host 0.0.0.0 --incremental
