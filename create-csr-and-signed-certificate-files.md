Create certificate signing request (CSR) and signed certificate files
=====================================================================
## What is this all about ?
This short document describes how to create a CSR (certificate signing request)
and the related certificate files, signed by the Intermediate CA, in 3 easy steps,
using the scripts from the ZendExpressiveRestX509TestApplication. These scripts are
using OpenSSL to do the magic, so check that OpenSSL is installed in a more or less
current version. 

## Step 1: Create Root- and Intermediate CA certificate files
Lets begin! First, we need to create the Root CA and Intermediate CA certificate files.
Here, we use the script

```bash
$ bin/ca/createCertificateFiles.sh
```
This creates the Root CA's and Intermediate CA's private keys and stores them encrypted
with a password of your choice. Be sure to use strong passwords and to store them
encrypted in a safe place, e.g. a keepass container. The Root CA's and Intermediate CA's
certificates are created, too, representing the public key. A the chainfile, containing 
both of them, is also created. This only has to be done once since your CA's certificate
files are valid for some years in most cases. 

## Step 2: Generate client key pair and certificate signing request (CSR)
After the preparation, let's generate the client's key pair, shall we ?

## Step 3: Sign CSR and create client certificate files 