## Dockerfile for "coinmarketdepth-com"
##
## This file builds an image that contains all this project's executables.

FROM ubuntu:16.04 as builder

RUN apt-get update \
  && apt-get install -y curl libpq-dev postgresql=9.5+173ubuntu0.3 postgresql-common libgmp10

RUN curl -sSL https://get.haskellstack.org/ | sh

# Pre-install deps so we can re-use cached layers
# https://github.com/freebroccolo/docker-haskell/issues/54#issuecomment-283222910
COPY stack.yaml ./
COPY package.yaml ./
RUN stack setup

# required by dependency: gargoyle-postgresql-nix
ENV PATH="/usr/lib/postgresql/9.5/bin:$PATH"

RUN stack install --dependencies-only

COPY cabal.project ./
COPY cabal.project.freeze ./
COPY stack.yaml ./
COPY stack.yaml.lock ./
COPY bellman-ford ./
COPY crypto-liquidity-db ./
COPY crypto-orderbook-db ./
COPY crypto-orderbook-db-app ./
COPY crypto-venues ./
COPY order-graph ./
COPY orderbook ./

RUN stack build --copy-bins --local-bin-path /tmp/dist/

# RUNTIME
FROM ubuntu:16.04 as runtime

RUN apt-get update \
  && apt-get install -y ca-certificates libpq-dev postgresql=9.5+173ubuntu0.3 postgresql-common libgmp10

# copy all executables
COPY --from=builder /tmp/dist/crypto-orderbook-service /usr/local/bin/
COPY --from=builder /tmp/dist/crypto-liquidity-web-api /usr/local/bin/
COPY --from=builder /tmp/dist/crypto-liquidity-service-process /usr/local/bin/
COPY --from=builder /tmp/dist/crypto-liquidity-service-create /usr/local/bin/