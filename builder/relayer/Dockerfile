FROM node:20-slim AS base
ENV PNPM_HOME="/pnpm"
ENV PATH="$PNPM_HOME:$PATH"
RUN corepack enable

COPY dist /app
WORKDIR /app

EXPOSE 6000
CMD [ "pnpm", "start" ]