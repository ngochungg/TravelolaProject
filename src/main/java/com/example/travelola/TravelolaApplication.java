package com.example.travelola;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@SpringBootApplication
@RestController
@RequestMapping("/")
public class TravelolaApplication {

    public static void main(String[] args) {
        SpringApplication.run(TravelolaApplication.class, args);
    }

    @RequestMapping("/")
    public String home() {
        return "Hello World!";
    }
}
