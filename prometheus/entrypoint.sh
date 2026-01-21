#!/bin/sh
TEMPLATE="/etc/prometheus/prometheus.template.yml"
CONFIG="/tmp/prometheus.yml"

RETENTION="${PROMETHEUS_RETENTION:-15d}"

if [ -z "$PROD_IP" ]; then
    echo "PROD_IP environment variable is missing!"
    exit 1
fi

if [ -z "$UAT_IP" ]; then
    echo "UAT_IP environment variable is missing!"
    exit 1
fi

sed -e "s|\${PROD_IP}|$PROD_IP|g" \
    -e "s|\${UAT_IP}|$UAT_IP|g" \
    "$TEMPLATE" > "$CONFIG"
exec /bin/prometheus \
    --config.file="$CONFIG" \
    --storage.tsdb.path=/prometheus \
    --storage.tsdb.retention.time="$RETENTION" \
    --web.console.libraries=/usr/share/prometheus/console_libraries \
    --web.console.templates=/usr/share/prometheus/consoles \
    "$@"