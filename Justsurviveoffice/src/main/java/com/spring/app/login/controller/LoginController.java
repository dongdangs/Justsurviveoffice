package com.spring.app.login.controller;

import java.util.HashMap;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.spring.app.entity.Users;
import com.spring.app.mail.controller.GoogleMail;
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
	private final GoogleMail mail;
	
	@GetMapping("loginForm")
	public String login() {
		return "login/loginForm";
	}
	
	@PostMapping("login")
	public String loginEnd(@RequestParam(name="id") String Id, // form 태그의 name 속성값과 같은것이 매핑되어짐
						   @RequestParam(name="password") String Pwd, // form 태그의 name 속성값과 같은것이 매핑되어짐
						   @RequestParam(name="remember-id") String rememberId,
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
		if(rememberId != null) {
			HttpSession session = request.getSession();
			session.setAttribute("loginUser", usersDto);
		}
		
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
	
	
	@GetMapping("pwdFindForm")
	public String pwdFind() {
		return "login/pwdFind";
	}
	
	
	@PostMapping("passwordFind")
	public String passwordFind(@RequestParam(name="id") String id,
							   @RequestParam(name="email") String email,
							   HttpServletRequest request,
							   HttpSession session) {
		
		// 1. 유저 존재 여부 확인
        Users users = userService.findByIdAndEmail(id, email);

        if(users == null) {
        	request.setAttribute("n", 0);
            request.setAttribute("method", "POST");
            return "user/passwordFind"; 
        }
        
        // 2. 인증코드 생성 (6자리 랜덤 숫자)
        String code = String.valueOf((int)(Math.random() * 900000) + 100000);

        // 3. 세션에 저장 
        session.setAttribute("certificationCode", code);
        
        // 4. 메일 전송
        try {
        	mail.send_certification_code(email, code);
        	
			request.setAttribute("n", 1); 
        	
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("n", 0);
        }

        // JSP에서 보여줄 값 세팅
        request.setAttribute("id", id);
        request.setAttribute("email", email);
        request.setAttribute("method", "POST");

        return "login/pwdFind";
	}
	
	
	@PostMapping("verifyCertification")
	public String verifyCertification(@RequestParam("userCertificationCode") String userCertificationCode,
            						  @RequestParam("id") String id,
            						  HttpSession session,
            						  HttpServletRequest request) {
		
		
		
		return "login/pwdUpdate";
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








