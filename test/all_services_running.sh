#!/bin/sh

RUNNING_SERVICES=$(docker-compose ps | grep Up | awk '{print $1}')
ALL_SERVICES="database liquidity-service-create liquidity-service-process liquidity-web-api orderbook-service test-service"

# Iterate the string variable using for loop
for service in $ALL_SERVICES; do
    IS_RUNNING=$(echo "$RUNNING_SERVICES" | grep "$service")
    if [ -z "$IS_RUNNING" ]; then
        echo "Missing service: $service. Running services:"
        echo "$RUNNING_SERVICES"
        exit 1
    else
        echo "Service is running: \"$service\" (container: $IS_RUNNING)"
    fi
done

exit 0