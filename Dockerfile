FROM library/debian:bullseye-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
 && apt-get install --assume-yes --no-install-recommends \
      haproxy \
      ldap-utils \
      slapd \
 && rm -rf /var/lib/apt/lists/*
