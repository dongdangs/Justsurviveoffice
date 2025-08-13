package com.spring.app.mypage.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.spring.app.users.service.UsersService;

import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor // final 인스턴스 생성자 처리해주기
@Controller
@RequestMapping("mypage/")
public class MypageController {

	private final UsersService service;
	
	@GetMapping("info")
	public String info() {
		return "users/mypage/info";
	}
	
	@GetMapping("forms")
	public String forms() {
		return "users/mypage/forms";
	}
	
	@GetMapping("bookmarks")
	public String bookmarks() {
		return "users/mypage/bookmarks";
	}
	
	
	
}
