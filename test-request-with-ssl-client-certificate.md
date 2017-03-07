Test request with SSL client certificate
========================================

## What is this all about ?
Using the scripts as shown in 
[Create valid client SSL certificates via CSR from scratch!](https://github.com/excell-mobility/example-x509-authentication/blob/add-certificates/create-csr-and-signed-certificate-files.md)
will provide us with our own Root CA, Intermediate CA & client SSL certificates.
Here, we'll see a valid example SSL client certificate for the domain **example.org** in action
by using a short PHP test script to run a request against the Integration Layer's REST API.
The idea is to demonstrate, with how little effort client verification via SSL client certificates
is possible.

## Describing the test case
For the purpose of this test, we'll run an HTTP GET request against the 
ExCELL Integration Layer's REST API's **/health** endpoint. We will use the given example.org
client certificate files, found in the directory 
[ZendExpressiveRestX509TestApplication/bin/client/exampleFiles](https://github.com/excell-mobility/example-x509-authentication/tree/add-certificates/ZendExpressiveRestX509TestApplication/bin/client/exampleFiles) .
We chose curl as HTTP client do do the heavy lifting. 


## Send a request using the example SSL client certificate
The test script
[test.php](https://github.com/excell-mobility/example-x509-authentication/blob/add-certificates/ZendExpressiveRestX509TestApplication/bin/client/exampleFiles/test.php)
is located in the same directory as the example client certificates. Just point your shell
in the direction of the test script and run that by typing

```bash
$ cd bin/client/exampleFiles
$ ./test.php
```