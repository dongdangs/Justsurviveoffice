package com.spring.app.mypage.controller;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.spring.app.users.domain.BookMarkDTO;
import com.spring.app.admin.service.AdminService;
import com.spring.app.board.domain.BoardDTO;
import com.spring.app.board.service.BoardService;
import com.spring.app.category.domain.CategoryDTO;
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
    
    
    private final AdminService adminService;

    // 내정보 화면
    @GetMapping("info")
    public String info() {
        return "users/mypage/info";
    }

 // 내가 작성한 글 목록
    @GetMapping("forms")
    public String myBoardList(HttpSession session, Model model) {
        UsersDTO loginUser = (UsersDTO) session.getAttribute("loginUser");
        if (loginUser == null) {
            return "login/loginForm";
        }

        List<BoardDTO> boardList = boardService.getMyBoards(loginUser.getId());
        model.addAttribute("myBoards", boardList);
        return "users/mypage/forms";
    }

    // 북마크 목록
    @GetMapping("bookmarks")
    public String myBookmarks(HttpSession session, Model model) {
        UsersDTO loginUser = (UsersDTO) session.getAttribute("loginUser");
        if (loginUser == null) {
            return "login/loginForm";
        }

        model.addAttribute("myBookmarks", boardService.getBookmarksById(loginUser.getId()));
        return "users/mypage/bookmarks";
    }

    // 회원 정보 수정
    @PostMapping("update")
    public String update(UsersDTO userDto, HttpServletRequest request, HttpSession session) {
        UsersDTO updatedUser = usersService.updateUser(userDto);

        // 세션 갱신
        session.setAttribute("loginUser", updatedUser);

        String message = "정보가 변경되었습니다.";
        String loc = request.getContextPath() + "/mypage/info";

        request.setAttribute("message", message);
        request.setAttribute("loc", loc);

        return "msg";
    }

    // 회원 탈퇴
    @PostMapping("quit")
    @ResponseBody
    public Map<String, Integer> delete(@RequestParam(name = "id") String id, HttpSession session) {
        int n = usersService.delete(id);
        if (n == 1) {
            session.invalidate(); // 로그아웃 처리
        }
        return Map.of("n", n);
    }

    // 이메일 중복확인
    @GetMapping("emailDuplicate")
    @ResponseBody
    public Map<String, Object> emailDup(@RequestParam(name = "email") String email, HttpSession session) {
        UsersDTO loginUser = (UsersDTO) session.getAttribute("loginUser");
        String myId = (loginUser != null ? loginUser.getId() : null);

        boolean duplicated = usersService.isEmailDuplicated(email);
        return Map.of("duplicated", duplicated);
    }
    
    
    // 마이페이지 내 통계로 이동
    @GetMapping("chart")
    public String chartForm() {
        return "users/mypage/chart";
    }
    
	
	// 카테고리별 게시물 통계
    @PostMapping("chart/categoryByBoard")
    @ResponseBody 
    public List<CategoryDTO> categoryByBoard() {
    	List<CategoryDTO> boardPercentageList = usersService.categoryByBoard(); 
    	return boardPercentageList;
    }
	 
    
    // 카테고리별 인원수 통계
    @PostMapping("chart/categoryByUsers")
    @ResponseBody
    public List<CategoryDTO> categoryByUsers() {
    	List<CategoryDTO> usersPercentageList = usersService.categoryByUsers(); 
    	return usersPercentageList;
    }
    
    
	   
    
    
}