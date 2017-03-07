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
ExCELL Integration Layer's REST API's **/health** endpoint. The related SwaggerUI is found
at https://il-test.excell-mobility.de/api/v1/#!/health/get_health .

We will use the given example.org client certificate files, found in the directory 
[ZendExpressiveRestX509TestApplication/bin/client/exampleFiles](https://github.com/excell-mobility/example-x509-authentication/tree/add-certificates/ZendExpressiveRestX509TestApplication/bin/client/exampleFiles) .
We chose curl as HTTP client do do the heavy lifting, so setting the right options and
evaluating the result will do.

## Send a request using the example SSL client certificate
The test script
[test.php](https://github.com/excell-mobility/example-x509-authentication/blob/add-certificates/ZendExpressiveRestX509TestApplication/bin/client/exampleFiles/test.php)
is located in the same directory as the example client certificates. Just point your shell
in the direction of the test script and run that by typing

```bash
$ cd bin/client/exampleFiles
$ ./test.php
```

The test script initializes a curl resource and sets the necessary curl options. See 
[PHP's curl documentation](http://php.net/manual/en/function.curl-setopt.php) for
further details. After that, the request is executed. On success, the server's response
is printed in the CLI. Because we were curious and set the CURLOPT_VERBOSE option, we also
got some insight into the actual sending process.

## Conclusion
Not much is needed to actually send a request using a client certificate. Mostly, some lines
of configuration should be enough to get you up and running. Besides of curl, there are
several other HTTP clients. You should not have any problem translating this example to
other clients or programming languages, since the way they work is roughly the same.
In case you implemented a test script for a different one, let me know and I'll add it.