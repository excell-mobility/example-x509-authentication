Upgrade your vHost for SSL client certificate verification
==========================================================
## What is this all about ?
This tutorial builds upon the previous
[Securing your vHost using a Let's Encrypt SSL certificate](https://github.com/excell-mobility/example-x509-authentication/blob/master/get-free-ssl-certificate-via-lets-encrypt.md)
and extends the configuration in a way that the Apache Web Server does the verification by itself.
Your SSL certificate does not need to be signed by the Let's Encrypt CA, any valid certificate will do.

## Extending the vHost configuration
Open your vHost configuration file and spot the **\<VirtualHost \*:443\>** section. Here,
you should find the directives "ServerName", "DocumentRoot", "SSLEngine" as well as 
SSLCertificateFile and SSLCertificateKeyFile, so your vHost is up and running and allows
access via HTTPS.

We are about to add 4 directives here to enable client certificates and let Apache Web Server
verify them automatically. The configuration block should look somewhat like this:

```apacheconfig
SSLCACertificateFile /path/to/your/intermediate.ca.certificate.chainfile.crt
SSLVerifyClient optional_no_ca
SSLVerifyDepth 2
SSLOptions +StdEnvVars +ExportCertData
```

### SSLCACertificateFile
This directive sets the path to the SSL CA certificate that will be used to verify the
client SSL certificate. Be sure to use the chainfile here in case you got a setup with
Root CA certificate and Intermediate CA certificate, so this file should contain both of them.
Alternatively, use SSLCACertificatePath and point it to the directory the certificate is located in.

### SSLVerifyClient
This one enables client certificate verification. Here, you want to set "optional_no_ca" to make verification
optional because in the event of an error the connection won't be refused because of a
SSL handshake failure and you are able to display a nice error page explaining what happened
or send the appropriate API response.

### SSLVerifyDepth
This tellds mod_ssl the maximum number of intermediate certificate issuers which are max allowed
to be followed while verifying the client certificate. 0 means self-signed client certificates only.
1 means the client-certificate can be self-signed or has to be signed by a CA that is directly
known to the server. Choosing 2 allows one Intermediate CA that is not directly known to the server.

### SSLOptions
Setting both options allow your application to inspect both the client and server certificate
and retrieve the verification process's result. In PHP, this can be found in
**$_SERVER['SSL_CLIENT_VERIFY']**. The value is set to NONE in case no client certificate is
sent, SUCCESS when the verification was successful.


