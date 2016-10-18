package test;

import java.security.Principal;

//import java.security.Principal;
//import org.springframework.security.core.userdetails.UserDetails;

import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class Controller
{
  @PreAuthorize("hasAuthority('ROLE_USER')")
  @GetMapping("/test")
  public String test(Principal principal)
  {
    UserDetails currentUser = (UserDetails) ((Authentication) principal).getPrincipal();
    return "OK " + currentUser.getUsername();
    
  }
}
