#!/bin/bash
ssh-keygen -f "/home/fred/.ssh/known_hosts" -R "10.0.0.10"
ssh-keygen -f "/home/fred/.ssh/known_hosts" -R "10.0.0.11"
ssh-keygen -f "/home/fred/.ssh/known_hosts" -R "10.0.0.12"
ssh-keyscan 10.0.0.10 >> "/home/fred/.ssh/known_hosts" 2>/dev/null
ssh-keyscan 10.0.0.11 >> "/home/fred/.ssh/known_hosts" 2>/dev/null
ssh-keyscan 10.0.0.12 >> "/home/fred/.ssh/known_hosts" 2>/dev/null
rm ../../roles/postgres-cluster-pgbouncer-client-setup/userlist.txt
rm -Rf .vagrant
