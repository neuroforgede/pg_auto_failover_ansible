# pg_auto_failover_health_monitor
Simple service to keep track of the current pg_auto_failover health so that you can use tools like uptime kuma to monitor.


## Usage

Create a config.py in your directory similar to this:

```
servers = {
    "monitor": {
        "display_name": "monitor",
        "dsn": "postgresql://healthuser:healthuser@10.0.0.10:5433/pg_auto_failover?connect_timeout=1",
        "healthcheck": "SELECT MIN(health) FROM pgautofailover.node"
    },
    "node01": {
        "display_name": "node01",
        "dsn": "postgresql://testuser:password1@10.0.0.11:5433/testdb?connect_timeout=1",
        "healthcheck": "SELECT 1"
    },
    "node02": {
        "display_name": "node01",
        "dsn": "postgresql://testuser:password1@10.0.0.12:5433/testdb?connect_timeout=1",
        "healthcheck": "SELECT 1"
    },
}
```

Then run the docker container as such:

```
docker run -v $(pwd)/config.py:/monitor/config.py:ro -p 8080:8080 --rm neuroforgede/pg_auto_failover_health_monitor:0.1
```

Then you will be able to check health like this:

```
curl --fail http://localhost:8080/api/v1/pg/health
```

If everything is fine (HTTP status = 200) like this:

```
{"monitor":true,"node01":true,"node02":true}
```

If the service is unavailable you will get this output:

```
curl: (22) The requested URL returned error: 503 SERVICE UNAVAILABLE
```

If you leave out `--fail` you get an output like this on a failure:

```
{"monitor":false,"node01":true,"node02":true}
```