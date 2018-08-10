FROM alpine:3.6

RUN apk --update add \
      build-base python3-dev \
      ca-certificates python3 \
      ttf-droid \
      py-pip \
      py-jinja2 \
      py-twisted \
      py-dateutil \
      py-tz \
      py-requests \
      py-pillow \
      py-rrd && \
    pip3 install --upgrade pip && \
    pip3 install --upgrade arrow \
                          pymongo \
                          websocket-client \
                          XlsxWriter && \
    apk del build-base python3-dev && \
    rm -rf /var/cache/apk/* 

WORKDIR /usr/src/app

ENV FLASK_APP=app.py

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 5000

COPY . .

CMD [ "python3", "-m", "flask", "run", "--host=0.0.0.0" ]