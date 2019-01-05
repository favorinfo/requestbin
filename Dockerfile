FROM    fwyit/alpine:ali

ADD     . /opt/requestbin

RUN     apk update && apk upgrade && \
        apk add --no-cache \
            gcc python python-dev py-pip \
            # greenlet
            musl-dev \
            # sys/queue.h
            bsd-compat-headers \
            # event.h
            libevent-dev && \
        PIP_MIRROR=https://pypi.douban.com/simple && \
        pip install -r /opt/requestbin/requirements.txt -i $PIP_MIRROR && \
        rm -rf ~/.pip/cache && \
        rm -rf /var/cache/apk/*

EXPOSE  8000

WORKDIR /opt/requestbin

CMD     gunicorn -b 0.0.0.0:8000 --worker-class gevent --workers 2 --max-requests 1000 requestbin:app


