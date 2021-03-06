#! /bin/sh
### BEGIN INIT INFO
# Provides: youtrack
# Required-Start: $local_fs $remote_fs
# Required-Stop: $local_fs $remote_fs
# Default-Start: 2 3 4 5
# Default-Stop: S 0 1 6
# Short-Description: initscript for youtrack
# Description: initscript for youtrack
### END INIT INFO

export HOME=/home/{{ app_name }}

set -e

PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
NAME={{ app_name }}
SCRIPT=/usr/local/$NAME/$NAME.sh

d_start() {
  su {{ app_name }} -l -c "$SCRIPT start"
}

d_stop() {
  su {{ app_name }} -l -c "$SCRIPT stop"
}

case "$1" in
  start)
    echo "Starting $NAME..."
    d_start
  ;;
  stop)
    echo "Stopping $NAME..."
    d_stop
  ;;
  restart|force-reload)
    echo "Restarting $NAME..."
    d_stop
    d_start
  ;;
  *)
    echo "Usage: sudo /etc/init.d/{{ app_name }} {start|stop|restart}" >&2
    exit 1
  ;;
esac

exit 0
