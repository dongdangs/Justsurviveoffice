package com.spring.app.board.controller;

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
	public ModelAndView boardList(@RequestParam(name="categoryNo") String categoryNo,
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
		
		boardList = boardService.boardList(categoryNo);
		
		mav.addObject("boardList", boardList);
		mav.addObject("categoryNo", categoryNo);
		
		mav.setViewName("board/boardList");
		
		return mav;
	}
	
	
	// 글 상세 보기
	@RequestMapping("boardDetail")
	public ModelAndView boardDetail(@RequestParam(name="boardNo") String boardNo,
									@RequestParam(name="categoryNo") String categoryNo,
							  		HttpServletRequest request, ModelAndView mav) {
		
		HttpSession session = request.getSession();
		UsersDTO loginUser = (UsersDTO) session.getAttribute("loginUser");
		
		String loginUserId = null;
		if(loginUser != null) {
			loginUserId = loginUser.getId();
		}
		
		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("boardNo", boardNo);
		paraMap.put("categoryNo", categoryNo);
		paraMap.put("loginUserId", loginUserId);
		
		BoardDTO boardDto = null;
		
		// 새로고침 여부 체크
		if("yes".equals(session.getAttribute("readCount"))) {
			// 글 목록에서 상세 조회를 클릭한 경우
			boardDto = boardService.getboardDetail(paraMap); // 조회수 증가
			session.removeAttribute("readCount"); 			 // 세션 값 삭제
		}
		else {
			// 새로고침을 한 경우 조회수 증가 없이 상세조회
			boardDto = boardService.getboardDetailNoIncrease(paraMap);
		}
		
		// 이전글제목보기, 다음글제목 보기를 위한 파라미터 추가
		mav.addObject("boardDto", boardDto);
		mav.addObject("paraMap", paraMap);
		mav.setViewName("board/boardDetail");
		
		return mav;
	}
	
	
	// 글쓰기 페이지
	@GetMapping("writeForm")
	public String writeForm(HttpSession session) {
		
		UsersDTO loginUser = (UsersDTO) session.getAttribute("loginUser");
		
		if(loginUser == null) {
			return "redirect:/login/loginForm";
		}
		
		return "board/write";
	}
	
	
	// 댓글 목록
	@GetMapping("commentRead")
	@ResponseBody
	public String commentRead(@RequestParam Map<String, String> paraMap) {
		
		List<CommentDTO> commentList = boardService.getCommentList(paraMap.get("boardNo"));
		
		JSONArray jsonArr = new JSONArray();
		
		if(commentList != null) {
			for(CommentDTO cmtdto : commentList) {
				
				JSONObject jsonObj = new JSONObject();
				jsonObj.put("commentNo", cmtdto.getCommentNo());
				jsonObj.put("fk_id", cmtdto.getFk_id());
				jsonObj.put("fk_name", cmtdto.getFk_name());
				jsonObj.put("content", cmtdto.getContent());
				jsonObj.put("createdAtComment", cmtdto.getCreatedAtComment());
				jsonObj.put("updateAtComment", cmtdto.getUpdateAtComment());
				jsonObj.put("fk_boardNo", cmtdto.getFk_boardNo());
				jsonObj.put("parentNo", cmtdto.getParentNo());
				
				jsonArr.put(jsonObj);
			}
		}
		
		return jsonArr.toString();		
	}
	
	
	// 댓글 쓰기
	@PostMapping("commentWrite")
	@ResponseBody
	public Map<String, Object> commentWrite(CommentDTO commentDto) {
		
		int n = 0;
		
		try {
			n = boardService.commentWrite(commentDto);
			// 댓글쓰기(insert) 쓰기 
		    // 이어서 회원의 포인트를 50점을 증가하도록 한다. 
		} catch (Throwable e) {
			e.printStackTrace();
		}
		
		Map<String, Object> map = new HashMap<>();
		map.put("name", commentDto.getFk_name());
		map.put("n", n);
		
		return map;
	}
	
	/////////////////////////////////////////////////////////////////////////////
	
	// Hot 게시글 전체 리스트 (조회수 많은 순)
	@GetMapping("hot/all")
	public ModelAndView hotAll(ModelAndView mav) {
		
		List<BoardDTO> hotAllList = boardService.hotAll();
		
		mav.addObject("boardList", hotAllList);
		mav.setViewName("board/boardList");
		
		return mav;
	}
	
	
	
	
	
}


