#!/bin/bash
set -m

API_URL="http://localhost:80/api"

RET=1
while [[ RET -ne 0 ]]; do
  echo "=> Waiting for confirmation of Grafana startup..."
  sleep 1
  curl -s --basic --user admin:admin ${API_URL} 1> /dev/null 2> /dev/null
  RET=$?
done

curl -s --basic --user admin:admin -X POST http://localhost:80/api/datasources \
    -H "Content-Type: application/json" -d "{ \
  \"name\":\"influxdb\",                      \
  \"type\":\"influxdb\",                      \
  \"url\":\"http://localhost:8086\",          \
  \"access\":\"proxy\",                       \
  \"basicAuth\":false,                        \
  \"password\":\"${INFLUXDB_DATA_PW}\",       \
  \"user\":\"${INFLUXDB_DATA_USER}\",         \
  \"database\":\"${PRE_CREATE_DB}\",          \
  \"isDefault\": true                         \
}"

echo
echo "=> Grafana has been configured as follows:"
echo "   InfluxDB DB DATA NAME:  ${PRE_CREATE_DB}"
echo "   InfluxDB USERNAME: ${INFLUXDB_DATA_USER}"
echo "   InfluxDB PASSWORD: ${INFLUXDB_DATA_PW}"
echo "   ** Please check your environment variables if you find something is misconfigured. **"
echo "=> Done!"

touch /media/grafana/.configured

exit 0
