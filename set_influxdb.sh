#!/bin/bash

set -m
CONFIG_FILE="/etc/influxdb/config.toml"

API_URL="http://localhost:8086"

echo "=> About to create the following database: ${PRE_CREATE_DB}"

arr=$(echo ${PRE_CREATE_DB} | tr ";" "\n")

# Wait for the startup of influxdb.
RET=1
while [[ RET -ne 0 ]]; do
    echo "=> Waiting for confirmation of InfluxDB service startup ..."
    sleep 3
    curl -k ${API_URL}/ping 2> /dev/null
    RET=$?
done
echo

for x in $arr
do
    echo "=> Creating database: ${x}"
    curl -s -G ${API_URL}'/query' --data-urlencode "q=CREATE DATABASE \"${x}\""
done
echo

echo "=> Creating User for database: data"
curl -s -G ${API_URL}'/query' --data-urlencode \
    "q=CREATE USER \"${INFLUXDB_DATA_USER}\" WITH PASSWORD '${INFLUXDB_DATA_PW}'"
echo

touch /media/influxdb/.configured

exit 0
