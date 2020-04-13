rm -r af-monitor-01
rm -r af-database-01
rm -r af-database-02

bash gen_server_cert.sh root_ca af-monitor-01/postgres_server 116.203.218.49 yJpYDPpTaX7kK6kjpz7Gvu7SV5DeWBj6
bash gen_server_cert.sh root_ca af-database-01/postgres_server 116.203.218.75 4wNxA9Uaut5BtMTR3tdExU5xGGMRs4p4
bash gen_server_cert.sh root_ca af-database-02/postgres_server 49.12.9.15 zkF8SU8Q2uNz3bBsJQ94F6Gx5DbcEgJ5

mkdir -p ../../files/certs

rm -rf ../../files/certs/af-monitor-01
rm -rf ../../files/certs/af-database-01
rm -rf ../../files/certs/af-database-02

cp -r af-monitor-01 ../../files/certs
cp -r af-database-01 ../../files/certs
cp -r af-database-02 ../../files/certs