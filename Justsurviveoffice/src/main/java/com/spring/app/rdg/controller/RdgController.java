package com.spring.app.rdg.controller;

import java.io.File;
import java.io.PrintWriter;
import java.io.InputStream;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.spring.app.common.FileManager;
import com.spring.app.rdg.service.RdgService;
import com.spring.app.users.domain.BoardDTO;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor  // @RequiredArgsConstructor는 Lombok 라이브러리에서 제공하는 애너테이션으로, final 필드 또는 @NonNull이 붙은 필드에 대해 생성자를 자동으로 생성해준다.
@RequestMapping("rdgAPI/")
public class RdgController {	// http://localhost:9089/justsurviveoffice/rdgAPI/
	
	// 의존객체를 생성자 주입(DI : Dependency Injection)
	private final RdgService service;
	
	private final FileManager fileManager;
	
	// ==== #스마트에디터. 드래그앤드롭을 사용한 다중사진 파일업로드 ====
	@PostMapping("image/multiplePhotoUpload")
	public void multiplePhotoUpload(HttpServletRequest request, HttpServletResponse response) {
		
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
		//  ~~~ 확인용 path => C:\NCS\workspace_spring_boot\.metadata\.plugins\org.eclipse.wst.server.core\tmp0\wtpwebapps\board\resources\photo_upload
		
		File dir = new File(path);
		if(!dir.exists()) {
			dir.mkdirs();
		}
		
		try {
			String filename = request.getHeader("file-name"); // 파일명(문자열)을 받는다 - 일반 원본파일명
			// 네이버 스마트에디터를 사용한 파일업로드시 싱글파일업로드와는 다르게 멀티파일업로드는 파일명이 header 속에 담겨져 넘어오게 되어있다. 
			
			/*
			    [참고]
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
	
	// Controller 에서는 웹이동 or 데이터 전달 용도로 코드 구현해보기
	
	// 꼰대존 게시글 목록 보기
	@GetMapping("rdglist")
	public String rdglist(@RequestParam(name = "searchType", defaultValue = "") String searchType,
						  @RequestParam(name = "searchWord", defaultValue = "") String searchWord,
						  @RequestParam(name="currentShowPageNo", defaultValue="1") String currentShowPageNo,
						  Model model) {
		
		// 일단 필요한 것
		/*
			1. 검색창이랑 연동된 페이징 처리를 한 글목록 보여주기 >> 해당 글목록(BoardDto), 검색칸, 검색어내용, 해당 페이지번호 만 넘겨주면 jsp에서 따로 코드 짜면됨
			2. 서비스구조체에서 키워드 보드제목 or 내용 가져와서 전처리 해주는 코드 작성해 키워드 정리해주고 다시 controller로 보내기(메소드 작성했을테니 리스트 저장 혹은 배열저장) >> jsp로 데이터만 전송
		*/
		// 1번부터 구현 해보기
		
		// 서비스에 넘길 데이터
		String fk_categoryNo = "2";	// 임시로 값 고정시킨 카테고리 번호 나중에 URL에서 직접 받아오는 식으로 수정
		
		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("searchType", searchType);
		paraMap.put("searchWord", searchWord);
		paraMap.put("currentShowPageNo", currentShowPageNo);
		paraMap.put("fk_categoryNo", fk_categoryNo);
		
		// 서비스에서 데이터 가공 및 DB 연동을 통해서 페이징 처리한 리스트 가져오기
		List<BoardDTO> boardDtoList = service.getBoardList(paraMap);
		
		// 해당 카테고리 게시글의 총 개수를 알아야 하므로
		int totalCount = service.getBoardCount(fk_categoryNo);
		int totalPage = (int) Math.ceil((double)totalCount / 3);	// 몇 페이지 까지 있는지 계산
		
		model.addAttribute("boardDtoList", boardDtoList);
		model.addAttribute("totalCount", totalCount);
		model.addAttribute("totalPage", totalPage);
		model.addAttribute("searchType", searchType);
		model.addAttribute("searchWord", searchWord);
		int currentPage = Integer.parseInt(currentShowPageNo);
		model.addAttribute("currentShowPageNo", currentPage);
		// ======================== 1번 데이터 가져오기 일단 완료 =============================== // 
		
		
		// ======================== 2번 키워드 코드 짜보기 ============================ // 
		List<Map.Entry<String,Integer>> keyword_top = service.getKeyWord(fk_categoryNo);	// 서비스에서 구현
		
		model.addAttribute("keyword_top", keyword_top);
		
		return "rdgAPI/rdglist";
	}
	
	
	// 꼰대존 게시글 목록에서 글쓰기 클릭시 글쓰기 페이지 이동
	@GetMapping("addStart")
	public String addStart() {
		return "rdgAPI/add";
	}
	
	
	
	// 글쓰기 페이지에서 글쓰기 버튼 클릭시
	@PostMapping("add")
	public String add(BoardDTO boardDto, HttpServletRequest request) {
		
		// 1. 파일용 경로 알아오기
		HttpSession session = request.getSession();
		String root = session.getServletContext().getRealPath("/");
		
		// 저장 경로 설정하기
		// 운영체제마다 경로 체계(Windows = \, Linux = /)가 다름 >> File.separator를 사용해야 함
		String path = root + "resources" + File.separator + "files";
		/*	File.separator 는 운영체제에서 사용하는 폴더와 파일의 구분자이다.
			운영체제가 Windows 이라면 File.separator 는  "\" 이고,
			운영체제가 UNIX, Linux, 매킨토시(맥) 이라면  File.separator 는 "/" 이다. 
		*/
		// 즉, File.separator 는 경로 구분자를 자동으로 맞춰주는 것을 뜻한다.
		
		if(boardDto.getFk_categoryNo() == null) {
			boardDto.setFk_categoryNo(Long.parseLong("2"));
		}
		
		service.add(boardDto, path);	// 글쓰기 버튼 클릭 메소드
		return "redirect:rdglist";
	}
	
	
	
	
	
}
