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

credentials="$(cat /secret/credentials)"
manager="$(cat /secret/manager)"
provider="$(cat /secret/provider)"
replicator="$(cat /secret/replicator)"
services="$(cat /secret/services)"
suffix="$(cat /secret/suffix)"
users="$(cat /secret/users)"

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
