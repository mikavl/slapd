FROM library/debian:bullseye-slim

COPY --chown=root:root usr /usr/

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
 && apt-get install --assume-yes --no-install-recommends \
      haproxy \
      ldap-utils \
      slapd \
 && rm -rf /var/lib/apt/lists/* \
    \
 && chmod 0755 /usr/local/bin/* \
    \
 && rm -rf /etc/ldap/slapd.d /run/slapd /var/lib/ldap \
 && install -d -m 0700 -o root -g root \
      /secrets/external \
      /secrets/internal \
      /secrets/syncrepl \
      /config \
      /data \
      /etc/ldap/slapd.d \
      /run/slapd

COPY --chown=root:root etc /etc/
