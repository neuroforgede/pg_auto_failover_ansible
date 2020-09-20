rm -r test

bash gen_server_cert.sh root_ca test/monitor/postgres_server 10.0.0.10 yJpYDPpTaX7kK6kjpz7Gvu7SV5DeWBj6
bash gen_server_cert.sh root_ca test/node1/postgres_server 10.0.0.11 yJpYDPpTaX7kK6kjpz7Gvu7SV5DeWBj6
bash gen_server_cert.sh root_ca test/node2/postgres_server 10.0.0.12 yJpYDPpTaX7kK6kjpz7Gvu7SV5DeWBj6