FROM docker.io/oven/bun:1 AS base
WORKDIR /usr/src/app

FROM base AS install
WORKDIR /temp/dev
COPY package.json bun.lock ./
RUN bun install --frozen-lockfile

WORKDIR /temp/prod
COPY package.json bun.lock ./
RUN bun install --frozen-lockfile --production

FROM base AS build
COPY --from=install /temp/dev/node_modules ./node_modules
COPY . .
ENV NODE_ENV=production
RUN bun run build

FROM docker.io/caddy:2.9.1-alpine
COPY Caddyfile /etc/caddy/Caddyfile
COPY --from=build /usr/src/app/dist /srv
