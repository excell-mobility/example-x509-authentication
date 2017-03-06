Create certificate signing request (CSR) and certificate files
===============================================================
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
both of them, is also created. These files can be found in the directories 
**data/ca/root** and **data/ca/intermediate** . This process only has to be done once since your CA's certificate
files are valid for some years in most cases. 

## Step 2: Generate client key pair and certificate signing request (CSR)
After the preparation, let's generate the client's key pair, shall we ? For the purpose
of this demo, we will create the SSL client certificate files for the common name (CN)
**example.org** with the **password "example123"** to protect the files containing the private
key. Run the following script:

```bash
$ bin/client/createKeyPairCertificateSigningRequest.sh
```

This generates the key pair (private and public key) and stores them in the directory
**data/client** . The private key is encrypted with the password entered by the user.

After that, it's time to create the certificate signing request (CSR). This file allows
us to send all the data needed for creating the certificate to the Intermediate CA without
revealing our secret, the private key. Enter the values for Organization Name, Common Name
etc. as you wish. When you're done, it should look somewhat like this:

> Generating RSA private key, 4096 bit long modulus  
> ............................................++  
> ...........................++  
> e is 65537 (0x10001)  
> Enter pass phrase for ./../../data/client/client.private.encrypted.key:  
> Verifying - Enter pass phrase for ./../../data/client/client.private.encrypted.key:  
> Enter pass phrase for ./../../data/client/client.private.encrypted.key:  
> writing RSA key  
> Enter pass phrase for ./../../data/client/client.private.encrypted.key:  
> You are about to be asked to enter information that will be incorporated  
> into your certificate request.  
> What you are about to enter is what is called a Distinguished Name or a DN.  
> There are quite a few fields but you can leave some blank  
> For some fields there will be a default value,  
> If you enter '.', the field will be left blank.  
> \-----  
> Country Name (2 letter code) [DE]:DE  
> State or Province Name []:  
> Locality Name []:  
> Organization Name []:Example Organisation  
> Organizational Unit Name []:Example client  
> Common Name []:example.org  
> Email Address []:  

## Step 3: Sign CSR and create client certificate files 