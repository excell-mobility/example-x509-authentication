#!/bin/bash

# intermediate CA
intermediateCaConfigPath="./../ca/"
intermediateCaConfigFileName="intermediateca.openssl.cnf"

# settings key pair
clientKeyPairAlgorithm="-aes256"
clientKeyPairBits=4096
clientKeyPairPath="./../../data/client/"

clientPrivateKeyFileName="client.private.encrypted.key"
clientPublicKeyFileName="client.public.pem"

clientCsrFileName="client.csr"
clientCsrAlgorithm="-sha512"

# step 1: create the client's private key
mkdir -p ${clientKeyPairPath}
openssl genrsa ${clientKeyPairAlgorithm} -out ${clientKeyPairPath}${clientPrivateKeyFileName} ${clientKeyPairBits}
chmod 400 ${clientKeyPairPath}${clientPrivateKeyFileName}

# step 2: calculate the client's public key
openssl rsa -in ${clientKeyPairPath}${clientPrivateKeyFileName} -pubout -out ${clientKeyPairPath}${clientPublicKeyFileName}
chmod 444 ${clientKeyPairPath}${clientPublicKeyFileName}

# step 3: create the CSR (certificate signing request)
openssl req -config ${intermediateCaConfigPath}${intermediateCaConfigFileName} -new ${clientCsrAlgorithm} -key ${clientKeyPairPath}${clientPrivateKeyFileName} -out ${clientKeyPairPath}${clientCsrFileName}
chmod 444 ${clientKeyPairPath}${clientCsrFileName}