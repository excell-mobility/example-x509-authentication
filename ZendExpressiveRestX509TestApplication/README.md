# ExCELL Zend Expressive REST X509 Test Application
This PHP application demonstrates how creation and usage of SSL certificates in the ExCELL environment could be done.

## Features ##
- uses PHP 7 and Zend Expressive micro framework to implement the server and client part
- allows creating the key pair and signing certificates using OpenSSL via bash script

## Usage ##
After setting up your local vhost, send a GET request in your favorite browser to
[https://example-x509-authentication.dev/api/v1.0/](https://example-x509-authentication.dev/api/v1.0/)
to run SwaggerUI for the "Hello World API" example. Open the "POST /hello" request and
enter a valid body parameter, e.g.:

```json
{
  "name":"Rudi Völler"
}
```

Push the "Try it out!" button to send a POST request to the "Hello World" REST API.
If it's successful, you should get a response body like this one:

```json
{
  "message":"Hello, Rudi Völler!",
  "name":"Rudi Völler",
  "ack":1478793727
}
```

This should work as long as client certificates are not enforced.