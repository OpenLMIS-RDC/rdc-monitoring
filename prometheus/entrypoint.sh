#!/bin/sh
TEMPLATE="/etc/prometheus/prometheus.template.yml"
CONFIG="/tmp/prometheus.yml"

REQUIRED_VARS="PROD_IP PROD_URL PROD_REPORTING_IP PROD_REPORTING_URL PROD_NLB_URL
  UAT_IP UAT_URL UAT_REPORTING_IP UAT_REPORTING_URL UAT_NLB_URL"

RETENTION="${PROMETHEUS_RETENTION:-15d}"

cp "$TEMPLATE" "$CONFIG"

for VAR_NAME in $REQUIRED_VARS; do
    eval VAR_VALUE=\$$VAR_NAME

    if [ -z "$VAR_VALUE" ]; then
        echo "ERROR: Environment variable $VAR_NAME is missing!"
        exit 1
    fi

    sed -i "s|\${$VAR_NAME}|$VAR_VALUE|g" "$CONFIG"
done

echo "Config generated successfully."
exec /bin/prometheus \
    --config.file="$CONFIG" \
    --storage.tsdb.path=/prometheus \
    --storage.tsdb.retention.time="$RETENTION" \
    --web.console.libraries=/usr/share/prometheus/console_libraries \
    --web.console.templates=/usr/share/prometheus/consoles \
    "$@"