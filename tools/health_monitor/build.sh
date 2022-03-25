 #!/bin/bash
 docker build -f Dockerfile \
    -t neuroforgede/pg_auto_failover_health_monitor:latest \
    -t neuroforgede/pg_auto_failover_health_monitor:0.1 \
    .

docker push neuroforgede/pg_auto_failover_health_monitor:latest
docker push neuroforgede/pg_auto_failover_health_monitor:0.1