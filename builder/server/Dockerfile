#------------------------------------------------------------------------------
# Wrilya Project Builder 
#------------------------------------------------------------------------------
FROM us-central1-docker.pkg.dev/rooster-ship-framework/wrilya/elixir:latest AS builder

# Set the release type, this will be usefull in the future if we happen to 
# separate the releses and deployments. More changes to this Dockerfile should 
# be needed as well as the rel/overlays/bin scripts.
ARG RELEASE_TYPE="wrilya"
ENV RELEASE=$RELEASE_TYPE 

RUN apk update && apk add --no-cache git

# prepare build dir
WORKDIR /app

# install hex + rebar
RUN mix local.hex --force && \
  mix local.rebar --force

# set build ENV
ENV MIX_ENV="prod"

# install mix dependencies
COPY mix.exs mix.lock vsn.txt ./

COPY config config
COPY deps deps
COPY apps apps
COPY rel rel
RUN chmod -R 755 rel
# RUN cd apps/wrilya_web/assets && npm install && cd ../ && mix assets.deploy && mix phx.digest
RUN cd apps/wrilya_web/ && mix assets.deploy
RUN mix compile
RUN mix release $RELEASE

#------------------------------------------------------------------------------
# Wrilya Node 
#------------------------------------------------------------------------------
# start a new build stage so that the final image will only contain
# the compiled release and other runtime necessities
FROM alpine:3.19 AS App

ARG RELEASE_TYPE="wrilya"
ENV RELEASE=$RELEASE_TYPE 

RUN apk update && apk add --no-cache openssl ncurses-libs libstdc++ libgcc curl bash nano ca-certificates redis postgresql-client iputils

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

WORKDIR "/app"
RUN chown nobody /app

# set runner ENV
ENV MIX_ENV="prod"

# Only copy the final release from the build stage
COPY --from=builder --chown=nobody:root /app/_build/prod/rel/wrilya ./

USER nobody
ENV HOME=/app
ENTRYPOINT [ "sh", "bin/wrilya_entrypoint", "deploy"]