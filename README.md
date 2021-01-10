# Overview

All the code for the (as-of-yet-unlaunched) cryptomarketdepth.com website.

This website will track the liquidity of cryptocurrencies over time. Specifically, it can answer the question "*how much of a given cryptocurrency can I buy/sell right now while not moving its price by more than some specified percentage?*".

For further details see [this paper](https://github.com/runeksvendsen/order-graph/blob/26552b74f04fadc36f6ec3cfc3bccf612e9c5732/doc/RuneKSvendsen-CryptocurrencyLiquidity-Project2019.pdf).

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


## `crypto-orderbook-db-app`

Contains `orderbook-service` executable.

## `order-graph`

Implements the graph algorithm used to calculate cryptocurrency liquidity, as described in [this paper](https://github.com/runeksvendsen/order-graph/blob/26552b74f04fadc36f6ec3cfc3bccf612e9c5732/doc/RuneKSvendsen-CryptocurrencyLiquidity-Project2019.pdf).

## `orderbook`

A library implementing a limit order book.

## `crypto-venues`

A library for fetching order books from several different cryptocurrency exchanges. Includes request rate limiting (on a per-exchange basis), as well as retrying failed requests (e.g. due to HTTP "*too many requests*"-error).

## `crypto-orderbook-db`

Database schema for [`crypto-orderbook-db-app`](#crypto-orderbook-db-app).

## `bellman-ford`

**TODO**

## `crypto-liquidity-db`

**TODO**
