#!/bin/bash
LOGFILE=/var/log/nginx/access.log
REPORT_PATH=/srv/www/ep-stats/stats.html
LOG_DB_PATH=/home/ubuntu/logs/db
GEO_DATABASE_FILE=$(find /home/ubuntu/logs -maxdepth 1 -type f -iname "*.mmdb" | head -1)


FORMAT_NGINX='%h %^[%d:%t %^] "%r" %s %b "%R" "%u"'
FORMAT_DOCKER='%^[%d:%t %^] "%r" %s %b "%R" "%u" "~h{, }"'
FORMAT_DOCKER_TIME='%^[%d:%t %^] "%r" %s %b "%R" "%u" "~h{, }" rt=%T'

goaccess ${LOGFILE} \
    -o ${REPORT_PATH} \
    --ignore-crawlers --no-query-string --anonymize-ip \
    --log-format="${FORMAT_DOCKER_TIME}" \
    --time-format='%H:%M:%S' --date-format='%d/%b/%Y' \
    --geoip-database ${GEO_DATABASE_FILE} \
    --db-path ${LOG_DB_PATH} \
    --addr=127.0.0.1 \
    --restore --real-time-html --ping-interval=50

