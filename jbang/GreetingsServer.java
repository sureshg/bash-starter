///usr/bin/env curl -LSs https://sh.jbang.dev | bash -s - "$0" "$@"; exit $?
//DEPS org.springframework.boot:spring-boot-starter-web:2.3.4.RELEASE

import org.springframework.web.bind.annotation.*;
import org.springframework.boot.*;
import org.springframework.boot.autoconfigure.*;
import org.springframework.context.*;
import org.springframework.context.annotation.Bean;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.context.annotation.*;
import java.util.Collections;

import static java.lang.System.*;

@EnableAutoConfiguration
@Configuration
@RestController
public class GreetingsServer {

  @GetMapping("/")
  java.util.Map<String, String> index() {
    return Collections.singletonMap("greetings", "Hello, world!");
  }

  public static void main(String... args) {
    SpringApplication.run(GreetingsServer.class, args);
  }
}
