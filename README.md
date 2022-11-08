# OpenLDAP Server

This repository includes a container image and Helm chart for the OpenLDAP server (slapd).

## Installation

1. Set up the namespace and required secrets. Three secrets are required:

  a) A secret with the external certificate for LDAP in HAProxy's PEM format.
  b) A secret with an internal CA and certificate to use with LDAP replication connections (syncrepl).
  c) A secret with the syncrepl replicator DN password.

The internal CA, certificate and syncrepl secret can be created by running the `make secrets` command:

```
make secrets
```

The example Kustomization uses the `openldap` Kubernetes namespace.

You can then place the external certificate to `examples/external.pem`, and run:

```
kubectl apply -k examples
```

2. Install the Helm chart to the namespace created in the previous step (`openldap` if using the example):

```
helm upgrade --install --namespace openldap slapd charts/slapd
```

3. Hash the syncrepl password using e.g. the `mkpasswd` program:

```
cat ./examples/secret | mkpasswd -m sha512crypt -s
```

4. Create the minimal LDAP tree, replacing the angled brackets and their insides with the hash from the previous step:

```
kubectl exec -i -n openldap slapd-0 -c slapd -- ldapadd -c <<'EOF'
dn: dc=home,dc=arpa
objectClass: dcObject
objectClass: organization
objectClass: top
dc: home
o: home

dn: cn=replicator,dc=home,dc=arpa
objectClass: applicationProcess
objectClass: simpleSecurityObject
objectClass: top
cn: replicator
userPassword: {CRYPT}<REPLICATOR PASSWORD HASH HERE>
EOF
```
