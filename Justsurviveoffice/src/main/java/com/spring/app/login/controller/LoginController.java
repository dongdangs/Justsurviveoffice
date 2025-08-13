package com.spring.app.login.controller;

import java.time.LocalDateTime;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.spring.app.users.domain.LoginHistoryDTO;
import com.spring.app.users.domain.UsersDTO;
import com.spring.app.users.service.UsersService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("login/")
@RequiredArgsConstructor  //Lombok이 제공하는 기능으로,final이나 @NonNull이 붙은 필드를 대상으로 생성자를 자동 생성
public class LoginController {

	private final UsersService userService; //@RequiredArgsConstructor를 선언해야만 자동으로 fianl 생성자 생성.
	
	@GetMapping("loginForm")
	public String login() {
		return "login/loginForm";
	}
	
	@PostMapping("login")
	public String loginEnd(@RequestParam(name="id") String Id, // form 태그의 name 속성값과 같은것이 매핑되어짐
						   @RequestParam(name="password") String Pwd, // form 태그의 name 속성값과 같은것이 매핑되어짐
						   @RequestParam(name="remember-id", defaultValue ="") String rememberId,
						   HttpServletRequest request) {
		
		UsersDTO usersDto = userService.getUser(Id);
		
		if(usersDto == null || !Pwd.equals(usersDto.getPassword()) ) {
			
			String message = "로그인 실패!!";
			String loc = request.getContextPath()+"/login/loginForm"; // 로그인 페이지로 이동
	                   
			request.setAttribute("message", message);
			request.setAttribute("loc", loc);
			return "msg";
		}
		
		// 세션에 로그인 사용자 정보 저장
		
		HttpSession session = request.getSession();
		session.setAttribute("loginUser", usersDto);
			
		 // 로그인 기록 저장
	    LoginHistoryDTO loginHistoryDTO = LoginHistoryDTO.builder()
	                					.lastLogin(LocalDateTime.now())  // 현재 로그인 시간
	                					.ip(request.getRemoteAddr())     // 접속 IP
	                					.users(userService.toEntity(usersDto)) // DTO -> 엔티티 변환 메서드 필요
	                					.build();

	    userService.saveLoginHistory(loginHistoryDTO);

		
		
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
	
	@GetMapping("register")
	public String register() {
		return "login/register";
	}
	
	@GetMapping("idFind")
	public String idFind() {
		return "login/idFind";
	}
	
	@PostMapping("idFind")
	public String idFind(@RequestParam(name="name") String name, // form 태그의 name 속성값과 같은것이 매핑되어짐
			   			 @RequestParam(name="email") String email,
			   			 Model model,
			   			 HttpServletRequest request) {
//		
	    UsersDTO usersDTO = userService.getIdFind(name, email);

		String message = "없습니다 되었습니다.";
		String loc = request.getContextPath()+"/";  // 시작 페이지로 이동
	    
	    if (usersDTO != null) {
	        model.addAttribute("usersDTO", usersDTO.getId());
	    } 

	    return "login/idFind"; // 기존 뷰
	}
	
	@GetMapping("pwdFind")
	public String pwdFind() {
		return "login/pwdFind";
	}
	
//	
//	@PostMapping("loginEnd")
//	public String loginEnd(@RequestParam(name="userId") String userId,   // form 태그의 name 속성값과 같은것이 매핑되어짐
//			               @RequestParam(name="userPwd") String userPwd, // form 태그의 name 속성값과 같은것이 매핑되어짐 
//			               HttpServletRequest request) {
//		
//		UsersService mbrDto = memberService.getMember(userId);
//		
//		if(mbrDto == null || !userPwd.equals(mbrDto.getUserPwd()) ) {
//			
//			String message = "로그인 실패!!";
//		 	String loc = request.getContextPath()+"/login/loginStart"; // 로그인 페이지로 이동
//		 	   	   
//		 	request.setAttribute("message", message);
//		 	request.setAttribute("loc", loc);
//		 	return "msg";
//		}
//		
//		// 세션에 로그인 사용자 정보 저장
//		HttpSession session = request.getSession();
//		session.setAttribute("loginuser", mbrDto);
//		
//		return "redirect:"+request.getContextPath()+"/index"; // 인덱스 페이지로 이동 
//	}
//	
	
}








