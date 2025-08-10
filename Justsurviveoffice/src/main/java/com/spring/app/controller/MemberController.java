package com.spring.app.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/user/")
@RequiredArgsConstructor
public class MemberController {
	
	@GetMapping("register")
	public String index() {
		return "user/register";
		//     /WEB-INF/views/user/register.jsp 파일을 만들어야 한다.
	}
	
	

}
