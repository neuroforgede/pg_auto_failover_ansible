from flask import Flask
from psycopg2 import Error
import psycopg2
import logging
from config import servers


app = Flask(__name__)
logger = logging.getLogger(__name__)

def check_alive(server):
    connection = None
    try:
        # Connect to an existing database
        connection = psycopg2.connect(server['dsn'])

        # Create a cursor to perform database operations
        cursor = connection.cursor()
        
        cursor.execute(server['healthcheck'])
        # Fetch result
        record = cursor.fetchone()
        
        if record[0] == 1:
            return True

    except (Exception, Error) as error:
        logger.error("Error while checking health for " + server["display_name"], exc_info=True)
    finally:
        if connection is not None:
            try:
                cursor.close()
            finally:
                connection.close()
    return False


@app.route("/api/v1/pg/health")
@app.errorhandler(500)
def health():
    ret = {}
    for key, server in servers.items():
        ret[key] = check_alive(server)
    all_healthy = all(ret.values())
    if not all_healthy:
        return ret, 503
    return ret