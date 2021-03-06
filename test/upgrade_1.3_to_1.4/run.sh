#!/bin/bash

check_setup() {
  node_1_check_recovery=`PGPASSWORD=password1 psql -h 10.0.0.21 -p 5433 -t -X -A -c 'select pg_is_in_recovery()' --username testuser -d testdb`
  node_2_check_recovery=`PGPASSWORD=password1 psql -h 10.0.0.22 -p 5433 -t -X -A -c 'select pg_is_in_recovery()' --username testuser -d testdb`

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
}

# we are testing, ignore host key checking
ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i inventory/hosts.yml ../../base_setup.yml 
ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i inventory/hosts.yml ../../postgres_cluster_servers.yml

check_setup

# TODO: check if version is == 1.3

echo "Setup with 1.3 successful, upgrading to 1.5 now..."

ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i inventory/hosts.yml ../../postgres_cluster_upgrade_pre_1.4.yml --extra-vars='{"postgresql_new_pg_auto_failover_version": "1.5"}'

check_setup

# TODO: check if version is == 1.5

echo ""
echo "Finished tests. OK"