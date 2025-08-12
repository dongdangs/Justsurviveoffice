package com.spring.app.controller;

import java.util.HashMap;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.spring.app.entity.Users;
import com.spring.app.service.UserService;

import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/user/")
@RequiredArgsConstructor
public class UserController {
	
	private final UserService userService;
	
	@GetMapping("register")
	public String showRegisterForm() {
		return "user/register";
	}
	
	
	@PostMapping("checkIdDuplicate")
	@ResponseBody
	public Map<String, Boolean> checkIdDuplicate(@RequestParam("id") String id) {
		
	    boolean isExists = userService.isIdExists(id);

	    Map<String, Boolean> map = new HashMap<>();
	    map.put("isExists", isExists);

	    return map;
	}
	
	
	@PostMapping("checkEmailDuplicate")
	@ResponseBody
	public Map<String, Boolean> checkEmailDuplicate(@RequestParam("email") String email) {
		
	    boolean isExists = userService.isEmailExists(email);

	    Map<String, Boolean> map = new HashMap<>();
	    map.put("isExists", isExists);

	    return map;
	}
	
	
	@PostMapping("registerUser")
	public String registerUser(@RequestParam("hp1") String hp1,
							   @RequestParam("hp2") String hp2,
							   @RequestParam("hp3") String hp3,
							   Users user) {
		
	    String mobile = hp1 + hp2 + hp3;
	    user.setMobile(mobile);

	    userService.registerUser(user);

	    return "login/login";
	}

}
