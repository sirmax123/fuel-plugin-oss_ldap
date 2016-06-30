#!/bin/sh


set -e
set -x


export WORKDIR=`pwd`
export OPENSSL_CONF="${WORKDIR}/openssl.conf"
export CA_DIR=${WORKDIR}/CA

# backup old CA (need in case plugin re-install or CA re-creation)
test -d ${CA_DIR} && mv -f ${CA_DIR} ${CA_DIR}_$(date +%Y%m%d_%H_%M_%S)
mkdir -p ${WORKDIR}
mkdir -p ${CA_DIR}

#chmod u=rwx,g=,o= /CA

pushd ${CA_DIR}
umask 066


mkdir -p certs crl newcerts private
chmod 700 private
touch index.txt
touch index.txt.attr
echo 1000 > serial


# Create key w/o password
openssl genrsa \
-out private/rootca.key \
4096 

chmod 400 private/rootca.key

#chattr +i private/rootca.key

# Root CA
openssl req \
-sha256 \
-new \
-x509 \
-days 3650 \
-extensions v3_ca \
-key private/rootca.key \
-out certs/rootca.crt \
-subj /C=UA/ST=Kharkov/L=Kharkov/O=MirantisInc/OU=ServicesDepartment/CN=ca-server/emailAddress=mmaxur@mirantis.com

chmod 444 certs/rootca.crt
#chattr +i certs/rootca.crt


# Show Root CA
openssl x509 \
-in certs/rootca.crt \
-noout \
-text



#private_key_for_ldap

openssl genrsa \
-out private/ldap.key 4096

chmod 400 private/ldap.key

#  cert_request_for_ldap

openssl req \
-sha256 -new \
-key private/ldap.key \
-out certs/ldap.csr \
-subj /C=UA/ST=Kharkov/L=Kharkov/O=MirantisInc/OU=ServicesDepartment/CN=ldap/emailAddress=mmaxur@mirantis.com

# create_and_sign_cert_for_ldap
openssl ca \
-extensions usr_cert \
-notext \
-md sha256 \
-keyfile private/rootca.key \
-cert certs/rootca.crt \
-in certs/ldap.csr \
-out certs/ldap.crt \
-batch \
-verbose


chmod 444 certs/ldap.crt

popd
