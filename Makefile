OPENSSL_CONF = ./openssl.cnf
export OPENSSL_CONF

CA_SUBJ = /CN=slapd
CERT_SUBJ = /CN=*.slapd.openldap.svc.cluster.local

define MESSAGE
================================================================================

The external TLS certificate and its private key need to be added
to the 'examples/external.pem' file.

Then, modify the kustomization.yaml in the 'examples' directory as needed.

Check the resources to be applied:

    kubectl kustomize examples

Fiannly, apply the resources:

    kubectl apply -k examples

================================================================================
endef
export MESSAGE

certs:
	$(eval TMPDIR := $(shell mktemp -d))

	cp ./examples/openssl.cnf $(TMPDIR)

	cd $(TMPDIR) ; \
		touch index ; \
		openssl genrsa -out ca.key 4096 ; \
		openssl req -new -x509 -sha256 -days 365000 \
			-extensions ext_ca \
			-subj 			$(CA_SUBJ) \
			-key 				ca.key \
			-out 				ca.crt

	cd $(TMPDIR); \
		openssl genrsa -out $(TMPDIR)/cert.key 4096 ; \
		openssl req -new -sha256 \
			-subj "$(CERT_SUBJ)" \
			-key  cert.key \
			-out  cert.csr ; \
		openssl ca -batch -days 365000 -md sha256 -notext \
			-in  cert.csr \
			-out cert.crt

	cp $(TMPDIR)/ca.crt ./examples/ca.pem
	cp $(TMPDIR)/cert.crt ./examples/internal.pem
	cat $(TMPDIR)/cert.key >> ./examples/internal.pem

	rm -rf $(TMPDIR)

secret:
	head /dev/urandom | tr -dc A-Za-z0-9 | head -c 30 > ./examples/secret

secrets: certs secret
	echo "$$MESSAGE"

.PHONY: certs secret secrets
