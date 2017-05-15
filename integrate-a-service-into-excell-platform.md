Integrate a service into the ExCELL platform
============================================
## What is this all about ?
The ExCELL platform provides passwordless authentication for registered services and
 clients to allow a high level of security by implementing a way to enable them to 
 enforce know-your-customer guidelines. This is done via extensive use of asymmetric
 encryption, like SSL client certificates and signed JSON Web Tokens. The idea is to
 allow services to easily verify claims in a secure, standardized way. The implementation
 overhead is minimal, because the SSL client certificate verification is done by the
 web server software (e.g. Apache webserver), while JSON Web Token are validated using
 existing Open Source Libraries for multiple languages.

## Prerequisites

Before integrating the service into the ExCELL platform, some prerequisites are to 
be met:
- A valid SSL certificate is correctly installed and configured. Today, this can be done
for free using a Let's Encrypt SSL certificate. [Read here how](https://github.com/excell-mobility/example-x509-authentication/blob/master/get-free-ssl-certificate-via-lets-encrypt.md).
- SSL client certificate verification is configured and enabled. [This can be done by
adding 4 lines of configuration to your Apache virtual host config file](https://github.com/excell-mobility/example-x509-authentication/blob/master/upgrade-vhost-for-ssl-client-certificate-verification.md).
- A Public Key Infrastructure (provided by ExCELL) and a valid client certificate
with a related private key exists for the target domain. This can be created [here](https://github.com/excell-mobility/example-x509-authentication/blob/master/create-csr-and-signed-certificate-files.md).
- You can successfully send requests using SSL client certificates to your domain and
let them be verified by the web server. Sending requests with SSL client certificates can
be tested [here](https://github.com/excell-mobility/example-x509-authentication/blob/master/test-request-with-ssl-client-certificate.md).

Before going any further, please check if the points above are valid for your setup. If not, you 
may use the given tutorials to update your web server's configuration.

## Step 1

## Step 2
Implement verification of JSON Web Token signatures. This can easily be done using one
of the available Open Source implementations of JSON Web Token. Choose a library [here](https://jwt.io/).

## Step 3
Update SwaggerUI to allow direct usage of JSON Web Token in HTTP Authorization header.