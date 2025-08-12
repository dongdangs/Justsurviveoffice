package com.spring.app.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.spring.app.service.BoardService;

import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/board/")
@RequiredArgsConstructor
public class BoardController {

	// === 생성자 주입(Constructor Injection) === //
	private final BoardService boardService;
	
	
	
}
