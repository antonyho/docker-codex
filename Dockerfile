FROM node:current-slim

ARG CODEX_VERSION=latest

ENV WORKSPACE="/workspace"
ENV CODEX_HOME=$WORKSPACE/.codex-cfg
WORKDIR $WORKSPACE
RUN npm install -g @openai/codex@${CODEX_VERSION#v}

CMD ["codex"]
