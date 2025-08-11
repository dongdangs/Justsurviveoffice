package com.spring.app.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/login/")
@RequiredArgsConstructor
public class LoginController {
	
	@GetMapping("login")
    public String login() {
        return "login/login";
    }
	
	@GetMapping("idFind")
	public String idFind() {
		return "login/idFind";
	}
	
	
	@GetMapping("pwdFind")
	public String pwdFind() {
		return "login/pwdFind";
	}

}
