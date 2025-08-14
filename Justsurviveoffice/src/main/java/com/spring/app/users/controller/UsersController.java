package com.spring.app.users.controller;

import java.util.HashMap;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.spring.app.entity.Users;
import com.spring.app.users.service.UsersService;

import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor // final 인스턴스 생성자 처리해주기
@Controller
@RequestMapping("users/")
public class UsersController {
	
	private final UsersService usersService;
	
	@GetMapping("login")
	public String login() {
		return "login/loginForm";
	}
	

	@GetMapping("register")
	public String showRegisterForm() {
		return "user/register";
	}
	
	@PostMapping("registerUser")
	public String registerUser(@RequestParam("hp1") String hp1,
							   @RequestParam("hp2") String hp2,
							   @RequestParam("hp3") String hp3,
							   Users user) {
		
	    String mobile = hp1 + hp2 + hp3;
	    user.setMobile(mobile);

	    usersService.registerUser(user);

	    return "login/loginForm	";
	}
	
	
	@PostMapping("checkIdDuplicate")
	@ResponseBody
	public Map<String, Boolean> checkIdDuplicate(@RequestParam("id") String id) {
		
	    boolean isExists = usersService.isIdExists(id);

	    Map<String, Boolean> map = new HashMap<>();
	    map.put("isExists", isExists);

	    return map;
	}
	
	
	@PostMapping("checkEmailDuplicate")
	@ResponseBody
	public Map<String, Boolean> checkEmailDuplicate(@RequestParam("email") String email) {
		
	    boolean isExists = usersService.isEmailExists(email);

	    Map<String, Boolean> map = new HashMap<>();
	    map.put("isExists", isExists);

	    return map;
	}
	



	
}
