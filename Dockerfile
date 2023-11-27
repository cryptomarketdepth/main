## Dockerfile for "coinmarketdepth-com"
##
## This file builds an image that contains all this project's executables.

FROM ubuntu:16.04 as builder

RUN apt-get update \
  && apt-get install -y curl libpq-dev postgresql=9.5+173ubuntu0.3 postgresql-common libgmp10

RUN curl -sSL https://get.haskellstack.org/ | sh

# matches resolver in stack.yaml
# this step fails if performed after copying stack.yaml
RUN stack --resolver lts-14.17 setup

# required by dependency: gargoyle-postgresql-nix
ENV PATH="/usr/lib/postgresql/9.5/bin:$PATH"

COPY cabal.project ./
COPY cabal.project.freeze ./
COPY stack.yaml ./
COPY stack.yaml.lock ./

# copy dependency information
COPY orderbook/package.yaml ./orderbook/package.yaml
COPY bellman-ford/package.yaml ./bellman-ford/package.yaml
COPY crypto-venues/package.yaml ./crypto-venues/package.yaml
COPY order-graph/package.yaml ./order-graph/package.yaml
COPY crypto-orderbook-db/package.yaml ./crypto-orderbook-db/package.yaml
COPY crypto-orderbook-db-app/package.yaml ./crypto-orderbook-db-app/package.yaml
COPY crypto-liquidity-db/package.yaml ./crypto-liquidity-db/package.yaml

RUN stack install --dependencies-only

COPY orderbook ./orderbook
COPY bellman-ford ./bellman-ford
COPY crypto-venues ./crypto-venues

COPY order-graph ./order-graph
COPY crypto-orderbook-db ./crypto-orderbook-db
COPY crypto-orderbook-db-app ./crypto-orderbook-db-app
COPY crypto-liquidity-db ./crypto-liquidity-db

RUN stack build --test --no-run-tests --copy-bins --local-bin-path /tmp/dist/
# copy crypto-liquidity-db test-suite executable to /tmp/dist/
RUN cp "$(find . -name crypto-liquidity-db-test -type f)" /tmp/dist/

# RUNTIME
FROM ubuntu:16.04 as runtime

RUN apt-get update \
  && apt-get install -y ca-certificates libpq-dev postgresql=9.5+173ubuntu0.3 postgresql-common libgmp10

# copy all executables
COPY --from=builder /tmp/dist/* /usr/local/bin/

COPY crypto-liquidity-db/pgsql ./pgsql
