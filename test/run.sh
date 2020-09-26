#!/bin/bash

# we are testing, ignore host key checking
ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i inventory_$1/hosts.yml ../base_setup.yml 
ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i inventory_$1/hosts.yml ../postgres_cluster_servers.yml

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

echo ""
echo "Finished tests. OK"