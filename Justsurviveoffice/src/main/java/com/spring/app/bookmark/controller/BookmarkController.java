package com.spring.app.bookmark.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import com.spring.app.users.domain.BookMarkDTO;
import com.spring.app.bookmark.service.BookmarkService;
import com.spring.app.users.domain.UsersDTO;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@RequestMapping("/bookmark")
public class BookmarkController {

    private final BookmarkService bookMarkService;

    // 북마크 추가
    @PostMapping("/add")
    @ResponseBody
    public Map<String, Object> addBookmark(@RequestParam(name="fk_boardNo") Long fk_boardNo, HttpSession session) {
        Map<String, Object> result = new HashMap<>();

        UsersDTO loginUser = (UsersDTO) session.getAttribute("loginUser");
        if (loginUser == null) {
            result.put("success", false);
            result.put("message", "로그인이 필요합니다.");
            return result;
        }

        bookMarkService.addBookmark(loginUser.getId(), fk_boardNo);
        result.put("success", true);
        result.put("message", "북마크가 추가되었습니다.");
        return result;
    }

    // 북마크 삭제
    @PostMapping("/remove")
    @ResponseBody
    public Map<String, Object> removeBookmark(@RequestParam(name="fk_boardNo") Long fk_boardNo,
                                             HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        UsersDTO loginUser = (UsersDTO) session.getAttribute("loginUser");

        if (loginUser == null) {
            result.put("success", false);
            result.put("message", "로그인이 필요합니다.");
            return result;
        }

        long deleted = bookMarkService.removeBookmark(loginUser.getId(), fk_boardNo);
        result.put("success", deleted > 0);
        if (deleted == 0) {
            result.put("message", "삭제할 북마크가 없습니다.");
        }
        return result;
    }

    // 마이페이지 북마크 목록
    @GetMapping("/mypage")
    public String getBookmarks(HttpSession session, Model model) {
        UsersDTO loginUser = (UsersDTO) session.getAttribute("loginUser");
        if (loginUser == null) return "login/loginForm";

        List<BookMarkDTO> bookmarks = bookMarkService.getUserBookmarks(loginUser.getId());
        model.addAttribute("myBookmarks", bookmarks);

        return "mypage/bookmarks";
    }
    
    
    
}