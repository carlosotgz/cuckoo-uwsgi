#!/bin/sh

set -e

# Wait for required services based on Cuckoo's configuration files
/check_required_services.py
if [ "$?" -eq 1 ]; then
  exit 1
fi

# Incredibly, Cuckoo has a race condition when it creates the database template:
# https://github.com/cuckoosandbox/cuckoo/issues/1516
# We must make sure Cuckoo daemon ends its stuff before launching Web and API services
/check_resultserver.py
if [ "$?" -eq 1 ]; then
  exit 1
fi

# Change the ownership of /cuckoo to cuckoo, but exclude configuration files
chown -R cuckoo:cuckoo $(ls /cuckoo/ | awk '{if($1 != "conf"){ print $1 }}') /tmp/ && chown cuckoo:cuckoo /cuckoo

# Launch the actual stuff
case "$1" in
	web )
		/usr/sbin/uwsgi --socket 127.0.0.1:${PORT:=8001} \
						--master --enable-threads \
						--processes ${PROCESSES:=1} \
						--threads ${THREADS:=1} \
						--ini /etc/uwsgi/apps-enabled/cuckoo-web.ini
	;;
	api )
		/usr/sbin/uwsgi --socket 127.0.0.1:${PORT:=8002} \
						--master --enable-threads \
						--processes ${PROCESSES:=1} \
						--threads ${THREADS:=1} \
						--ini /etc/uwsgi/apps-enabled/cuckoo-api.ini
	;;
esac
