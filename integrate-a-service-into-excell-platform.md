Integrate a service into the ExCELL platform
============================================
## What is this all about ?
The ExCELL platform provides passwordless authentication for registered services and
 clients to allow a high level of security by implementing a way to enable them to 
 enforce know-your-customer guidelines. This is done via asymmetric
 encryption, using SSL client certificates and signed JSON Web Tokens. The idea is to
 allow services to easily verify claims in a secure, standardized way. The implementation
 overhead is minimal, because the SSL client certificate verification is done by the
 web server software (e.g. Apache webserver), while JSON Web Token are validated using
 existing Open Source libraries for multiple languages.

## Prerequisites

Before integrating the service into the ExCELL platform, some prerequisites are to 
be met:
- **A valid SSL certificate is correctly installed and configured at server side.**  
 Today, this can be done for free using a Let's Encrypt SSL certificate. [Read here how](https://github.com/excell-mobility/example-x509-authentication/blob/master/get-free-ssl-certificate-via-lets-encrypt.md).
- **SSL client certificate verification is configured and enabled.**  
 [This can be done by adding 4 lines of configuration to your Apache virtual host config file](https://github.com/excell-mobility/example-x509-authentication/blob/master/upgrade-vhost-for-ssl-client-certificate-verification.md).
- **A Public Key Infrastructure (provided by ExCELL) and a valid client certificate
with a related private key exists for the service's domain.**  
 This can be created [here](https://github.com/excell-mobility/example-x509-authentication/blob/master/create-csr-and-signed-certificate-files.md).
- **You can successfully send requests using SSL client certificates to your service'S domain and
let them be verified by the web server.**  
Sending requests with SSL client certificates can be tested [here](https://github.com/excell-mobility/example-x509-authentication/blob/master/test-request-with-ssl-client-certificate.md).

Before going any further, please check if the points above are valid for your setup. If not, you 
may need to use the given tutorials to update your web server's configuration.

The steps are demonstrated with the [ExCELL Broadcasting Service](https://github.com/excell-mobility/broadcasting-service/) in version 2 as example.
It is written in PHP 7 using the Zend Expressive PSR-7 micro framework, so the "meat" of the service
only consists of a handful PHP classes. 

## Step 1: Implement verification of JSON Web Token signatures.
This can easily be done using one of the many available Open Source implementations
of JSON Web Token. Select a library for the language of your choice [here](https://jwt.io/).

The verification process in the ExCELL Broadcasting Service in version 2
is handled in [this](https://github.com/excell-mobility/broadcasting-service/blob/develop/src/Broadcasting/Api/Validation.php)
class, [lcobucci/jwt](https://github.com/lcobucci/jwt) was chosen as JWT library:

1. The mandatory HTTP "Authorization" header line is retrieved from the request object
and checked to begin with "JWT". 
2. On success, the first 4 characters are removed (the string "JWT" and 1 space) and
the remaining string is parsed by the JWT library to form the JWT token.
3. To verify the JWT's signature, the issuing authority's public key is needed. In our case,
this is the ExCELL Integration Layer and the public key can be downloaded [here](https://github.com/excell-mobility/example-x509-authentication/tree/develop/Certificates).
4. Finally, the library's verification method is called, which does all the magic for you. Done! 


## Step 2
Update SwaggerUI to allow direct usage of JSON Web Token in HTTP Authorization header.