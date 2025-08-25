package com.spring.app.index.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.spring.app.board.service.BoardService;
import com.spring.app.users.domain.BoardDTO;
import com.spring.app.users.domain.CategoryDTO;
import com.spring.app.users.service.UsersService;

import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor // final 인스턴스 생성자 처리해주기
@Controller
@RequestMapping("/")
public class IndexController {

	private final UsersService service;
	private final BoardService boardService;
	
	@GetMapping("")
	public String start() {
		return "redirect:/index";
	}

	@GetMapping("index")
	public String index(Model model) {
		
		// 카테고리 리스트
		List<CategoryDTO> categoryList = boardService.categoryList();
		model.addAttribute("categoryList", categoryList);
		
		// Hot 게시글 리스트 (조회수 많은 순)
		List<BoardDTO> hotReadList = boardService.getTopBoardsByViewCount();
		model.addAttribute("hotReadList", hotReadList);
		
		// 댓글 많은 게시글 리스트
		List<BoardDTO> hotCommentList = boardService.getTopBoardsByCommentCount();
		model.addAttribute("hotCommentList", hotCommentList);
		
		return "index";
	}
	
	@GetMapping("users/list")
	public String memberList() {
		return "users/list";
		//	/WEB-INF/views/users/list.jsp 파일을 만들어야 한다.
	}
	
	
}
