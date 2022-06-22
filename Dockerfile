FROM node:16.10.0-alpine as base
WORKDIR /app

FROM base as builder

COPY common common
COPY rush.json .
COPY apps/nestjs-app/package.json apps/nestjs-app/package.json

RUN node common/scripts/install-run-rush.js install
COPY . .
RUN node common/scripts/install-run-rush.js build
RUN node common/scripts/install-run-rush.js deploy -s nestjs
RUN cp -R ./apps/nestjs-app/dist ./common/deploy/apps/nestjs-app

FROM base as final
ENV NODE_ENV=production
EXPOSE 3000

COPY --from=builder /app/common/deploy /app

CMD ["node", "apps/nestjs-app/dist/main.js"]
