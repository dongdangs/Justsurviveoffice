package com.spring.app.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.spring.app.users.service.UsersService;

import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor // final 인스턴스 생성자 처리해주기
@Controller
@RequestMapping("/")
public class IndexController {

	private final UsersService service;
	
	@GetMapping("")
	public String start() {
		return "redirect:/index";
	}

	@GetMapping("index")
	public String index() {
		return "index";
	}
	
	@GetMapping("users/list")
	public String memberList() {
		return "users/list";
		//	/WEB-INF/views/users/list.jsp 파일을 만들어야 한다.
	}
	
	
}
