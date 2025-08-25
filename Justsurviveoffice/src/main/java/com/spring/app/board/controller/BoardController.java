package com.spring.app.board.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.context.annotation.RequestScope;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.support.RequestContextUtils;

import com.spring.app.board.service.BoardService;
import com.spring.app.users.domain.BoardDTO;
import com.spring.app.users.domain.UsersDTO;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import oracle.net.ano.Service;

@Controller
@RequestMapping("board/")
@RequiredArgsConstructor
public class BoardController {

	// === 생성자 주입(Constructor Injection) === //
	private final BoardService boardService;
	
	// === board 생성  === //
	@GetMapping("list")
	public String BoardList(HttpServletRequest request, 
						   HttpServletResponse response,
						   Model model,
						   @RequestParam(value="fk_categoryNo", required = false) String fk_categoryNo,
						   @RequestParam(name="searchType", defaultValue="") String searchType,
						   @RequestParam(name="searchWord", defaultValue="") String searchWord,
						   @RequestParam(name="currentShowPageNo", defaultValue="1") String currentShowPageNo){

		List<Map<String, String>> mapList = boardService.BoardList(fk_categoryNo);
		model.addAttribute("mapList",mapList);
		model.addAttribute("fk_categoryNo", fk_categoryNo);
		System.out.println("fk_categoryNo는 " +  fk_categoryNo);
		
		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("searchType",searchType);
		paraMap.put("searchWord",searchWord);
		

		return "board/list";
	}
	
	@RequestMapping("view")
	public ModelAndView BoardDetail(HttpServletRequest request, 
							  		HttpServletResponse response,
							  		ModelAndView mav){
		
		// 2508 KYJ inputFlashMap 쓰는 이유는 주소창이 파라미터에 남는걸 숨기기위해서 사용
		Map<String, ?> inputFlashMap = RequestContextUtils.getInputFlashMap(request);
		
		HttpSession session = request.getSession();
		UsersDTO loginUser = (UsersDTO) session.getAttribute("loginUser");
		String login_userid = null ;
		if (loginUser != null) {
			login_userid += loginUser.getId();
		}
		
		String boardNo = request.getParameter("boardNo");

		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("boardNo", boardNo);
		paraMap.put("login_userid", login_userid);
		
		
		// paraMap.put("",);
	 	
		//  ==== !!! 중요 !!! ==== 
		//  글1개를 보여주는 페이지 요청은 select 와 함께 
		//  DML문(지금은 글조회수 증가인 update문)이 포함되어져 있다.
		//  이럴경우 웹브라우저에서 페이지 새로고침(F5)을 했을때 DML문이 실행되어
		//  매번 글조회수 증가가 발생한다.
		//  그래서 우리는 웹브라우저에서 페이지 새로고침(F5)을 했을때는
		//  단순히 select만 해주고 DML문(지금은 글조회수 증가인 update문)은 
		//  실행하지 않도록 해주어야 한다. !!! === //
		
		BoardDTO boardDTO = null;
		
		boardDTO = boardService.getView(paraMap);
		mav.addObject(boardDTO);
		mav.addObject(paraMap);
		System.out.println("테스트 번호 : " + boardDTO.getPreNo());
		System.out.println("날짜 가져오기: " + boardDTO.getCreatedAtBoard());
		if(boardDTO.getPreNo() == null ) {
			boardDTO.setPreNo("0");
		}
		else if(boardDTO.getNextNo() == null ) {
			boardDTO.setNextNo("0");
		}
		
		mav.setViewName("board/view");
		
		return mav;
	}
}
