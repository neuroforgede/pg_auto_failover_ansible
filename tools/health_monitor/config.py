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