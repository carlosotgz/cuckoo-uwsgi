FROM cuckoo:2.0

MAINTAINER Carlos Ortigoza Dempster

RUN apk add --no-cache uwsgi uwsgi-python

COPY check_resultserver.py /check_resultserver.py

COPY *.ini /etc/uwsgi/apps-enabled/
COPY docker-entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
