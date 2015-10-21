#!/bin/bash
set -m

if [ -f /.grafana_configured ]; then
    echo "=> grafana has been configured!"
    exit 0
fi

#echo "=> Configuring grafana"
#sed -i -e "s/<--DATA_USER-->/${INFLUXDB_DATA_USER}/g" \
#		-e "s/<--DATA_PW-->/${INFLUXDB_DATA_PW}/g" \
#		-e "s/<--GRAFANA_USER-->/${INFLUXDB_GRAFANA_USER}/g" \
#		-e "s/<--GRAFANA_PW-->/${INFLUXDB_GRAFANA_PW}/g" /src/grafana/config.js

cd /usr/share/grafana
/usr/sbin/grafana-server --config=/etc/grafana/grafana.ini cfg:default.paths.data=/media/grafana cfg:default.paths.logs=/var/log/grafana &

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
  \"name\":\"influxdb\",              \
  \"type\":\"influxdb\",              \
  \"url\":\"http://localhost:8086\",  \
  \"access\":\"direct\",              \
  \"basicAuth\":false,               \
  \"password\":\"${INFLUXDB_GRAFANA_PW}\",  \
  \"user\":\"${INFLUXDB_GRAFANA_USER}\",    \
  \"database\":\"data\",
  \"isDefault\": true \
}"

touch /.grafana_configured

echo "=> Grafana has been configured as follows:"
echo "   InfluxDB DB DATA NAME:  data"
echo "   InfluxDB USERNAME: ${INFLUXDB_DATA_USER}"
echo "   InfluxDB PASSWORD: ${INFLUXDB_DATA_PW}"
echo "   InfluxDB DB GRAFANA NAME:  grafana"
echo "   InfluxDB USERNAME: ${INFLUXDB_GRAFANA_USER}"
echo "   InfluxDB PASSWORD: ${INFLUXDB_GRAFANA_USER}"
echo "   ** Please check your environment variables if you find something is misconfigured. **"
echo "=> Done!"
exit 0
