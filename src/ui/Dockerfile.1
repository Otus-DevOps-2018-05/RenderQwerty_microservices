FROM alpine:3.5
ENV APP_HOME /app
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

RUN apk add --update --no-cache \
    build-base=0.4-r1 \
    ruby=2.3.7-r0 \
    ruby-bundler=1.13.4-r0 \
    ruby-dev=2.3.7-r0 \
    ruby-io-console=2.3.7-r0 \
    ruby-json=2.3.7-r0 \
    ruby-rake=2.3.7-r0 \
    && gem install bundler --no-ri --no-rdoc

COPY Gemfile* $APP_HOME/
RUN bundle install
COPY . $APP_HOME

ENV POST_SERVICE_HOST post
ENV POST_SERVICE_PORT 5000
ENV COMMENT_SERVICE_HOST comment
ENV COMMENT_SERVICE_PORT 9292
CMD ["puma"]
