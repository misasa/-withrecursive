FROM ruby:2.3
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app
COPY . /usr/src/app/
RUN bash -l -c 'bundle install'


