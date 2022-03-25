#!/bin/bash

# we are testing, ignore host key checking
ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i inventory_$1/hosts.yml ../../base_setup.yml 
ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i inventory_$1/hosts.yml ../../postgres_cluster_servers.yml

node_1_check_recovery=`PGPASSWORD=password1 psql -h 10.0.0.11 -p 5433 -t -X -A -c 'select pg_is_in_recovery()' --username testuser -d testdb`
node_2_check_recovery=`PGPASSWORD=password1 psql -h 10.0.0.12 -p 5433 -t -X -A -c 'select pg_is_in_recovery()' --username testuser -d testdb`

sorted=`echo -e "$node_2_check_recovery\n$node_1_check_recovery" | sort`

f_count=`echo $sorted | grep -o f | wc -l`
t_count=`echo $sorted | grep -o t | wc -l`

if [ $t_count == "1" ]; then
  echo "Found exactly one primary. OK"
else
  echo "Did not find exactly one primary. ERROR"
  exit 1
fi

if [ $f_count == "1" ]; then
  echo "Found exactly one secondary. OK"
else
  echo "Did not find exactly one secondary. ERROR"
  exit 1
fi

node_1_pgbouncer_test=`PGPASSWORD=password1 psql "port=6432 user=testuser dbname=testdb host=10.0.0.11 sslmode=allow" -t -X -A -c 'select 1'`
node_2_pgbouncer_test=`PGPASSWORD=password1 psql "port=6432 user=testuser dbname=testdb host=10.0.0.12 sslmode=allow" -t -X -A -c 'select 1'`

if [ "$node_1_pgbouncer_test" == "1" ]; then
  echo "Could authenticate against pgbouncer for node1. OK"
else
  echo "Could not against pgbouncer for node1. ERROR"
  exit 1
fi

if [ "$node_2_pgbouncer_test" == "1" ]; then
  echo "Could authenticate against pgbouncer for node2. OK"
else
  echo "Could not against pgbouncer for node2. ERROR"
  exit 1
fi

echo ""
echo "Finished tests. OK"