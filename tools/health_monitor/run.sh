#!/bin/bash

log_level="warning"
worker_timeout="30"
gunicorn_access_log_format='%(h)s %(l)s %({x-forwarded-for}i)s %(l)s %(u)s %(t)s "%(r)s" %(s)s %(b)s "%(f)s" "%(a)s"'
worker_count="3"
gunicorn_limit_request_line="4094"
bind_ip="0.0.0.0"

echo "starting gunicorn..."
exec gunicorn \
    --timeout "${worker_timeout}" \
    --capture-output \
    --access-logfile - \
    --error-logfile - \
    --log-file - \
    --log-level $log_level \
    --access-logformat "$gunicorn_access_log_format" \
    --workers=$worker_count \
    --limit-request-line "$gunicorn_limit_request_line" \
    -b $bind_ip:8080 \
    monitor:app