package com.spring.app.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.spring.app.service.UserService;
import com.spring.app.users.domain.UsersDTO;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/login/")
@RequiredArgsConstructor
public class LoginController {

	private final UserService userService;
	
	@GetMapping("loginStart")
	public String login() {
		
		return "login/login";
	}
	
	
	@PostMapping("loginEnd")
	public String loginEnd(@RequestParam(name="id") String Id, // form 태그의 name 속성값과 같은것이 매핑되어짐
						   @RequestParam(name="password") String Pwd, // form 태그의 name 속성값과 같은것이 매핑되어짐
						   HttpServletRequest request) {
		
		UsersDTO usersDto = userService.getUser(Id);
		
		if(usersDto == null || !Pwd.equals(usersDto.getPassword()) ) {
			
			String message = "로그인 실패!!";
			String loc = request.getContextPath()+"/login/loginStart"; // 로그인 페이지로 이동
	                   
			request.setAttribute("message", message);
			request.setAttribute("loc", loc);
			return "msg";
		}
		
		// 세션에 로그인 사용자 정보 저장
		HttpSession session = request.getSession();
		session.setAttribute("loginuser", usersDto);
		
		return "index"; // 인덱스 페이지로 이동
	}
	
	
	@GetMapping("logout")
	public String loginout(HttpServletRequest request) {
	      
		HttpSession session = request.getSession();
		session.invalidate();
	      
		String message = "로그아웃 되었습니다.";
		String loc = request.getContextPath()+"/";  // 시작 페이지로 이동
	                
		request.setAttribute("message", message);
		request.setAttribute("loc", loc);
		return "msg";
	}
	
	
	@GetMapping("pwdFind")
	public String pwdFind() {
		
		return "login/pwdFind";
	}
	
	
//	@PostMapping("passwordFind")
	
	
}




