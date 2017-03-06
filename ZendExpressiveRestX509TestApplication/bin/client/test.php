<?php
 
$url = "https://example-x509-authentication.dev";
$cert_file = './example.org.pem';
$cert_password = 'example123';
 
$ch = curl_init();
 
$options = array( 
    CURLOPT_RETURNTRANSFER => true,
    //CURLOPT_HEADER         => true,
    CURLOPT_FOLLOWLOCATION => true,
    CURLOPT_SSL_VERIFYHOST => false,
    CURLOPT_SSL_VERIFYPEER => false,
     
    CURLOPT_USERAGENT => 'Mozilla/4.0 (compatible; MSIE 5.01; Windows NT 5.0)',
    //CURLOPT_VERBOSE        => true,
    CURLOPT_URL => $url ,
    CURLOPT_SSLCERT => $cert_file ,
    CURLOPT_SSLCERTPASSWD => $cert_password ,
);
 
curl_setopt_array($ch , $options);
 
$output = curl_exec($ch);
 
if(!$output)
{
    echo "Curl Error : " . curl_error($ch);
}
else
{
    echo htmlentities($output);
}