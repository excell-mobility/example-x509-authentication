#!/bin/bash

###############################################################################
# This script signs the client's CSR with the ExCELL intermediate CA's key    #
# and creates valid client certificate files.                                 #
###############################################################################

# settings root CA
rootCaPath="./../../data/ca/root/"
rootCaPrivateKeyFileName="root.ca.private.encrypted.key"
rootCaPrivateKeyAlgorithm="-aes256"
rootCaPrivateKeyBits=4096
rootCaCertFileName="root.ca.certificate.crt"
rootCaCertAlgorithm="-sha512"
rootCaCertExtension="-extensions v3_ca"
rootCaCertValidDays="3650"

# settings intermediate CA
intermediateCaPath="./../../data/ca/intermediate/"
intermediateCaPrivateKeyFileName="intermediate.ca.private.encrypted.key"
intermediateCaPrivateKeyAlgorithm="-aes256"
intermediateCaPrivateKeyBits=4096
intermediateCaCsrAlgorithm="-sha512"
intermediateCaCsrFileName="intermediate.ca.csr"
intermediateCaCertFileName="intermediate.ca.certificate.crt"
intermediateCaCertAlgorithm="-sha512"
intermediateCaCertValidDays="1825"
intermediateCaCertSerial="01"                       # <-- update this in case a new cert is created!
intermediateCaCertChainFileName="intermediate.ca.certificate.chainfile.crt"
intermediateCaConfigPath="./"
intermediateCaConfigFileName="intermediateca.openssl.cnf"
#intermediateCaExtensions="server_cert"
intermediateCaExtensions="usr_cert"

# settings client key pair
clientKeyPairAlgorithm="-aes256"
clientKeyPairBits=4096
clientKeyPairPath="./../../data/client/"
clientPrivateKeyFileName="client.private.encrypted.key"
clientPublicKeyFileName="client.public.pem"
clientCsrFileName="client.csr"
clientCsrAlgorithm="-sha512"
clientCrtFileName="client.crt"
clientCrtAlgorithm="sha512"
clientCrtDays=365
clientP12FileName="client.p12"

# Step 1: sign user certificate request and create client certificate
openssl ca -config ${intermediateCaConfigPath}${intermediateCaConfigFileName} -extensions ${intermediateCaExtensions} -notext -in ${clientKeyPairPath}${clientCsrFileName} -out ${clientKeyPairPath}${clientCrtFileName} -days ${clientCrtDays} -md ${clientCrtAlgorithm}
chmod 444 ${clientKeyPairPath}${clientCrtFileName}

# Step 2: verify the new user certificate using the ca chain file
openssl verify -CAfile ${intermediateCaPath}${intermediateCaCertChainFileName} ${clientKeyPairPath}${clientCrtFileName}

# Step 3: convert client certificate to p12 format for browser import
openssl pkcs12 -export -clcerts -in ${clientKeyPairPath}${clientCrtFileName} -inkey ${clientKeyPairPath}${clientPrivateKeyFileName} -out ${clientKeyPairPath}${clientP12FileName}