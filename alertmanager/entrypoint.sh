#!/bin/sh

TEMPLATE="/etc/alertmanager/alertmanager.template.yml"
CONFIG="/tmp/alertmanager.yml"

if [ -z "$SLACK_WEBHOOK_URL" ]; then
    echo "SLACK_WEBHOOK_URL env variable is missing!"
    exit 1
fi

if [ -z "$SLACK_WEBHOOK_CHANNEL_NAME" ]; then
    echo "SLACK_WEBHOOK_CHANNEL_NAME env variable is missing!"
    exit 1
fi

sed -e "s|\${SLACK_WEBHOOK_URL}|$SLACK_WEBHOOK_URL|g" \
    -e "s|\${SLACK_WEBHOOK_CHANNEL_NAME}|$SLACK_WEBHOOK_CHANNEL_NAME|g" \
    "$TEMPLATE" > "$CONFIG"
exec /bin/alertmanager --config.file="$CONFIG" --storage.path=/alertmanager "$@"