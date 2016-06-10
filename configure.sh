#!/bin/bash

set -e

export PRE_CREATE_DB=data
export INFLUXDB_DATA_USER=data
export INFLUXDB_DATA_PW=data

if [ ! -f "/media/influxdb/.configured" ]; then
    /set_influxdb.sh
fi

if [ ! -f "/media/grafana/.configured" ]; then
    /set_grafana.sh
fi

exit 0
