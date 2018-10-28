FROM ruby:2.2
ENV APP_HOME /app
ENV BUILD /build
ENV COMMENT_DATABASE_HOST comment_db
ENV COMMENT_DATABASE comments
WORKDIR $BUILD
COPY Gemfile* $BUILD/
RUN apt-get update -qq && apt-get install -y build-essential=11.7 --no-install-recommends \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
RUN bundle install

WORKDIR $APP_HOME
COPY . $APP_HOME
CMD ["puma"]
