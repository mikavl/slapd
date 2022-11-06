OPENSSL_CONF = ./openssl.cnf
export OPENSSL_CONF

CA_SUBJ = /CN=slapd
CERT_SUBJ = /CN=*.slapd.openldap.svc.cluster.local

secrets:
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
	cp $(TMPDIR)/cert.crt ./examples/cert.pem
	cat $(TMPDIR)/cert.key >> ./examples/cert.pem

	rm -rf $(TMPDIR)

.PHONY: secrets
