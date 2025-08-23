package com.spring.app.board.controller;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.spring.app.board.service.BoardService;
import com.spring.app.common.FileManager;
import com.spring.app.users.domain.BoardDTO;
import com.spring.app.users.domain.CommentDTO;
import com.spring.app.users.domain.UsersDTO;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/board/")
@RequiredArgsConstructor
public class BoardController {

	// === 생성자 주입(Constructor Injection) === //
	private final BoardService boardService;
	private final FileManager fileManager;
	
	
	// 글 목록
	@GetMapping("boardList")
	public ModelAndView boardList(@RequestParam(name="categoryNo") int categoryNo,
								  @RequestParam(name="ShowPageNo", defaultValue="1") String ShowPageNo,
						  		  HttpServletRequest request, ModelAndView mav) {
		
		List<BoardDTO> boardList = null;
		
		// 웹브라우저에서 새로고침(F5)을 했을 경우에는 증가가 되지 않도록 해야 한다. 
		// 이것을 하기 위해서는 session 을 사용하여 처리하면 된다.
		HttpSession session = request.getSession();
		session.setAttribute("readCount", "yes");
		
		String referer = request.getHeader("Referer");
		if(referer == null) {
			mav.setViewName("redirect:/index");
			return mav;
		}
		
		boardList = boardService.pagingboardList(categoryNo);
		
		mav.addObject("boardList", boardList);
		mav.addObject("categoryNo", categoryNo);
		
		System.out.println("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ boardList size: " + (boardList == null ? "null" : boardList.size()));

		
		mav.setViewName("board/boardList");
		
		return mav;
	}
	
	
}
