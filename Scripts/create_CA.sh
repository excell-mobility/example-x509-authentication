#! /bin/sh
set -e

PASSWORD='changeit'
CA='TestCa'
DNAME="C=TT,ST=TestState,L=TestTown,O=TestOrg,OU=TestOrgTest,CN=${CA}"

test -e ${CA}.priv.jks && ( echo "CANCEL: ${CA}.priv.jks alredy exist!" ; exit 1 )

keytool -genkey -alias ${CA} -ext BC=ca:true -keyalg RSA -keysize 4096 -sigalg SHA512withRSA -keypass ${PASSWORD} -validity 3650 -dname ${DNAME} -keystore ${CA}.priv.jks -storepass ${PASSWORD}
echo "# Gen: ${CA}.priv.jks"
keytool -v -importkeystore -srckeystore ${CA}.priv.jks -srcstorepass ${PASSWORD} -srcalias ${CA} -destkeystore ${CA}.priv.p12 -deststorepass ${PASSWORD} -deststoretype PKCS12
echo "# Gen: ${CA}.priv.p12"
openssl pkcs12 -in ${CA}.priv.p12 -passin pass:${PASSWORD} -out ${CA}.priv.pem -passout pass:${PASSWORD}
echo "# Gen: ${CA}.priv.pem"
keytool -export -alias ${CA} -file ${CA}.pub.crt -rfc -keystore ${CA}.priv.jks -storepass ${PASSWORD}
echo "# Gen: ${CA}.pub.crt"
keytool -import -trustcacerts -noprompt -alias ${CA} -file ${CA}.pub.crt -keystore ${CA}.pub.jks -storepass ${PASSWORD}
echo "# Gen: ${CA}.pub.jks"

