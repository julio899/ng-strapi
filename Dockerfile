# Stage 1: Build stage
FROM node:20-alpine AS build

# Install build dependencies for native node modules (like better-sqlite3) and sharp
RUN apk update && apk add --no-cache \
    build-base \
    gcc \
    autoconf \
    automake \
    zlib-dev \
    libpng-dev \
    nasm \
    bash \
    vips-dev \
    git

ARG NODE_ENV=production
ENV NODE_ENV=${NODE_ENV}

WORKDIR /opt/
COPY package.json package-lock.json ./
RUN npm ci

WORKDIR /opt/app
COPY . .
RUN npm run build

# Prune development dependencies to keep the image optimized
WORKDIR /opt/
RUN npm prune --production

# Stage 2: Production runner stage
FROM node:20-alpine AS runner

# Install runtime library dependencies (vips is needed for sharp/image manipulation in Strapi)
RUN apk update && apk add --no-cache vips-dev

ARG NODE_ENV=production
ENV NODE_ENV=${NODE_ENV}

WORKDIR /opt/
COPY --from=build /opt/node_modules ./node_modules

WORKDIR /opt/app
COPY --from=build /opt/app/dist ./dist
COPY --from=build /opt/app/public ./public
COPY --from=build /opt/app/package.json ./package.json

# Create directory for SQLite db and set ownership to node user
RUN mkdir -p /opt/app/.tmp && chown -R node:node /opt/app /opt/node_modules

USER node
EXPOSE 1337

CMD ["npm", "run", "start"]
