# Multi-stage Docker build for MaaCare Telangana on Render.com

# Stage 1: Build Flutter Web Application
FROM ghcr.io/cirruslabs/flutter:stable AS build

WORKDIR /app
COPY pubspec.* ./
RUN flutter pub get

COPY . .
RUN flutter build web --release

# Stage 2: Production Node.js Server
FROM node:20-alpine

WORKDIR /app

# Copy package dependencies
COPY package*.json ./
RUN npm install --omit=dev

# Copy server and built static files
COPY server.js ./
COPY --from=build /app/build/web ./build/web

EXPOSE 10000

ENV PORT=10000
ENV NODE_ENV=production

CMD ["npm", "start"]
