rm -r test

bash gen_server_cert.sh root_ca test/monitor/postgres_server 10.0.0.20 yJpYDPpTaX7kK6kjpz7Gvu7SV5DeWBj6
bash gen_server_cert.sh root_ca test/node1/postgres_server 10.0.0.21 yJpYDPpTaX7kK6kjpz7Gvu7SV5DeWBj6
bash gen_server_cert.sh root_ca test/node2/postgres_server 10.0.0.22 yJpYDPpTaX7kK6kjpz7Gvu7SV5DeWBj6