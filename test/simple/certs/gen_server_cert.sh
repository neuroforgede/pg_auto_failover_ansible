#!/bin/bash

CA_DIR="$1"
BASEDIR="$2"
COMMON_NAME="$3"
PASSKEY="$4"

LOGGING_PREFIX="gen_cert.sh >> "

mkdir -p $BASEDIR

rm -f ${BASEDIR}/server.crt
rm -f ${BASEDIR}/server.csr
rm -f ${BASEDIR}/server.key

echo "$PASSKEY" > ${BASEDIR}/passkey.txt

# generate a key for our server certificate
echo 
echo "${LOGGING_PREFIX} Generating key for server certificate"
openssl genrsa -des3 -passout pass:${PASSKEY} -out ${BASEDIR}/server.pass.key 4096
openssl rsa -passin pass:${PASSKEY} -in ${BASEDIR}/server.pass.key -out ${BASEDIR}/server.key
rm ${BASEDIR}/server.pass.key
echo

# create a certificate request for our server. This includes a subject alternative name so either aios-localhost, localhost or postgres_ssl can be used to address it
echo
echo "${LOGGING_PREFIX} Creating server certificate"
openssl req -new -key ${BASEDIR}/server.key -out ${BASEDIR}/server.csr -subj "/emailAddress=kontakt@your-company.de/C=DE/ST=Bavaria/L=Bayreuth/O=your-company/OU=your-company GmbH & Co. KG/CN=${COMMON_NAME}"
echo "${LOGGING_PREFIX} Server certificate signing request (${BASEDIR}/server.csr) is:"
openssl req -verify -in ${BASEDIR}/server.csr -text -noout
echo

# use our CA certificate and key to create a signed version of the server certificate
echo 
echo "${LOGGING_PREFIX} Signing server certificate using our root CA certificate and key"
openssl x509 -req -sha512 -days 365000 -in ${BASEDIR}/server.csr -CA ${CA_DIR}/rootCA.crt -CAkey ${CA_DIR}/rootCA.key -CAcreateserial -out ${BASEDIR}/server.crt 
chmod og-rwx ${BASEDIR}/server.key
echo "${LOGGING_PREFIX} Server certificate signed with our root CA certificate (${BASEDIR}/server.crt) is:"
openssl x509 -in ${BASEDIR}/server.crt -text -noout
echo

# done output the base64 encoded version of the root CA certificate which should be added to trust stores
echo
echo "${LOGGING_PREFIX} Use the following CA certificate variables:"
B64_CA_CERT=`cat ${CA_DIR}/rootCA.crt | base64`
echo "POSTGRES_SSL_CA_CERT=${B64_CA_CERT}"

cp ${CA_DIR}/rootCA.crt ${BASEDIR}/rootCA.crt

openssl x509 -outform der -in ${BASEDIR}/rootCA.crt -out ${BASEDIR}/rootCA.crt.der
openssl pkcs8 -topk8 -inform PEM -outform DER -in ${BASEDIR}/server.key -out ${BASEDIR}/server.key.pk8 -nocrypt

cat ${BASEDIR}/server.key ${BASEDIR}/server.crt > ${BASEDIR}/server-complete.pem

cp ${CA_DIR}/rootCA.crt ${BASEDIR}/rootCA.crt
cat ${CA_DIR}/rootCA-verification.pem > ${BASEDIR}/rootCA-verification.pem
