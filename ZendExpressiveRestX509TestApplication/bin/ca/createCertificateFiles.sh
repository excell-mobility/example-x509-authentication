#!/bin/bash

###############################################################################
# This script creates the certificate files for the root and intermediate CA. #
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
rootCaConfigPath="./"
rootCaConfigFileName="rootca.openssl.cnf"
rootCaIndexFileName="index.txt"
rootCaSerialFileName="serial"

# settings intermediate CA
intermediateCaPath="./../../data/ca/intermediate/"
intermediateCaPrivateKeyFileName="intermediate.ca.private.encrypted.key"
intermediateCaPrivateKeyAlgorithm="-aes256"
intermediateCaPrivateKeyBits=4096
intermediateCaCsrAlgorithm="-sha512"
intermediateCaCsrFileName="intermediate.ca.csr"
intermediateCaCertFileName="intermediate.ca.certificate.crt"
intermediateCaCertAlgorithm="sha512"
intermediateCaCertValidDays="1825"
intermediateCaCertSerial="01"                       # <-- update this in case a new cert is created!
intermediateCaExtensions="v3_intermediate_ca"
intermediateCaCertChainFileName="intermediate.ca.certificate.chainfile.crt"
intermediateCaConfigPath="./"
intermediateCaConfigFileName="intermediateca.openssl.cnf"

# settings client
clientPath="./../../data/client/"

# step 1: create the root certification authority's private key
mkdir -p ${rootCaPath}
mkdir -p ${clientPath}
touch ${rootCaPath}${rootCaIndexFileName}
echo 1000 > ${rootCaPath}${rootCaSerialFileName}
openssl genrsa ${rootCaPrivateKeyAlgorithm} -out ${rootCaPath}${rootCaPrivateKeyFileName} ${rootCaPrivateKeyBits}
chmod 400 ${rootCaPath}${rootCaPrivateKeyFileName}

# step 2: create the self signed root certificate using the private key from step 1
openssl req -x509 -new ${rootCaCertAlgorithm} ${rootCaCertExtension} -days ${rootCaCertValidDays} -key ${rootCaPath}${rootCaPrivateKeyFileName} -out ${rootCaPath}${rootCaCertFileName} -config ${rootCaConfigPath}${rootCaConfigFileName}
chmod 444 ${rootCaPath}${rootCaPrivateKeyFileName}

# step 3: verify root certificate
openssl x509 -noout -text -in ${rootCaPath}${rootCaCertFileName}

# step 4: create the intermediate certification authority's private key
mkdir -p ${intermediateCaPath}
openssl genrsa ${intermediateCaPrivateKeyAlgorithm} -out ${intermediateCaPath}${intermediateCaPrivateKeyFileName} ${intermediateCaPrivateKeyBits}
chmod 400 ${intermediateCaPath}${intermediateCaPrivateKeyFileName}

# step 5: create the intermediate certification authority's certification signing request using the key from step 4
openssl req -config ${intermediateCaConfigPath}${intermediateCaConfigFileName} -new ${intermediateCaCsrAlgorithm} -key ${intermediateCaPath}${intermediateCaPrivateKeyFileName} -out ${intermediateCaPath}${intermediateCaCsrFileName}
chmod 444 ${intermediateCaPath}${intermediateCaCsrFileName}

# step 6: create the intermediate certification authority's certificate using the certification signing request and the root certification authority's private key
openssl ca -config ${rootCaConfigPath}${rootCaConfigFileName} -extensions ${intermediateCaExtensions} -days ${intermediateCaCertValidDays} -notext -md ${intermediateCaCertAlgorithm} -in ${intermediateCaPath}${intermediateCaCsrFileName} -out ${intermediateCaPath}${intermediateCaCertFileName}
chmod 444 ${intermediateCaPath}${intermediateCaCertFileName}

# step 7: verify the intermediate certificate
openssl x509 -noout -text -in ${intermediateCaPath}${intermediateCaCertFileName}

# step 8: create the intermediate certification authority's chain file containing the root & intermediate certificate
cat ${intermediateCaPath}${intermediateCaCertFileName} ${rootCaPath}${rootCaCertFileName} > ${intermediateCaPath}${intermediateCaCertChainFileName}
chmod 444 ${intermediateCaPath}${intermediateCaCertChainFileName}