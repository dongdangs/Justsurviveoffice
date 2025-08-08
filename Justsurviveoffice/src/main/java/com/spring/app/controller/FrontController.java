package com.spring.app.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class FrontController {

    @GetMapping({"/", "/index"})
    public String start() {
        return "index";
    }
    
    @GetMapping("login")
    public String login() {
        return "login";
    }

}