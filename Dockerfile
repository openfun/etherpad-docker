# Stateless Etherpad Lite Dockerfile
#
# https://github.com/openfun/etherpad-docker
FROM node:10-buster-slim as base

LABEL maintainer="OpenFun"

ARG EP_VERSION

# === Download ===
FROM curlimages/curl as downloader

ARG EP_VERSION=1.8.0

RUN curl -sLo /tmp/epl.tgz https://github.com/ether/etherpad-lite/archive/${EP_VERSION}.tar.gz

# === Builder ===
FROM base as builder

WORKDIR /builder

COPY --from=downloader /tmp/epl.tgz /builder/
RUN tar xzf epl.tgz --strip-components=1

ENV NODE_ENV=production
RUN cd src && \
      npm install

# Fake an installed node module
RUN mkdir node_modules && \
      cd node_modules && \
      ln -s ../src ep_etherpad-lite

# Pretend to have initialized etherpad
RUN echo "done" > node_modules/ep_etherpad-lite/.ep_initialized

# === Production ===
FROM base as production

WORKDIR /app

# Copy the configuration file
COPY --from=builder /builder/settings.json.docker settings.json
# ...and sources
COPY --from=builder /builder/src /app/src/
COPY --from=builder /builder/node_modules /app/node_modules/

# Run as non-privileged user
USER 10001

ENV NODE_ENV=production
EXPOSE 9001
CMD ["node", "src/node/server.js"]
