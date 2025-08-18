package com.spring.app.login.controller;

import java.time.LocalDateTime;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;


import com.spring.app.users.domain.LoginHistoryDTO;
import com.spring.app.common.Sha256;

import com.spring.app.entity.Users;
import com.spring.app.mail.controller.GoogleMail;
import com.spring.app.users.domain.LoginHistoryDTO;
import com.spring.app.users.domain.UsersDTO;
import com.spring.app.users.service.UsersService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("login/")
@RequiredArgsConstructor  //Lombok이 제공하는 기능으로,final이나 @NonNull이 붙은 필드를 대상으로 생성자를 자동 생성
public class LoginController {

	private final UsersService usersService; //@RequiredArgsConstructor를 선언해야만 자동으로 fianl 생성자 생성.
	private final GoogleMail mail;
	
	@GetMapping("loginForm")
	public String login() {
		return "login/loginForm";
	}
	
	@PostMapping("login")
	public String loginEnd(@RequestParam(name="id") String id,
	                       @RequestParam(name="password") String Pwd,
	                       HttpServletRequest request,
	                       HttpServletResponse response) {
		/* 250818 GIT 김예준 오후 14:00 git 업데이트 전 시작 v1*/
	    UsersDTO usersDto = usersService.getUser(id, Pwd); 

	    String enPwd;
	    try {
	    	enPwd = Sha256.encrypt(Pwd);
	    } catch (Exception e) {
	        request.setAttribute("message", "로그인 실패!!");
	        request.setAttribute("loc", request.getContextPath()+"/login/loginForm");
	        return "msg";
	    }

	    if (usersDto == null || !enPwd.equalsIgnoreCase(usersDto.getPassword())) {
	        request.setAttribute("message", "로그인 실패!!");
	        request.setAttribute("loc", request.getContextPath()+"/login/loginForm");
	        return "msg";
	    }

	    /* 250818 GIT 김예준 오후 14:00 git 업데이트 전 중간 v1*/
	    usersDto.setPassword(null);

	    HttpSession session = request.getSession();
	    session.setAttribute("loginUser", usersDto);

	    LoginHistoryDTO loginHistoryDTO = LoginHistoryDTO.builder()
							            .lastLogin(LocalDateTime.now())
							            .ip(request.getRemoteAddr())
							            .users(usersService.toEntity(usersDto))
							            .build();
	    usersService.saveLoginHistory(loginHistoryDTO);
	    /* 250818 GIT 김예준 오후 14:00 git 업데이트 전 끝 v1*/
	    return "redirect:/index";
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

	    UsersDTO usersDTO = usersService.getIdFind(name, email);

		String message = "없습니다 되었습니다.";
		String loc = request.getContextPath()+"/";  // 시작 페이지로 이동
	    
	    if (usersDTO != null) {
	        model.addAttribute("usersDTO", usersDTO.getId());
	    } 

	    return "login/idFind"; // 기존 뷰
	}
	
	@GetMapping("pwdFindForm")
	public String pwdFind(HttpSession session, HttpServletRequest request) {
		
		// 세션에 값이 있으면 jsp 에 전달, 없으면 빈 값
		String id = (String) session.getAttribute("pwdFindId");
		String email = (String) session.getAttribute("pwdFindEmail");
		
		request.setAttribute("id", id != null ? id : "");
	    request.setAttribute("email", email != null ? email : "");
		
		return "login/pwdFind";
	}
	
	
	@PostMapping("passwordFind")
	public String passwordFind(@RequestParam(name="id") String id,
							   @RequestParam(name="email") String email,
							   HttpServletRequest request, HttpSession session) {
		
		// 1. 유저 존재 여부 확인
        Users users = usersService.findByIdAndEmail(id, email);

        if(users == null) {
        	request.setAttribute("n", 0);
            request.setAttribute("method", "POST");
            return "login/pwdFind"; 
        }
        
        // 2. 인증코드 생성 (6자리 랜덤 숫자)
        String certification_code = String.valueOf((int)(Math.random() * 900000) + 100000);

        // 3. 세션에 저장 
        session.setAttribute("certification_code", certification_code);
        
        // 4. 메일 전송
        try {
        	mail.send_certification_code(email, certification_code);
        	
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
		
		String certification_code = (String) session.getAttribute("certification_code");
		
		String message = "";
		String loc = "";
		
		if(certification_code != null && certification_code.equals(userCertificationCode)) {
			
			message = "인증이 성공되었습니다.";
			loc = request.getContextPath() + "/login/pwdUpdate?id=" + id;
			
		}
		else {
			
			message = "발급된 인증코드가 아닙니다. 인증코드를 다시 발급받으세요.";
			loc = request.getContextPath() + "/login/pwdFindForm";
			
		}
		
		request.setAttribute("id", id);
		request.setAttribute("message", message);
		request.setAttribute("loc", loc);

		session.removeAttribute("certification_code");
		
		return "msg";
	}
	
	
	@GetMapping("pwdUpdate")
	public String pwdUpdateForm(@RequestParam(name="id") String id
			      			  , Model model) {
		model.addAttribute("id", id);
		return "login/pwdUpdate";
	}
	
	
	@PostMapping("pwdUpdate")
	public String pwdUpdate(@RequestParam(name="id") String id
						  , @RequestParam("newPassword2") String newPassword
						  , HttpServletRequest request) {
		
		usersService.updatePassword(id, newPassword);
		
		String message = "비밀번호가 변경되었습니다.";
		String loc = request.getContextPath() + "/login/loginForm";
		
		request.setAttribute("message", message);
		request.setAttribute("loc", loc);
		
		return "msg";
	}

	
	
}








