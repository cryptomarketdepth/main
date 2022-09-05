[![Docker Compose Actions Workflow](https://github.com/cryptomarketdepth/main/actions/workflows/push.yml/badge.svg?branch=main)](https://github.com/cryptomarketdepth/main/actions/workflows/push.yml)

# Overview

Code for the [cryptomarketdepth.com](https://cryptomarketdepth.com/) website.

This website tracks the liquidity of cryptocurrencies over time. Specifically, it can answer the question "*how much of a given cryptocurrency can I buy/sell right now while not moving its price by more than some specified percentage?*".

For further details see [this paper](https://github.com/runeksvendsen/order-graph/blob/26552b74f04fadc36f6ec3cfc3bccf612e9c5732/doc/RuneKSvendsen-CryptocurrencyLiquidity-Project2019.pdf).

# Running

Services can be run using `docker-compose`. The following command builds service images and runs the services:

```
docker-compose up --build
```

The service [`liquidity-service-process`](#liquidity-service-process) service is highly scalable. You can run multiple instances of this service to increase processing throughput like so:

```
docker-compose up --scale liquidity-service-process=10
```

# Testing

1. Build and run all services using `docker-compose up -d --build`

2. Run the command from the "run tests"-step in [the GitHub Actions file](.github/workflows/push.yml).

# Services


## `orderbook-service`

Regularly fetches order books from multiple cryptocurrency exchanges and writes them to the database.


## `liquidity-service-create`

Creates “jobs” which describe -- among other things -- the cryptocurrency for which to calculate liquidity, and the input data (order books) for the calculation.

## `liquidity-service-process`

Atomically claims a job, performs the liquidity calculation described by the job, and writes the result to the database. This service is highly scalable, such that multiple instances of this service can run concurrently to process calculations in parallel.

## `liquidity-web-api`

Website backend HTTP API. Reads data from the database written by `liquidity-service-process` and returns it as JSON.


# Packages

## `frontend`

Frontend code for the public website https://cryptomarketdepth.com/

## `crypto-orderbook-db-app`

Contains [`orderbook-service`](#orderbook-service) executable.

## `order-graph`

Implements the graph algorithm used to calculate cryptocurrency liquidity, as described in [this paper](https://github.com/runeksvendsen/order-graph/blob/26552b74f04fadc36f6ec3cfc3bccf612e9c5732/doc/RuneKSvendsen-CryptocurrencyLiquidity-Project2019.pdf).

## `orderbook`

A library implementing a limit order book.

## `crypto-venues`

A library for fetching order books from several different cryptocurrency exchanges. Includes request rate limiting (on a per-exchange basis), as well as retrying failed requests (e.g. due to HTTP "*too many requests*"-error).

## `crypto-orderbook-db`

Database schema for [`orderbook-service`](#orderbook-service).

## `bellman-ford`

Translation of Sedgewick & Wayne's `BellmanFordSP.java` implementation into Haskell.

## `crypto-liquidity-db`

Contains both schema and executables for the services [`liquidity-service-create`](#liquidity-service-create), [`liquidity-service-process`](#liquidity-service-process), and  [`liquidity-web-api`](#liquidity-web-api).
