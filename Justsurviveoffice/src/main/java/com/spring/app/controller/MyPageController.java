package com.spring.app.controller;

import com.spring.app.entity.Users;
import com.spring.app.service.BoardService;
import com.spring.app.service.UserService;
import com.spring.app.users.domain.BoardDTO;
import com.spring.app.users.domain.BookMarkDTO;
import com.spring.app.users.domain.UsersDTO;

import java.util.HashMap;
import java.util.List;
import java.util.Map;


import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequiredArgsConstructor
@RequestMapping("/mypage/")
public class MyPageController {

    private final UserService userService;
    private final BoardService boardService; 

    // 내정보 화면 (필요시)
    @GetMapping("info")
    public String info() {
    	return "mypage/mypage";
    }

    // 작성한 폼 
    @GetMapping("/forms")    
    public String myBoardList(HttpSession session, Model model) {
        // 로그인 체크 주석 처리
//        Users loginUser = (Users) session.getAttribute("loginUser");
//        if (loginUser == null) {
//            return "redirect:/login";
//        }

        // 임시 테스트용 데이터 (나중에 로그인 완성되면 삭제)
        String testUserId = "testUser";  
        List<BoardDTO> myBoardList = boardService.getBoardsByWriterId(testUserId);
        model.addAttribute("myBoards", myBoardList);
        return "mypage/forms";
    }

    // 북마크
    @GetMapping("/bookmarks")
    public String myBookmarks(HttpSession session, Model model) {
        // 로그인 체크 주석 처리
//        Users loginUser = (Users) session.getAttribute("loginUser");
//        if (loginUser == null) {
//            return "redirect:/login";
//        }

        String testUserId = "testUser";  
        List<BookMarkDTO> bookmarks = boardService.getBookmarksById(testUserId);
        model.addAttribute("myBookmarks", bookmarks);
        return "mypage/bookmarks";
    }

    // 회원 수정 
    @PostMapping("/update")
    public Map<String, Users> update(UsersDTO userDto) {
        
    	Users users = Users.builder()
    			.name(userDto.getName())
    			.email(userDto.getEmail())
    			.mobile(userDto.getMobile())
    			.password(userDto.getPassword())
    			.build();
    	
    	Users user = userService.updateUser(users);
    	
    	Map<String, Users> map = new HashMap<>();
    	map.put("users", user);
    	
    	return map;
    }

	// 회원탈퇴
    @PostMapping("quit")
    @ResponseBody
    public Map<String, Integer> delete(@RequestParam(name="id") String id) {
		int n = userService.delete(id);
		
		Map<String, Integer> map = new HashMap<>();
		map.put("n", n);
		
		return map;
	}
    
    // 이메일 중복확인
    @GetMapping("/email-dup")
    @ResponseBody
    public Map<String, Object> emailDup(@RequestParam(name="email") String email,
			    					                          HttpSession session){
        Users loginUser = (Users) session.getAttribute("loginUser");
        String myId = (loginUser != null ? loginUser.getId() : null);

        boolean duplicated = userService.isEmailDuplicated(email);
        return Map.of("duplicated", duplicated); // true면 중복, false면 사용가능
    	
    }
    
    
    
    
}