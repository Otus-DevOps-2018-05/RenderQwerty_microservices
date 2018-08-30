FROM ubuntu:16.04
ENV APP_HOME /app
ENV POST_SERVICE_HOST post
ENV POST_SERVICE_PORT 5000
ENV COMMENT_SERVICE_HOST comment
ENV COMMENT_SERVICE_PORT 9292
WORKDIR $APP_HOME

COPY Gemfile* $APP_HOME/
RUN apt-get update -qq \
    && apt-get install -y --no-install-recommends \
    ruby-full=1:2.3.0+1 \
    ruby-dev=1:2.3.0+1 \
    build-essential=12.1ubuntu2 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && gem install bundler --no-ri --no-rdoc

RUN bundle install
COPY . $APP_HOME

CMD ["puma"]
