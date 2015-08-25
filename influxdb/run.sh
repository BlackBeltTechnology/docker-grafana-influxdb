#!/bin/bash

set -m

CONFIG_FILE="/etc/influxdb/config.toml"

echo "=> Starting InfluxDB ..."
exec /opt/influxdb/influxd -config=${CONFIG_FILE}
