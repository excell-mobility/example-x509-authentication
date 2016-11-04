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

- Download Certbot software from their offial [Github repository](https://github.com/certbot/certbot)
- Run Certbot Software to prepare the SSL certificate
- Confirm the Domain Ownership

Let's begin!

## Step 1: Downloading Certbot software from GitHub
On your local machine, fire up your favorite git client and git clone the Certbot software from the
official GitHub repository:

```bash
$ git clone https://github.com/certbot/certbot.git
$ cd certbot
```

This will download the Certbot software to your current working directory
and enter the Certbot directory.

## Step 2: Think before you type ...
Before running the Certbot, we should take a moment to think about the 
SSL certificate's requirements. Using the Certbot software, we are able to gain
a bundled SSL certificate for our domain, including www.yourdomainname.tld .
This is possible by using the -d command-line option, see [command-line options](https://certbot.eff.org/docs/using.html#command-line).
In our case, this will simply be **il-test.excell-mobility.de** .

Secondly, we need to choose a [key size](https://en.wikipedia.org/wiki/Key_size) for our SSL certificate. This will define
the encrypting algorithm's security's upper-bound. Select a key size of your choice, here we will
be using **4096 bits**.

## Step 3: Run the Certbot software!
Now that we know the requirements for our testing vHost's certificate, we run
the Certbot software on our local machine:

```bash
$ ./certbot-auto certonly -a manual --rsa-key-size 4096 -d il-test.excell-mobility.de
```

This will check and update the Certbot's software dependencies like python, libssl etc.
Hit 'Y' to install the update. After the update finishes, the Certbot UI will pop up.
We are asked to enter an email address for urgent notices and lost key recovery.

After that, we are told by the UI to check Let's Encrypt's Terms of Service at the URL given in the Certbot UI.
We read and agree, otherwise canceling the process.

Finally, we're told that our local machine's IP address "will be publicly logged
as having requested this certificate" and if we are OK with that. Hit 'Yes'.
 
## Step 4: Confirm domain ownership

 




