# ---- Base ----
FROM node:lts-alpine AS base
WORKDIR /app

COPY . .

# install all dependencies
RUN npm install

# ---- Build ----
FROM base AS build
WORKDIR /app

RUN npm run build

FROM caddy:2.8.4-alpine

COPY Caddyfile /etc/caddy/Caddyfile
COPY --from=build /app/dist /srv

