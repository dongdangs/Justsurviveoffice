package com.spring.app.board.controller;

import java.io.File;
import java.io.InputStream;
import java.io.PrintWriter;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.spring.app.board.domain.BoardDTO;
import com.spring.app.board.service.BoardService;
import com.spring.app.bookmark.service.BookmarkService;
import com.spring.app.common.FileManager;
import com.spring.app.config.Datasource_final_orauser_Configuration;
import com.spring.app.model.HistoryRepository;
import com.spring.app.users.domain.CommentDTO;
import com.spring.app.users.domain.UsersDTO;
import com.spring.app.users.service.UsersService;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/board/")
@RequiredArgsConstructor
public class BoardController {

    private final Datasource_final_orauser_Configuration datasource_final_orauser_Configuration;

    private final HistoryRepository historyRepository;

	// === 생성자 주입(Constructor Injection) === //
	private final UsersService usersService;
	private final BoardService boardService;
	private final BookmarkService bookmarkService;
	
	private final FileManager fileManager;
	
 // 2번. 스마트 에디터로 모든 파일 텍스트 업로드해보기
	// ==== #스마트에디터. 드래그앤드롭을 사용한 다중사진 파일업로드 ====
	@PostMapping("image/multiplePhotoUpload")
	public void multiplePhotoUpload(HttpServletRequest request, 
									HttpServletResponse response) {
		/*
		   1. 사용자가 보낸 파일을 WAS(톰캣)의 특정 폴더에 저장해주어야 한다.
		   >>>> 파일이 업로드 되어질 특정 경로(폴더)지정해주기
		        우리는 WAS 의 webapp/resources/photo_upload 라는 폴더로 지정해준다.
		*/
		// WAS 의 webapp 의 절대경로를 알아와야 한다.
		HttpSession session = request.getSession();
		String root = session.getServletContext().getRealPath("/");
		String path = root + "resources"+File.separator+"photo_upload";
		// path 가 첨부파일들을 저장할 WAS(톰캣)의 폴더가 된다.
			
		System.out.println("~~~ 확인용 path => " + path);
		//  /Users/dong/git/Justsurviveoffice/Justsurviveoffice/src/main/webapp/resources/photo_upload
		
		File dir = new File(path);
		if(!dir.exists()) {
			dir.mkdirs();
		}
		try {
			String filename = request.getHeader("file-name"); // 파일명(문자열)을 받는다 - 일반 원본파일명
			// 네이버 스마트에디터를 사용한 파일업로드시 싱글파일업로드와는 다르게 멀티파일업로드는 파일명이 header 속에 담겨져 넘어오게 되어있다. 
			/*  [참고]
			    HttpServletRequest의 getHeader() 메소드를 통해 클라이언트 사용자의 정보를 알아올 수 있다. 
		
				request.getHeader("Referer");           // 접속 경로(이전 URL)
				request.getHeader("user-agent");        // 클라이언트 사용자의 시스템 정보
				request.getHeader("User-Agent");        // 클라이언트 브라우저 정보 
				request.getHeader("X-Forwarded-For");   // 클라이언트 ip 주소 
				request.getHeader("host");              // Host 네임  예: 로컬 환경일 경우 ==> localhost:9090    
			*/
		//	System.out.println(">>> 확인용 filename ==> " + filename);
			// >>> 확인용 filename ==> berkelekle%EB%8B%A8%EA%B0%80%EB%9D%BC%ED%8F%AC%EC%9D%B8%ED%8A%B803.jpg 
			InputStream is = request.getInputStream(); // is는 네이버 스마트 에디터를 사용하여 사진첨부하기 된 이미지 파일임.
			String newFilename = fileManager.doFileUpload(is, filename, path);
			String ctxPath = request.getContextPath(); //  /myspring
			String strURL = "";
			strURL += "&bNewLine=true&sFileName="+newFilename; 
			strURL += "&sFileURL="+ctxPath+"/resources/photo_upload/"+newFilename;
			
			// === 웹브라우저 상에 사진 이미지를 쓰기 === //
			PrintWriter out = response.getWriter();
			out.print(strURL);
			
		} catch(Exception e) {
			e.printStackTrace();
		}
	}
// ==================================================================== //
		

	
	@GetMapping("write/{category}") // RestAPI
	public ModelAndView writeBoard(@PathVariable("category") String category,
								   ModelAndView modelview) {
		modelview.addObject("category", category); // 카테고리 번호가 게시판마다 따라가야함!
		modelview.setViewName("board/write");
		return modelview;
	}
	
	// 게시글 업로드 메소드
	@PostMapping("write")
	public ModelAndView saveBoard(ModelAndView modelview,
								  Map<String, String> paraMap,
								  BoardDTO boardDto,
								  HttpServletRequest request,
								  HttpSession session) {
		UsersDTO loginUser = (UsersDTO) session.getAttribute("loginUser");
		
		MultipartFile attach = boardDto.getAttach();
	// 1번. 일반 파일 업로드 해보기.	
/*  	주요 메소드:	getOriginalFilename() → 원본 파일명
					getSize() → 파일 크기
					getBytes() → 파일 내용을 바이트 배열로
					transferTo(File dest) → 실제 서버에 저장 */
		// 파일이 있는 경우 해당 파일을 저장해줄 부분.
		if(attach != null && !attach.isEmpty()) { 
			session = request.getSession(); // WAS(톰캣)의 절대경로 알아오기.
			String root = session.getServletContext().getRealPath("/");
			String path = root+"resources"+File.separator+"files";
//			System.out.println(path);
// /Users/dong/git/Justsurviveoffice/Justsurviveoffice/src/main/webapp/resources/files
			String boardFileName = ""; //WAS(톰캣)의 디스크에 저장될 파일명
			
			byte[] bytes = null; // 첨부파일의 내용물을 담는 예정.

			try {//boardFileName
				bytes = attach.getBytes(); //첨부파일의 내용물을 읽기.
				String boardFileOriginName = attach.getOriginalFilename();
				
				boardFileName = fileManager // 첨부되어진 파일은 고유이름으로 업로드
							.doFileUpload(bytes, boardFileOriginName, path);
				//20250826172844_a2b5f4b0cc9d46e99976ca3901bc555d.png
				System.out.println(boardFileName);
				boardDto.setBoardFileName(boardFileName);
				boardDto.setBoardFileOriginName(boardFileOriginName);
				// 게시물에서 첨부된 파일을 보여줄 때 기존명 노출.
				// 사용자가 파일을 다운로드 할 때도 기존명 노출.
				// 하지만 WAS에는 고유 파일 이름으로 저장해놔야만 선택 및 삭제 시 오류가 나지 않음.
				// 찾을 때도 고유 파일 이름(newFileName == boardFileName)
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		int n = boardService.insertBoard(boardDto); // 게시판에 업로드!
		
		if(n==1) {
			modelview.setViewName("redirect:list/"+boardDto.getFk_categoryNo());
		}
		else {
			modelview.addObject("message", "오류: 현재 게시물 업로드가 불가능합니다.");
			modelview.addObject("loc", "javascript:history.back()");
			modelview.setViewName("msg");
		}
		try {
			paraMap.put("id", boardDto.getFk_id());
			paraMap.put("point", "1000");
			
			// paraMap에 저장한 해쉬맵정보는, users용이기 때문에... 레포지토리로 보내야함.
			usersService.getPoint(paraMap); // 게시물 업로드는 1000 point
			
			loginUser.setPoint(loginUser.getPoint()+1000);
			session.setAttribute("loginUser", loginUser);
			
			System.out.println(loginUser.getPoint());
		} catch (Exception e) {
			System.err.println("point업데이트 오류가 발생하였습니다");
		}
		
		return modelview;
	}
	
	
	  
 // 각 카테고리 게시판에 들어가기!
	//또는 전체 게시물 검색!
	@GetMapping("list/{category}") // RestAPI
	public ModelAndView list(ModelAndView modelview, 
							 HttpServletRequest request,
							 HttpServletResponse response,
	 @RequestParam(name="searchType", defaultValue="") String searchType,
	 @RequestParam(name="searchWord", defaultValue="") String searchWord, 
	 @RequestParam(name="currentShowPageNo", defaultValue="1") String currentShowPageNo,
	 @PathVariable("category") String category) {
 // http://localhost:9089/justsurviveoffice/board/list/1
		List<BoardDTO> boardList = null;
		
		// 추후 referer 는 spring security의 토큰 검사로 변경.
		String referer = request.getHeader("Referer");
		if(referer == null) { // url타고 get방식으로 접근 불가능하도록!
			modelview.setViewName("redirect:/index");
			return modelview;
		}

		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("searchType", searchType);
		paraMap.put("searchWord", searchWord);
		paraMap.put("category", category);
		// 페이지를 옮겼거나, 검색 목록이 있다면 저장.
		
		int totalCount = 0;    // 총 게시물 건수
		int sizePerPage = 10;  // 한 페이지당 보여줄 게시물 건수
		int totalPage = 0;     // 총 페이지수(웹브라우저상에서 보여줄 총 페이지 개수, 페이지바)
		totalPage = (int) Math.ceil((double)totalCount/sizePerPage);

		boardList = boardService.boardList(paraMap);
		
		HttpSession session = request.getSession();
		UsersDTO loginUser = (UsersDTO) session.getAttribute("loginUser");
		// 로그인 된 유저가 있다면, 게시물 별 bookmarked 를 체크해야함.
		if(loginUser != null) {
			for(BoardDTO boardDto : boardList) {
				boardDto.setBookmarked(bookmarkService.isBookmarked(
														loginUser.getId(), 
														boardDto.getBoardNo())); 
			}
		}
		// System.out.println(category);
		modelview.addObject("boardList", boardList);
		modelview.addObject("searchType", searchType);
		modelview.addObject("searchWord", searchWord);
		modelview.addObject("category", category);
		
		modelview.setViewName("board/list");
		
		return modelview;
	}
	
	
	// 조회수 증가 및 페이징 기법이 포함된 게시물 상세보기 메소드
	@RequestMapping("view") //post,get 둘 다 받아올 것!
	public ModelAndView view(ModelAndView modelview,
							 HttpServletRequest request,
							 HttpServletResponse response,
			 @RequestParam(name="searchType", defaultValue="") String searchType,
			 @RequestParam(name="searchWord", defaultValue="") String searchWord, 
			 @RequestParam(name="currentShowPageNo", defaultValue="1") String currentShowPageNo,
			 @RequestParam(name="category", defaultValue="") String category,
			 				 BoardDTO boardDto) {

		// 추후 referer 는 spring security의 토큰 검사로 변경.
		String referer = request.getHeader("Referer");
		if(referer == null) { // url타고 get방식으로 접근 불가능하도록!
			modelview.setViewName("redirect:/index");
			return modelview;
		}
		
		Map<String, String> paraMap = new HashMap<>();
		
		paraMap.put("searchType", searchType); 
		paraMap.put("searchWord", searchWord);
		paraMap.put("currentShowPageNo", searchType);
		
		boardDto = boardService.selectView(boardDto.getBoardNo());
		
		if(boardDto != null) { // 뒤로가기 혹은 오류가 없는 정상 게시물인 경우 이동.
			System.out.println(boardDto.getBoardNo());
			System.out.println(boardDto.getFk_categoryNo());
		// 명심할 점!, 1. 완벽한 조회수 알고리즘은 존재하지 않는다.
		//   2. 방법은 쿠키, 세션, (실무)DB로그, (실무)Redis 가 있다.
		//	 3. 나는 내가 내가 배운 지식을 재활용하기 위해 세션방식을 해본 후, 쿠키방식을 선택했다..
		//   4. 세션방식의 단점(세션이 만료되거나 로그아웃 시에는 소용이 없다 + 세션리미트는 하나로 통일됌)을 이해하고 구현한다.
		//   5. 쿠키방식의 단점(로컬스토리지의 삭제 및 쿠키 조작이 너무 쉽기에 조회수 조작이 더욱 쉬워진다)을 이해하고 구현한다.
			
		//		접속한 아이피 + 게시물번호가 세션 or 쿠키에 없다면?
		//		 >> 아이피 + 게시물번호의 수명을 30분으로 줌, 
		//	  + loginUser.id 와 fk_id가 같아도 >> 조회수는 증가 안함.
			HttpSession session = request.getSession();
			
			UsersDTO loginUser = (UsersDTO) session.getAttribute("loginUser");
			// 유저가 존재하고 그 유저의 id가 같은지 확인!
			if( loginUser == null ? true : // 로그인된 유저이면서, 아이디도 다른 경우!
				!loginUser.getId().equals(boardDto.getFk_id()) ? true : false ) 
						/* 로그인된 유저면 아이디비교 */	 			{ 
				
				String clientIP = request.getRemoteAddr(); 
				// 우리가 배웠던 AWS 로드밸런서 ip 가져오기.
 
				String boardNo_ip =  clientIP.replaceAll(":","").hashCode()
									 + "_" + boardDto.getBoardNo();
				// 0:0:0:0:0:0:0:1_106 를 hashCode화 하기위해 :를 삭제 후 ip만 암호화.
				// -1173940223_106
				
				// 방금 접근한 ip가 세션에 저장되어있지 않다면 조회수를 증가!
			/*	if(session.getAttribute(boardNo_ip) == null
					) {
					// 조회수 증가.
					int n = boardService.updateReadCount(boardDto.getBoardNo());
			//		if(n==1) System.out.println("조회수 증가 완료.");
					
					boardDto.setReadCount(boardDto.getReadCount() + 1);
					
					// 조회수 증가 후, 세션에 30분 조회수 증가 limit 를 부여할 것!
					session.setAttribute(boardNo_ip, System.currentTimeMillis());
					session.setMaxInactiveInterval(1*60); // 30분 limit 부여!
				} 
				else {
					long lastAccessTime = session.getLastAccessedTime();
					int maxInactive = session.getMaxInactiveInterval(); // 초 단위
					long currentTime = System.currentTimeMillis();

					// 남은 시간 계산 (밀리초)
					long remainingTime = (lastAccessTime + (maxInactive * 1000)) - currentTime;
					long remainingMinutes = remainingTime / (1000);
					System.out.println("세션 남은 시간: " + remainingMinutes + "초");
					if(remainingMinutes <= 0) {
						int n = boardService.updateReadCount(boardDto.getBoardNo());
			//			if(n==1) System.out.println("조회수 증가 완료.");  	   */
				
				Cookie[] cookies = request.getCookies();
				boolean isExist = false; // 쿠키에 해당 boardNO 별 ip가 존재하는지 확인
				
				for(Cookie c : cookies) { // 쿠키의 접근은 세션과 다르게 배열접근이 기본!
					if(c.getName().equals(boardNo_ip)) {
						isExist = true; break;// 쿠키 수명 잔여 시 조회수 늘리기 종료
					}
				}
				
				if(!isExist) { // 수명이 다했거나 접근이 기록이 없었다면 조회수 증가
					int n = boardService.updateReadCount(boardDto.getBoardNo());
//					if(n==1) System.out.println("조회수 증가 완료.");
					boardDto.setReadCount(boardDto.getReadCount() + 1);
					
					Cookie setCookieLimit = new Cookie(boardNo_ip, "yes");
					setCookieLimit.setMaxAge(1*60); // 1분
					setCookieLimit.setPath("/"); // 쿠키가 지정 경로에서만 전송된다는 것!(보안)
					response.addCookie(setCookieLimit);
					// jakarta.servlet.http.Cookie@5f3fcbef{-1173940223_108=yes,{Max-Age=60, Path=/}}
				}
				
			} // 로그인된 유저가 자신의 게시물에 들어갔다면 if문 생략
			
			
			/* null 일시 0값 부여서해서 view.jsp 로 0 값을 보냄 (김예준)*/
			if(boardDto.getPreNo() == null ) {
				boardDto.setPreNo("0");
			}
			else if(boardDto.getNextNo() == null ) {
				boardDto.setNextNo("0");
			}
			
			modelview.addObject("hotReadList", boardService.getTopBoardsByViewCount());
	        modelview.addObject("hotCommentList", boardService.getTopBoardsByCommentCount());

			if(loginUser != null) {
				boardDto.setBookmarked(bookmarkService.isBookmarked(
						loginUser.getId(), 
						boardDto.getBoardNo())); 
				 // 좋아요 여부 
			    boolean isLiked = boardService.isBoardLiked(loginUser.getId(), boardDto.getBoardNo());
			    boardDto.setBoardLiked(isLiked);
			    
			    System.out.println("=== 좋아요 여부: " + isLiked);
			}
			// 좋아요 개수 추가
	        int likeCount = boardService.getBoardLikeCount(boardDto.getBoardNo());
	        modelview.addObject("likeCount", likeCount);
			// 댓글 목록 조회
	        List<CommentDTO> commentList = boardService.getCommentList(boardDto.getBoardNo());
	        modelview.addObject("commentList", commentList);
			modelview.addObject("boardDto", boardDto);
			
			modelview.setViewName("board/view");
			return modelview;
		}
		else { // 뒤로가기 혹은 오류로 인한 삭제게시물을 클릭한 경우.
			modelview.addObject("message", "현재 존재하지 않는 게시물입니다.");
			modelview.addObject("loc", "list/"+category); // category = fk_categoryNo
			modelview.setViewName("msg"); 
			
			return modelview;
		}
	}
	
	// 게시물 삭제하기 == boardDeleted = 0 으로 전환하기 == update
	@PostMapping("delete")
	public ModelAndView delete(ModelAndView modelview,
							   BoardDTO boardDto,
							   HttpSession session) {

		UsersDTO loginUser = (UsersDTO) session.getAttribute("loginUser");
		// 로그인된 유저의 id와 전송받은 id가 일치하다면
		if(loginUser.getId().equals(boardDto.getFk_id())) {
		// 해당 게시물 boardDeleted = 0 으로 전환.
			int n = boardService.deleteBoard(boardDto.getBoardNo());
			
			if(n==1) { 
				modelview.addObject("message", "글이 삭제되었습니다.");
				modelview.addObject("loc", "list/"+boardDto.getFk_categoryNo());
				modelview.setViewName("msg");
			}
			else {
				modelview.addObject("message", "이미 삭제된 게시물입니다.");
				modelview.addObject("loc", "list/"+boardDto.getFk_categoryNo());
				modelview.setViewName("msg");
			}
		}
		else {
			modelview.addObject("message", "접근 불가능한 경로입니다.");
			modelview.addObject("loc", "javascript:history.back()");
			modelview.setViewName("msg");

		}
		return modelview;
	}
	
	// 게시물 수정하기.
	@GetMapping("edit")
	public ModelAndView editBoard(HttpServletRequest request,
							 HttpServletResponse response,
							 ModelAndView modelview,
							 BoardDTO boardDto) {
					   	  // boardNo, fk_id, fk_category
		String referer = request.getHeader("Referer");
		if(referer == null) {	// URL로 타고 들어오지 못하도록 1차 보안.
			modelview.setViewName("redirect:/index");
			return modelview;
		}
		HttpSession session = request.getSession();
		UsersDTO loginUser = (UsersDTO) session.getAttribute("loginUser");
		// 자신의 게시물이 아닌 게시물을 수정하지 못하도록 2차 보안.
		if(boardDto.getFk_id().equals(loginUser.getId())) { 
			boardDto = boardService.selectView(boardDto.getBoardNo());

			modelview.addObject("boardDto", boardDto); // boardDto를 넘겨주고 모두 보여주자!
			modelview.setViewName("board/edit");
			
		}
		else {
			modelview.addObject("message", "본인 게시물에만 접근 가능합니다.");
			modelview.addObject("loc", "javascript:history.back()");
			modelview.setViewName("msg");
		}
		return modelview;
	}
	// 게시물 수정하기, 수정시 기존 파일은 삭제!
	@PostMapping("edit")
	public ModelAndView updateBoard(ModelAndView modelview,
								  Map<String, String> paraMap,
								  BoardDTO boardDto,
								  HttpServletRequest request,
								  HttpSession session) {
		UsersDTO loginUser = (UsersDTO) session.getAttribute("loginUser");
		
		MultipartFile attach = boardDto.getAttach();
	// 1번. 일반 파일 업로드 해보기.	
/*  	주요 메소드:	getOriginalFilename() → 원본 파일명
					getSize() → 파일 크기
					getBytes() → 파일 내용을 바이트 배열로
					transferTo(File dest) → 실제 서버에 저장 */
		// 파일이 있는 경우 해당 파일을 저장해줄 부분.
		if(attach != null && !attach.isEmpty()) { 
			session = request.getSession(); // WAS(톰캣)의 절대경로 알아오기.
			String root = session.getServletContext().getRealPath("/");
			String path = root+"resources"+File.separator+"files";
//				System.out.println(path);
// /Users/dong/git/Justsurviveoffice/Justsurviveoffice/src/main/webapp/resources/files
			String boardFileName = ""; //WAS(톰캣)의 디스크에 저장될 파일명
			
			byte[] bytes = null; // 첨부파일의 내용물을 담는 예정.

			try {//boardFileName
				bytes = attach.getBytes(); //첨부파일의 내용물을 읽기.
				String boardFileOriginName = attach.getOriginalFilename();
				
				boardFileName = fileManager // 첨부되어진 파일은 고유이름으로 업로드
							.doFileUpload(bytes, boardFileOriginName, path);
				//20250826172844_a2b5f4b0cc9d46e99976ca3901bc555d.png
				System.out.println(boardFileName);
				boardDto.setBoardFileName(boardFileName);
				boardDto.setBoardFileOriginName(boardFileOriginName);
				// 게시물에서 첨부된 파일을 보여줄 때 기존명 노출.
				// 사용자가 파일을 다운로드 할 때도 기존명 노출.
				// 하지만 WAS에는 고유 파일 이름으로 저장해놔야만 선택 및 삭제 시 오류가 나지 않음.
				// 찾을 때도 고유 파일 이름(newFileName == boardFileName)
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		int n = boardService.updateBoard(boardDto); // 게시판에 수정본 업로드!
		
		if(n==1) {
			modelview.setViewName("redirect:list/"+boardDto.getFk_categoryNo());
		}
		else {
			modelview.addObject("message", "오류: 현재 게시물 수정이 불가능합니다.");
			modelview.addObject("loc", "javascript:history.back()");
			modelview.setViewName("msg");
		}
		
		return modelview;
	}
	
	// 첨부파일 다운받기!
	@PostMapping("download")
    public void download(HttpServletRequest request,  
		   				HttpServletResponse response,
		   				@RequestParam(name="boardFileName") String boardFileName,
		   				@RequestParam(name="boardFileOriginName") String boardFileOriginName) {
      
      // HttpServletResponse response -> 서버가 클라이언트(웹브라우저)로 보내는 응답 객체
      response.setContentType("text/html; charset=UTF-8");   // 브라우저가 응답을 HTML로 이해하도록 미리 Content-Type을 "text/html; charset=UTF-8"로 지정
      // 즉, 이 줄은 "파일다운로드 실패 시, JS alert를 HTML로 제대로 해석시키려고" 넣은 것
      
      // 응답 객체에서 **텍스트(문자)**를 직접 브라우저로 내보내려면 response.getWriter()를 호출 이게 PrintWriter(타입)으로 반환
      // PrintWriter → 문자 스트림을 응답(HttpServletResponse)에 쓰는 객체
      PrintWriter out = null;   // 선언해주고!
      
      try {
         // DTO 에 데이터가 있는지 체크! 및 파일이 들어있는지 체크!
         if(boardFileOriginName == null) {
            out = response.getWriter();
            // out 은 웹브라우저에 기술하는 대상체라고 생각하자.(PrintWriter)
            
            // 파일이 없다면 해당 메시지 출력되게 한다.
            out.println("<script type='text/javascript'>alert('파일다운로드가 불가합니다.'); history.back();</script>");
            return;
         }
         else {
            // 정상적으로 다운로드가 되어질 경우!
            // 이것이 20250725123358_a4fc4b64d9dc480e871875bd3db1fe27.pdf 와 같은
            // 바로 WAS 디스크에 저장된 파일명이다.
            // Electrolux냉장고_사용설명서.pdf
            // 다운로드시 보여줄 파일명
            /*
               첨부파일이 저장되어있는 WAS(톰캣) 디스크 경로명을 알아와야만 다운로드를 해줄 수 있다.
               이 경로는 우리가 파일첨부를 위해서 @PostMapping("add") 에서 설정해두었던 경로와 똑같아야 한다.    
            */
            // WAS 의 webapp 의 절대경로를 알아와야 한다.
            HttpSession session = request.getSession();
            String root = session.getServletContext().getRealPath("/");
            
         //   System.out.println("~~~ 확인용 webapp 의 절대경로 ==> " + root);
            // ~~~ 확인용 webapp 의 절대경로 ==> C:\git\Justsurviveoffice\src\main\webapp\
            
            String path = root + "resources" + File.separator + "files";
            /* File.separator 는 운영체제에서 사용하는 폴더와 파일의 구분자이다.
               운영체제가 Windows 이라면 File.separator 는  "\" 이고,
               운영체제가 UNIX, Linux, 매킨토시(맥) 이라면  File.separator 는 "/" 이다. 
            */
            // path 가 첨부파일이 저장될 WAS(톰캣)의 폴더가 된다.
            // System.out.println("~~~ 확인용 path ==> " + path);
            // ~~~ 확인용 path ==> C:\NCS\workspace_spring_boot_17\myspring\src\main\webapp\resources\files
            
            // **** file 다운로드하기 **** //
            boolean flag = false; // file 다운로드 성공, 실패인지 여부를 알려주는 용도
            flag = fileManager.doFileDownload(boardFileName, boardFileOriginName, path, response);
            // file 다운로드 성공시 flag 는 true,
            // file 다운로드 실패시 flag 는 false 를 가진다.
            if(!flag) {
               // 다운로드가 실패한 경우 메시지를 띄운다.
               out = response.getWriter();
               // out 은 웹브라우저에 기술하는 대상체라고 생각하자.
               out.println("<script type='text/javascript'>alert('파일다운로드가 실패되었습니다.'); history.back();</script>");
            }
         }
      } catch(Exception e) {
         
         try {
            out = response.getWriter();
            // out 은 웹브라우저에 기술하는 대상체라고 생각하자.
            
            out.println("<script type='text/javascript'>alert('파일다운로드가 불가합니다.'); history.back();</script>");
         } catch(Exception e1) {
            e.printStackTrace();
         }
      }
      
   }
	
	
	//////////////////////////////////////////////////////////////////////
	// Hot 게시글 전체 리스트 (조회수 많은 순)
	@GetMapping("hot/all")
	public ModelAndView hotAll(ModelAndView modelview) {
		
		List<BoardDTO> hotAllList = boardService.hotAll();
		
		modelview.addObject("boardList", hotAllList);
		modelview.setViewName("board/boardList");
		
		return modelview;
	}
	//////////////////////////////////////////////////////////////////////
	
	

	// 게시글 좋아요
    @PostMapping("boardlike")
    @ResponseBody
    public Map<String, Object> boardLike(@RequestParam(name="fk_boardNo") Long fk_boardNo, HttpSession session) {
       
    	Map<String, Object> result = new HashMap<>();

        UsersDTO loginUser = (UsersDTO) session.getAttribute("loginUser");
        System.out.println("===> loginUser: " + loginUser);
        
        if (loginUser == null) {
            result.put("success", false);
            result.put("message", "로그인이 필요합니다.");
            return result;
        }
        
        String fk_id = loginUser.getId();
        System.out.println("===> fk_id: " + fk_id);

        boolean isLiked = boardService.isBoardLiked(fk_id, fk_boardNo);
        
        if(isLiked == true) {
        	boardService.deleteBoardLike(fk_id,fk_boardNo);
        	result.put("status", "unliked");
        } 
        else {
        	boardService.insertBoardLike(fk_id,fk_boardNo);
        	result.put("status", "liked");
        }
        
        // 현재 게시글의 좋아요 수
        int likeCount = boardService.getBoardLikeCount(fk_boardNo);
        
        boolean newStatus = boardService.isBoardLiked(fk_id, fk_boardNo); // 최신 상태 재조회

        result.put("success", true);
        result.put("likeCount", likeCount);
        
        return result;
    }
	
    
	
}