package com.spring.app.chatting.controller;

import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.locks.ReentrantLock;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.spring.app.users.domain.UsersDTO;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

//=== (#웹채팅관련3) ===

@Controller
@RequestMapping("/chatting/")
public class ChattingController {

	  // === 채팅방 제약 상태(서버 전역에서 공유) ===
    private final Set<Long> occupiedCategories = ConcurrentHashMap.<Long>newKeySet();
    private final ReentrantLock admissionLock = new ReentrantLock();

    @GetMapping("multichat")
    public String requiredLogin_multichat(HttpServletRequest request, HttpServletResponse response) {

        HttpSession session = request.getSession(false);
        // 일단 session 메서드 불러와야함.
        
        UsersDTO loginUser = (session != null) ? (UsersDTO) session.getAttribute("loginUser") : null;

        if (loginUser == null || loginUser.getCategory() == null) {
            request.setAttribute("message", "로그인이 필요합니다!");
            request.setAttribute("loc", request.getContextPath() + "/users/loginForm");
            return "msg";
        }

        Long userCategoryNo = loginUser.getCategory().getCategoryNo();

        admissionLock.lock();
        try {
            // 이미 같은 카테고리가 있으면 거부하는 문
            if (occupiedCategories.contains(userCategoryNo)) {
                request.setAttribute("message", "이미 해당 카테고리에서 접속 중인 사용자가 있습니다!");
                request.setAttribute("loc", request.getContextPath() + "/users/loginForm");
                return "msg";
            }

            //  각 유저들의 가져온 카테고리번호가 5개로 꽉 찼으면 거부
            if (occupiedCategories.size() >= 5 ) {
                request.setAttribute("message", "채팅방은 최대 5개 카테고리까지만 입장 가능합니다!");
                request.setAttribute("loc", request.getContextPath() + "/users/loginForm");
                return "msg";
            }

            occupiedCategories.add(userCategoryNo);

        } finally {
            admissionLock.unlock();
        }

        // 정상 입장
        return "/chatting/multichat";
    }
	
}

