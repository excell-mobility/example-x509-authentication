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

As an example, the verification process in the ExCELL Broadcasting Service in version 2
is handled in [this](https://github.com/excell-mobility/broadcasting-service/blob/develop/src/Broadcasting/Api/Validation.php)
class, [lcobucci/jwt](https://github.com/lcobucci/jwt) was chosen as JWT library:

1. The mandatory HTTP "Authorization" header line is retrieved from the request object
and checked to begin with "JWT". 
2. On success, the first 4 characters are removed (the string "JWT" and 1 space) and
the remaining string is parsed by the JWT library to form the JWT token.
3. To verify the JWT's signature, the issuing authority's public key is needed. In our case,
this is the ExCELL Integration Layer and the public key can be downloaded [here](https://github.com/excell-mobility/example-x509-authentication/tree/develop/Certificates).
4. Finally, the library's verification method is called, which does all the magic for you. Done! 

After that, you should be able to reject all requests that don't meet certain criteria:
* Protocol HTTPS is used with standard port 443
* SSL client certificate was sent and is verified by the web server software (e.g. Apache) 
* JSON Web Token stored in the HTTP Authorization header
* JWT is valid and it's signature is verified
* JWT is not expired and is issued by an authority of your choice (e.g. ExCELL Integration Layer)
* JWT's "service" claim attunes to your service's hostname


## Step 2: Update SwaggerUI to allow direct usage of JSON Web Token in HTTP Authorization header.
Swagger UI is a great way to get an overview over a new REST API and access it directly.
As Swagger UI is a REST client itself, no native client is needed. Be sure to use a version that
supports entering HTTP Authorization headers, [v2.2.8](https://github.com/swagger-api/swagger-ui/releases/tag/v2.2.8)
or above should do just fine.

In our example case, the content of Swagger UI's "dist" directory is placed in the virtual host's public directory under "/api/v2",
so that by calling /api/v2 in the browser, you will see the Swagger UI client. The needed API configuration file
swagger.json can be build or generated using the [swagger editor](http://swagger.io/swagger-editor/),
which also has an online version available.

The key for adding JWT support with the HTTP Authorization header is Swagger UI's "securityDefinitions" attribute.
An example configuration can be found [here](https://github.com/excell-mobility/broadcasting-service/blob/develop/public/api/v2/swagger.json).