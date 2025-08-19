package com.spring.app.board.controller;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.spring.app.board.service.BoardService;
import com.spring.app.users.domain.BoardDTO;

import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/board/")
@RequiredArgsConstructor
public class BoardController {

	// === 생성자 주입(Constructor Injection) === //
	private final BoardService boardService;
	
	
	// '금쪽이' 게시판
	@GetMapping("nointerList")
	public String nointer(Model model) {
		
		List<Map<String, String>> boardList = boardService.nointerList();
		model.addAttribute("boardList", boardList);
		
		System.out.println("~~~~~~~~~ boardList : " + boardList);
		
		return "board/nointer";
	}
	
}
