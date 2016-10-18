package test;

import java.util.StringTokenizer;
import javax.net.ssl.SSLPeerUnverifiedException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.client.RestTemplate;

public class Main
{
  private static final Logger log = LoggerFactory.getLogger(Main.class);

  final static String KEYSTORE_PASSWORD = "changeity";

  static
  {
    System.setProperty("javax.net.ssl.trustStore", Main.class.getClassLoader().getResource("TestService321.priv.jks").getFile());
    System.setProperty("javax.net.ssl.trustStorePassword", KEYSTORE_PASSWORD);
    System.setProperty("javax.net.ssl.keyStore", Main.class.getClassLoader().getResource("TestService321.priv.jks").getFile());
    System.setProperty("javax.net.ssl.keyStorePassword", KEYSTORE_PASSWORD);

    javax.net.ssl.HttpsURLConnection.setDefaultHostnameVerifier(new javax.net.ssl.HostnameVerifier()
    {

      private String getCN(String subjectPrincipal)
      {
        StringTokenizer st = new StringTokenizer(subjectPrincipal, ",");
        while (st.hasMoreTokens())
        {
          String tok = st.nextToken().trim();
          if (tok.length() > 3)
          {
            if (tok.substring(0, 3).equalsIgnoreCase("CN=")) { return tok.substring(3); }
          }
        }
        return null;
      }

      public boolean verify(String hostname, javax.net.ssl.SSLSession sslSession)
      {
        String cn = "";
        try
        {
          cn = getCN(sslSession.getPeerPrincipal().getName());
        } catch (SSLPeerUnverifiedException e)
        {}
        
        log.info("Accept: "+cn+" from "+hostname);
        return true;
      }
    });
  }

  public static void main(String args[])
  {
    RestTemplate restTemplate = new RestTemplate();
    String respons = restTemplate.getForObject("https://127.0.0.1:8443/test", String.class);
    log.info(respons);
  }
}