#!/bin/sh
set -e
set -u

case "$(hostname)" in
    slapd-0)
        config="provider"
        ;;
    *)
        config="consumer"
        ;;
esac

credentials=
manager=
provider=
replicator=
services=
suffix=
users=

sed -E \
    -e "s/@CREDENTIALS@/$credentials/" \
    -e "s/@MANAGER@/$manager/" \
    -e "s/@PROVIDER@/$provider/" \
    -e "s/@REPLICATOR@/$replicator/" \
    -e "s/@SERVICES@/$services/" \
    -e "s/@SUFFIX@/$suffix/" \
    -e "s/@USERS@/$users/" \
    "/etc/ldap/$config.ldif" | slapadd -F /etc/ldap/slapd.d -n 0

ulimit -n 1024
exec "$@"
