package com.spring.app.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/")
public class IndexController {

	@GetMapping("")
	public String start() {
		return "redirect:/index";
	}

	@GetMapping("index")
	public String index() {
		return "index";
	}
	
	@GetMapping("users/list")
	public String usersList() {
		return "users/list";
	} 
	@GetMapping("test")
	public String test() {
		return "test1/test1";
	}
	
}
