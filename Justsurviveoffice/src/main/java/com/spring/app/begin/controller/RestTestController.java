package com.spring.app.begin.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController  // @RestController 는  @Controller + @ResponseBody 인 것이다.
@RequestMapping(value="/testrest/")
public class RestTestController {

	@GetMapping(path="rest1", produces="text/plain;charset=UTF-8")
	public String rest1() {
		return "안녕하세요? RestController 연습 입니다.";
	}
	
}
