# How to test

1. run `bash setup_for_test.sh`
2. Modify the Vagrantfile to load the correct operating system you are testing against.
3. There is a hosts.libvirt.yml file that you can use if you are running Vagrant with libvirt instead of VirtualBox.
4. run `bash run.sh <postgres version: 14_2.1, 15_2.1 or 16_2.1>`
5. run `bash cleanup.sh` to remove and readd host keys and do a little cleanup as well.
