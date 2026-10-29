FROM node:current-slim

LABEL org.opencontainers.image.source="https://github.com/antonyho/docker-codex"
LABEL org.opencontainers.image.description="OpenAI Codex CLI in a Docker container"
LABEL org.opencontainers.image.licenses="MIT"

ARG CODEX_VERSION=latest

ENV WORKSPACE="/workspace"
ENV CODEX_HOME=$WORKSPACE/.codex-cfg
WORKDIR $WORKSPACE
RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates
RUN apt-get install -y bubblewrap && \
    chmod u+s /usr/bin/bwrap
RUN rm -rf /var/lib/apt/lists/*
RUN npm install -g @openai/codex@${CODEX_VERSION#v}

CMD ["codex"]
