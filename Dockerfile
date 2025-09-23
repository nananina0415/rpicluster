# Bun 런타임이 내장됨
FROM oven/bun:latest-alpine

# 도커 설치
RUN apk add --no-cache docker
