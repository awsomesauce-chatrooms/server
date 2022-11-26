FROM ruby:alpine

RUN apk update && apk add --no-cache build-base ncurses-dev

RUN bundle config --global frozen 1

WORKDIR /

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

CMD ["ruby", "main.rb"]
