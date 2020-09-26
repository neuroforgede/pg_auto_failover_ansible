#!/bin/bash
cd certs
bash setup_for_test.sh

vagrant destroy
vagrant up