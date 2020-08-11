#!/bin/bash

/usr/bin/flock -n /tmp/postgres-dump.lck bash /data/ansible/pg_dump/dump_all.sh