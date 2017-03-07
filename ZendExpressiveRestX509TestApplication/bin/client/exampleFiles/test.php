#!/usr/bin/php
<?php
 
$targetUrl = "https://il-test.excell-mobility.de/api/v1/health";
$cert_file = './example.org.pem';
$cert_password = 'example123';
 
$ch = curl_init();
 
$options = array(
    CURLOPT_URL => $targetUrl ,
    CURLOPT_RETURNTRANSFER => true,
    CURLOPT_FOLLOWLOCATION => true,
    CURLOPT_USERAGENT => 'Mozilla/4.0 (compatible; MSIE 5.01; Windows NT 5.0)',

    CURLOPT_SSLCERT => $cert_file,              // remove this line for HTTP/1.1 401 Unauthorized -> "SSL client certificate not sent"
    CURLOPT_SSLCERTPASSWD => $cert_password,
    CURLOPT_SSL_VERIFYHOST => 2,
    CURLOPT_SSL_VERIFYPEER => true,

    // for demo & debugging purpose only!
    CURLOPT_VERBOSE        => true,
);
 
curl_setopt_array($ch , $options);
$output = curl_exec($ch);
 
if(!$output)
{
    echo "Curl Error : " . curl_error($ch);
}
else
{
    echo $output . PHP_EOL;
}