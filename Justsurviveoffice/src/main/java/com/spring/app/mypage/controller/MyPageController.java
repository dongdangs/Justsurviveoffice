package com.spring.app.mypage.controller;


import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.spring.app.board.service.BoardService;
import com.spring.app.entity.Users;
import com.spring.app.users.domain.BoardDTO;
import com.spring.app.users.domain.BookMarkDTO;
import com.spring.app.users.domain.UsersDTO;
import com.spring.app.users.service.UsersService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@RequestMapping("mypage/")
public class MyPageController {
 
    private final UsersService usersService;
    private final BoardService boardService; 

    // 내정보 화면 (필요시)

    @GetMapping("info")
    public String info() {
		return "users/mypage/info";
    }

    // 작성한 폼 
    @GetMapping("forms")    
    public String myBoardList(HttpSession session, Model model) {
        // 로그인 체크 주석 처리
    	UsersDTO loginUser = (UsersDTO) session.getAttribute("loginUser");
    	if (loginUser == null) {
    		return "login/loginForm";
        }

        List<BoardDTO> myBoardList = boardService.getBoardsByWriterId(loginUser.getId());
        model.addAttribute("myBoards", myBoardList);
        return "users/mypage/forms";
    }

    // 북마크
    @GetMapping("bookmarks")
    public String myBookmarks(HttpSession session, Model model) {
        // 로그인 체크 주석 처리
    	UsersDTO loginUser = (UsersDTO) session.getAttribute("loginUser");
        if (loginUser == null) {
    		return "login/loginForm";
        }

        List<BookMarkDTO> bookmarks = boardService.getBookmarksById(loginUser.getId());
        model.addAttribute("myBookmarks", bookmarks);
        return "users/mypage/bookmarks";
    }

    // 회원 수정 
    @PostMapping("update")
    public String update(UsersDTO userDto, HttpServletRequest request) {

        Users user = usersService.updateUser(userDto);

        String message = "정보가 변경되었습니다.";
        String loc = request.getContextPath() + "/mypage/info"; // 수정 후 이동할 페이지

        request.setAttribute("message", message);
        request.setAttribute("loc", loc);

        return "msg";
    }

	// 회원탈퇴
    @PostMapping("quit")
    @ResponseBody
    public Map<String, Integer> delete(@RequestParam(name="id") String id, HttpSession session) {
        int n = usersService.delete(id);
        if (n == 1) {
            session.invalidate(); // 로그아웃 처리
        }
        return Map.of("n", n);
    }
    
    
    // 이메일 중복확인
    @GetMapping("emailDuplicate")
    @ResponseBody
    public Map<String, Object> emailDup(@RequestParam(name="email") String email,
			    					                          HttpSession session){
    	UsersDTO loginUser = (UsersDTO) session.getAttribute("loginUser");
        String myId = (loginUser != null ? loginUser.getId() : null);

        boolean duplicated = usersService.isEmailDuplicated(email);
        return Map.of("duplicated", duplicated); // true면 중복, false면 사용가능
    	
    }
    
   
    
    
}