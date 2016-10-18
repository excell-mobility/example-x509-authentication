#! /bin/sh
set -e

### CONFIG

CA='TestCa'
CA_PASSWORD='changeit'
CN='TestService123'
CN_PASSWORD='changeitx'
DNAME="C=TT,ST=TestState,L=TestTown,O=TestOrg,OU=TestOrgTest,CN=${CN}"

### SCRIPT

test -e ${CA}.priv.jks || ( echo "CANCEL: Can't find CA-Keyfile ${CA}.priv.jks !" ; exit 1 )

test -e ${CN}.priv.jks && ( echo "CANCEL: File ${CN}.priv.jks alredy exist!" ; exit 1 )

keytool -import -trustcacerts -noprompt -alias ca -file ${CA}.pub.crt -keystore ${CN}.trust.pub.jks -storepass ${CN_PASSWORD}
echo "# Gen: ${CN}.trust.pub.jks"
keytool -genkey -alias ${CN} -keyalg RSA -keysize 4096 -sigalg SHA512withRSA -keypass ${CN_PASSWORD} -validity 3650 -dname ${DNAME} -keystore ${CN}.priv.jks -storepass ${CN_PASSWORD}
echo "# Gen: ${CN}.priv.jks"
keytool -certreq -alias ${CN} -ext BC=ca:true -keyalg RSA -keysize 4096 -sigalg SHA512withRSA -validity 3650 -file ${CN}.csr -keystore ${CN}.priv.jks -storepass ${CN_PASSWORD}
keytool -gencert -alias ${CA} -validity 3650 -sigalg SHA512withRSA -infile "${CN}.csr" -outfile "${CN}.pub.crt" -rfc -keystore ${CA}.priv.jks -storepass ${CA_PASSWORD}
echo "# Gen: ${CN}.pub.crt (${CA}-Signed)"

keytool -import -trustcacerts -alias ${CA} -file ${CA}.pub.crt -keystore ${CN}.priv.jks -storepass ${CN_PASSWORD} -noprompt
echo "# Add: Signed ${CA}.pub.crt to ${CN}.priv.jks"
keytool -import -trustcacerts -alias ${CN} -file ${CN}.pub.crt -keystore ${CN}.priv.jks -storepass ${CN_PASSWORD}
echo "# Add: Signed ${CN}.pub.crt to ${CN}.priv.jks"

keytool -importkeystore -srcalias ${CN} -srckeystore ${CN}.priv.jks -srcstorepass ${CN_PASSWORD} -destkeystore ${CN}.priv.p12 -deststorepass ${CN_PASSWORD} -deststoretype PKCS12
echo "# Gen: ${CN}.priv.p12"


openssl pkcs12 -in ${CN}.priv.p12 -passin pass:${CN_PASSWORD} -out ${CN}.priv.pem -passout pass:${CN_PASSWORD}
echo "# Gen: ${CN}.priv.pem"



