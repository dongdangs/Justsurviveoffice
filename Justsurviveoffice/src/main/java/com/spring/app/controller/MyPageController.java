package com.spring.app.controller;

import com.spring.app.entity.Users;
import com.spring.app.service.BoardService;
import com.spring.app.service.UserService;
import com.spring.app.users.domain.UsersDTO;

import java.util.List;

import com.spring.app.domain.BoardDTO;
import com.spring.app.domain.BookMarkDTO;

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
    public String update(@ModelAttribute UsersDTO dto, HttpSession session) {
        Users updated = userService.updateUser(dto);   
        session.setAttribute("loginUser", updated);    
        return "redirect:/mypage/info?updated=1";
    }

    // 이메일 중복확인 (AJAX)
//    @GetMapping("/email-dup")
//    @ResponseBody
//    public boolean emailDup(@RequestParam String email, HttpSession session) {
//        // 로그인 체크 주석 처리
////        Users me = (Users) session.getAttribute("loginUser");
////        String myId = (me == null ? null : me.getId());
//        
//        String myId = "testUser"; // 임시 ID
//        return userService.isEmailDuplicated(email, myId);
//    }
    
}