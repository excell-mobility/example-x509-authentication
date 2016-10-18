package test;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;
import org.springframework.security.config.annotation.method.configuration.EnableGlobalMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.core.authority.AuthorityUtils;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;

@SpringBootApplication
@EnableWebSecurity
@EnableGlobalMethodSecurity(prePostEnabled = true)
public class Main extends WebSecurityConfigurerAdapter
{
  private static final Logger log = LoggerFactory.getLogger(Main.class);
  
  public static void main(String[] args)
  {   
    SpringApplication.run(Main.class, args);
  }

  @Override
  protected void configure(HttpSecurity http) throws Exception
  {
    http.authorizeRequests().anyRequest().authenticated().and().x509().subjectPrincipalRegex("CN=(.*?)(?:,|$)").userDetailsService(userDetailsService());
  }

  @Bean
  public UserDetailsService userDetailsService()
  {
    return new UserDetailsService()
    {
      @Override
      public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException
      {
        
        log.info("Login as: " + username);
        return new User(username, "", AuthorityUtils.commaSeparatedStringToAuthorityList("ROLE_USER"));
      }
    };
  }
}
