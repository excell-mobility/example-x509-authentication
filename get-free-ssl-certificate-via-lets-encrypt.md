Securing your vHost using a [Let's Encrypt](https://letsencrypt.org/) SSL certificate
=======================================================================================
## What is this all about ?
This tutorial will guide you through the process of obtaining and installing
a free and valid SSL certificate on your (testing / staging) vhost using the
free, automated and totally awesome open certificate authority (CA)
[Let's Encrypt](https://letsencrypt.org), provided by the 
[Internet Security Research Group (ISRG)](https://letsencrypt.org/isrg/).

For the sake of this example, we will request a certificate for the 
Integration Layer's testing vhost at il-test.excell-mobility.de . We will be
using the Electronic Frontier Foundation's [Certbot Software](https://certbot.eff.org/docs/using.html#manual)
in manual mode to gain the certificate and also support shared hosting.

To obtain the certificate, we have to go through the following steps:

1. Download Certbot software from [Github](https://github.com/certbot/certbot)

Let's begin!

## Step 1: Downloading Certbot software from GitHub
Fire up your favorite git client and git clone the Certbot software from the
official GitHub repository:

```bash
$ git clone https://github.com/certbot/certbot.git
$ cd certbot
```

This will download the Certbot software to your current working directory
and enter the Certbot directory.



