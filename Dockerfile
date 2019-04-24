FROM elixir:1.8-alpine AS build

COPY . .

# Install build dependencies for RocksDB
RUN apk add cmake build-base linux-headers

# Clean build directory, fetch dependencies and build release
RUN rm -rf _build && \
    rm -rf deps && \
    mix local.hex --force && \
    mix local.rebar --force && \
    mix deps.get && \
    mix release.init && \
    MIX_ENV=prof mix release

# Extract Release archive to /rel for copying in next stage, please change the application name 
RUN APP_NAME="panacea" && \
    RELEASE_DIR=`ls -d _build/prod/rel/$APP_NAME/releases/*/` && \
    mkdir /export && \
    tar -xf "$RELEASE_DIR/$APP_NAME.tar.gz" -C /export

# Deployment Stage
FROM erlang:21.3.5-alpine 

# Copy extracted tarball
COPY --from=build export/ .

# Set default entrypoint and command
ENTRYPOINT ["/opt/app/bin/panacea"]
CMD ["foreground"]




