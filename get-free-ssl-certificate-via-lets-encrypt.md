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
- Check the successfully gained SSL certificate
- Use the SSL certificate with your favorite webserver software!

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
the encrypting algorithm's security's upper-bound. A nice collection of safer encryption parameters
for different applications and a good starting point for further reeding is 
[https://cipherli.st/](https://cipherli.st/).Select a key size of your choice, here we will
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
Now, Let's Encrypt's challenge is presented to confirm our domain ownership
over the selected domain. We are asked to place a specifically named text file with a given content
in our domain's public directory:
 
> Make sure your web server displays the following content at
> http://il-test.excell-mobility.de/.well-known/acme-challenge/o7h_Qhc-GjJAih7MQrLKXNW9lkbLaAUoZBr39RkOL5M before continuing:
>
> o7h_Qhc-GjJAih7MQrLKXNW9lkbLaAUoZBr39RkOL5M.hp8D7bl4glWiyAZnmT_at4sEOh_lT9BnYA3gI-OEjDE

So we create the file locally and fill in the requested content:

```bash
$ echo 'o7h_Qhc-GjJAih7MQrLKXNW9lkbLaAUoZBr39RkOL5M.hp8D7bl4glWiyAZnmT_at4sEOh_lT9BnYA3gI-OEjDE' > o7h_Qhc-GjJAih7MQrLKXNW9lkbLaAUoZBr39RkOL5M
```
 
After that, we access our testing vHost's public directory and put the file
into the subdirectoy **./well-known/acme-challange** like requested. We double-check this by opening our favorite browser and entering the file's URL:

http://il-test.excell-mobility.de/.well-known/acme-challenge/logw2Uc22wdqdM2ffasSODR171DW8R19u4BKaEsmruw

This successfully displays the file content, so we're ready to let Certbot do
his thing and confirm that we legitimately own il-test.excell-mobility.de .
Hit 'Enter' to continue.

## Step 5: check the successfully gained SSL certificate
Certbot created the private key locally (at least they say so) using a key size
of 4096 bits and put it into the local machine's directory **/etc/letsencrypt/live/il.test.excell-mobility.de** .
The Certificate Signing Request (CSR) file will be found there, too.
We need sudo rights to access the private key.

Now it's time to validate our new and shiny SSL certificate:
```bash
$ openssl x509 -in /etc/letsencrypt/live/il-test.excell-mobility.de/cert.pem -text
```

The certificate is **valid for 90 days** for our domain il-test.excell-mobility.de, created
by the **Let's Encrypt Authority X3** using a key size of **4096 bits** . Awesome!


## Step 6: Upgrade your vhost to support / enforce HTTPS connections
As there are many different web servers out there like Apache webserver, nginx, lighttpd etc., 
we'll focus on setting up the SSL certificate with Apache webserver. For a tutorial on setting up
SSL certificates using other webserver software, like nginx, please consult your favorite
search engine (["install ssl certificate ubuntu"](https://www.google.de/?q=install%20ssl%20certificate%20ubuntu)).

We'll be upgrading the existing vhost to enforce HTTPS connections only by extending the vhost and .htaccess configuration.
Let's start with the Apache vhost configuration. We open the vhost configuration file **il-test.excell-mobility.de.conf**
and modify port the webserver is listening on to the SSL standard port 443:

```apache
<VirtualHost *:443>
```



Cheers! 🍻

