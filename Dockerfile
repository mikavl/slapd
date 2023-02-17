FROM library/debian:bullseye-slim

COPY --chown=root:root docker-entrypoint.sh /
COPY --chown=root:root ldap-attr.sh /usr/local/bin/

RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive \
      apt-get install --assume-yes --no-install-recommends \
        ldap-utils \
        slapd \
 && rm -rf \
      /etc/ldap/slapd.d \
      /run/slapd \
      /var/lib/apt/lists/* \
      /var/lib/ldap \
 && chmod 0755 /docker-entrypoint.sh /usr/local/bin/ldap-attr.sh

COPY --chown=root:root consumer.init.ldif provider.init.ldif /etc/ldap/
COPY --chown=root:root schema /etc/ldap/schema/

ENTRYPOINT ["/docker-entrypoint.sh"]
COMMAND ["/usr/sbin/slapd", "-d", "stats", "-F", "/etc/ldap/slapd.d", "-h", "ldapi:/// ldaps:///"]
