# Stateless Etherpad Lite Dockerfile
#
# https://github.com/openfun/etherpad-docker
FROM node:10-buster-slim as base

LABEL maintainer="OpenFun"

ARG EP_VERSION

# === Download ===
FROM curlimages/curl as downloader

ARG EP_VERSION=master

RUN curl -sLo /tmp/epl.tgz https://github.com/ether/etherpad-lite/archive/${EP_VERSION}.tar.gz

# === Builder ===
FROM base as builder

WORKDIR /builder

COPY --from=downloader /tmp/epl.tgz /builder
RUN tar xzf epl.tgz --strip-components=1

ENV NODE_ENV=production
RUN cd src && \
      npm install --no-progress --no-audit

# Install extra plugins
COPY package.json package-lock.json /builder/
COPY src/plugins /builder/src/plugins/
RUN npm install --no-progress --no-audit

# Fake an installed node module
RUN cd node_modules && \
      ln -s ../src ep_etherpad-lite

# Pretend to have initialized etherpad and installed plugins
RUN bash -c "for m in node_modules/ep_* ; do echo 'done' > ${m}/.ep_initialized; done" && \
      echo "done" > src/.ep_initialized

# === Production ===
FROM base as production

WORKDIR /app

# Copy the configuration file
COPY --from=builder /builder/settings.json.docker settings.json
# Copy sources
COPY --from=builder /builder/src /app/src/
COPY --from=builder /builder/node_modules /app/node_modules/
COPY --from=builder /builder/package-lock.json /app
# Copy extra static files (version.json, etc.)
COPY src/static /app/src/static/
COPY package.json package.json

# Run as non-privileged user
USER 10001

ENV NODE_ENV=production
EXPOSE 9001
CMD ["node", "src/node/server.js"]
