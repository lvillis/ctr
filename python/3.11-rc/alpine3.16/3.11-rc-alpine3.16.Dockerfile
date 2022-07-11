ARG PYTHON_VERSION=3.11.0b3
ARG ALPINE_VERSION=3.16

FROM python:${PYTHON_VERSION}-alpine${ALPINE_VERSION} AS base

ENV TIME_ZONE Asia/Shanghai
RUN set -ex \
        \
    && apk add --update --no-cache vim curl \
    && python3 -m pip install --upgrade pip \
    # Add default timezone
    && apk add --update --no-cache tzdata \
    && cp /usr/share/zoneinfo/${TIME_ZONE} /etc/localtime \
    && echo "${TIME_ZONE}" > /etc/timezone \
    && apk del tzdata