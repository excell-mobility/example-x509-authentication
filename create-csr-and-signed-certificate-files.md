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
Now for the fun part. We will sign the CSR with the Intermediate CA's private key and
create the client's final certificate files. Because the private key is heavily encrypted,
only the person knowing the password for this file can sign the CSR.

For that, we use the last script:

```bash
$ bin/ca/signClientCsr.sh
```

First, we're asked for the Intermediate CA's private key password. After entering correctly,
we are presented with the certificate details, meaning entered validity, certificate values
and extension data. Now we are asked if the certificate should be signed. Take a minute,
check the displayed certificate data and answer with "y". Commit that with a second "y".  
This should look somewhat like this:

> Using configuration from ./intermediateca.openssl.cnf  
> Enter pass phrase for ./../../data/ca/intermediate/intermediate.ca.private.encrypted.key:  
> Check that the request matches the signature  
> Signature ok  
> Certificate Details:  
>         Serial Number: 4107 (0x100b)  
>         Validity   
>             Not Before: Mar  6 12:51:01 2017 GMT  
>             Not After : Mar  6 12:51:01 2018 GMT  
>         Subject:  
>             countryName               = DE  
>             organizationName          = Example Organisation  
>             organizationalUnitName    = Example Client  
>             commonName                = example.org  
>         X509v3 extensions:  
>             X509v3 Basic Constraints:  
>                 CA:FALSE  
>             Netscape Cert Type:  
>                 SSL Client, S/MIME  
>             Netscape Comment:  
>                 OpenSSL Generated Client Certificate  
>             X509v3 Subject Key Identifier:  
>                 33:E0:13:B0:B5:70:C0:C3:2F:AA:0C:C0:D8:22:19:26:08:1B:61:8C  
>             X509v3 Authority Key Identifier:  
>                 keyid:1C:E0:CB:EE:15:53:FB:D1:68:1E:40:9C:6B:43:8A:6A:9A:FA:DC:27  
>             X509v3 Key Usage: critical  
>                 Digital Signature, Non Repudiation, Key Encipherment  
>             X509v3 Extended Key Usage:  
>                 TLS Web Client Authentication, E-mail Protection  
> Certificate is to be certified until Mar  6 12:51:01 2018 GMT (365 days)  
>  Sign the certificate? [y/n]:y  
>  1 out of 1 certificate requests certified, commit? [y/n]y  
>  Write out database with 1 new entries  
>  Data Base Updated  
>  ./../../data/client/client.crt: OK  

**Congratulation!** Our client certificate for example.org has successfully been created
and can be found in the directory **data/client**.
Additionally, the client's certificate files have been converted in several useful
container formats, e.g. .p12 for Firefox browser.