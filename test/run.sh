#!/bin/bash

# we are testing, ignore host key checking
ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i inventory/hosts.yml ../base_setup.yml 
ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i inventory/hosts.yml ../postgres_cluster_servers.yml