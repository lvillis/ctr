ARG ALPINE_VERSION=3.13

FROM alpine:${ALPINE_VERSION} AS base

ENV TIME_ZONE Asia/Shanghai

RUN true \
    # Any command which returns non-zero exit code will cause this shell script to exit immediately:
    && set -e \
    # Activate debugging to show execution details: all commands will be printed before execution
    && set -x \
    && apk add --update --no-cache vim curl \

    # Add default timezone
    && apk add --update --no-cache tzdata \
    && cp /usr/share/zoneinfo/${TIME_ZONE} /etc/localtime \
    && echo "${TIME_ZONE}" > /etc/timezone \
    && apk del tzdata