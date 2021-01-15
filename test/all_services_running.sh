#!/bin/sh

RUNNING_SERVICES=$(docker-compose ps | grep Up | awk '{print $1}')
ALL_SERVICES="liquidity-database liquidity-service-create liquidity-service-process liquidity-web-api orderbook-service test-service"

# Iterate the string variable using for loop
for service in $ALL_SERVICES; do
    IS_RUNNING=$(echo $RUNNING_SERVICES | grep "$service")
    [ -z "$IS_RUNNING" ] && echo "Missing service: $service. Running services:" && echo "$RUNNING_SERVICES" && exit 1
done
