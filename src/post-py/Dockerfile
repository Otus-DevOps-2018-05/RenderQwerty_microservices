FROM python:3.6.0-alpine
RUN apk update && apk add gcc musl-dev
ENV POST_DATABASE_HOST post_db
ENV POST_DATABASE posts
ENV APP_HOME /app
WORKDIR /build
COPY requirements.txt .
RUN pip install -r requirements.txt

WORKDIR $APP_HOME
COPY . $APP_HOME/
ENTRYPOINT ["python3", "post_app.py"]
