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
As Swagger UI is a REST client itself, no additional native client is needed. Be sure to use a version that
supports entering HTTP Authorization headers, [v2.2.8](https://github.com/swagger-api/swagger-ui/releases/tag/v2.2.8)
or above should do just fine.

In our example case, the content of Swagger UI's "dist" directory is placed in the virtual host's public directory under "/api/v2",
so that by calling /api/v2 in the browser, you will see the Swagger UI client. The needed API configuration file
swagger.json can be build or generated using the [swagger editor](http://swagger.io/swagger-editor/),
which also has an online version available.

The key for adding JWT support with the HTTP Authorization header is Swagger UI's "securityDefinitions" attribute.
An example configuration can be found [here](https://github.com/excell-mobility/broadcasting-service/blob/develop/public/api/v2/swagger.json).

## Step 3: Test the Swagger UI with a real JSON Web Token
To test the Swagger UI, you need a valid JSON Web Token. In the example case, we use the
ExCELL Integration Layer Testing instance's Swagger UI to generate one:
 
```
eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzUxMiJ9
.eyJpYXQiOjE0OTcwMDA4MDksIm5iZiI6MTQ5NzAwMDgwOSwiZXhwIjoxNDk3MDAxNDA5LCJqdGkiOiJmMDlhMWJi
My1jZTBhLTUzN2MtOWEzNy0wNzliZjY3NDA2Y2EiLCJpc3MiOiJpbC10ZXN0LmV4Y2VsbC1tb2JpbGl0eS5kZSIsI
nN1YiI6IkhvcnN0IEluYy4iLCJ1c2VyIjoiaG9yc3Quc2NobWlkdEBob3JzdC1pbmMuY29tIiwic2VydmljZSI6Im
Jyb2FkY2FzdGluZy10ZXN0LmV4Y2VsbC1tb2JpbGl0eS5kZSJ9
.gTxBGKgZe3cDQwOszd6hTK9nOyCpnxWCmgCTJ8ssTCi0YY4n9eOa7DO8C9k77gpJDajP8rdHp8jTe41ExO9TfMdd
_x-Dg7fTsb7Kjz3HjieME4GMrMV-ZOpNmFLQeHGOObqOLx_DP5uRpeBF1Xi40ilEswyTYhX8WXp5w3NFP3xknRw5O
5M75dhkn5j-ODWwIiwlqkpIBtzfGzeBV8ccqXB0xJIt1yPjtdNcsn9PMjZBaAdMrfGFkLgo_1xsI0K-y7pyihr2Lp
AoqTrTSsaVoymfwynFSUUY3aLqQtqUu_LHt9NxZ9_adscirX6XzpaP1q_fbnpfzaIumlhoCWfkWFLbKd_3_lty5d4
-Zkyn4Nn_5dGlOFoUGr6PdtLPu3NGxn_tAAcFrQBYHreqLEfgni0opqkXNjVPFFLy3oexU3e_Atg6Qu2MgQMGBexl
pfC3TzlvGk_cpqQKFxWbhT3o1jwOMebS85S9HG5ygS4vU9YSo4hVQEH2kIdbgqtgpxprOFfxraDSel3tnFNVSD8pN
dYuIdhtxZ27ZtXooUF7bduPEuWnQ_8PDE-RLzH3PDCDh0Rn4f-XTH0l7vhmdjVuuzbmzJ4AQQ4r-PM5nX6A6ID7Ah
M7QxAPOeCPrxgkdciOpM9cBsQMfELobwZvrQbA24b3JfY8bMHw0_L-bip9J2k
```

To view the token's content, one can use the JWT debugger at [https://jwt.io](https://jwt.io).
The token was generated on June 09th, 2017, has a lifetime of 10 minutes (600 sec.) and was
issued by the testing instance of the ExCELL Integration Layer for the use with the testing
instance of the ExCELL Broadcasting Service. The biggest part of the token here is its signature.

Now you can call your service's Swagger UI, click the "Authorize" button on the top right
and enter the value for the HTTP Authorization header: "JWT" + \<space\> + \<a generated token like above\>.
After sending the request, the token is verified by your verification class and you know
 that the user is authorized to make the call.