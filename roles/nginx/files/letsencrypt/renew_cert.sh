#!/bin/bash

readonly ACME_DIR=$1/.well-known/acme-challenge
readonly CONFIG_DIR=$2
readonly CERTS_DIR=$3
readonly TMP_DIR="/tmp/letsencrypt"

cd $CONFIG_DIR

mkdir $TMP_DIR

SANS=$(cat SAN | tr '\n' ',' | sed 's/,$/\n/')
openssl req -new -sha256 -key domain.key -subj "/" -reqexts SAN -config <(cat /etc/ssl/openssl.cnf <(printf "[SAN]\nsubjectAltName=$SANS")) > domain.csr
python acme_tiny.py --account-key account.key --csr domain.csr --acme-dir $ACME_DIR > $TMP_DIR/signed.crt || exit
wget -O - https://letsencrypt.org/certs/lets-encrypt-x3-cross-signed.pem > intermediate.pem

cat $TMP_DIR/signed.crt intermediate.pem > $CERTS_DIR/chained.pem
mv $CONFIG_DIR/domain.key $CERTS_DIR

rm $TMP_DIR/signed.crt || true
rm domain.csr || true
