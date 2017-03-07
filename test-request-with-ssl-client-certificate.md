Test request with SSL client certificate
========================================

## What is this all about ?
Using the scripts as shown in 
[Create valid client SSL certificates via CSR from scratch!](https://github.com/excell-mobility/example-x509-authentication/blob/add-certificates/create-csr-and-signed-certificate-files.md)
will provide us with our own Root CA, Intermediate CA & client SSL certificates.
Here, we'll see a valid example SSL client certificate for the domain **example.org** in action
by using a short PHP test script to run a request against the Integration Layer's REST API.
The idea is to demonstrate, with how little effort client verification via SSL Client certificates
is possible.

## Describing the test case

## Send a request using the example SSL client certificate 