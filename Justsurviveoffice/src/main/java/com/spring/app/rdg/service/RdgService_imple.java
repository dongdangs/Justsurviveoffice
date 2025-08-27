package com.spring.app.rdg.service;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Element;
import org.jsoup.safety.Safelist;
import org.jsoup.select.Elements;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.spring.app.common.FileManager;
import com.spring.app.rdg.mapper.RdgMapper;
import com.spring.app.users.domain.BoardDTO;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor  // @RequiredArgsConstructor는 Lombok 라이브러리에서 제공하는 애너테이션으로, final 필드 또는 @NonNull이 붙은 필드에 대해 생성자를 자동으로 생성해준다.
public class RdgService_imple implements RdgService {
	
	// dao 대신 mapper 직행
	private final RdgMapper mapper;
	
	private final FileManager fileManager;	// 파일 관련 도움 받기 좋은 객체
	
	// 실제 로직 구현. (파일 저장, 트랜잭션, Mapper 호출 등)
	
	
	// 글쓰기 버튼 클릭 메소드
	@Override
	public void add(BoardDTO boardDto, String path) {
		
		MultipartFile attach = boardDto.getAttach();	
		// 사용자가 <input type="file" name="attach">로 올린 파일이, 컨트롤러 파라미터로 받은 BoardDTO의 attach 필드에 바인딩되어 있고, 그걸 꺼내는 코드
		
		// 웹 애플리케이션에서 사용자가 업로드한 파일은 브라우저에서 직접 DB로 들어가는 게 아니라 서버(WAS, 즉 톰캣 같은 컨테이너)가 먼저 받아야한다.
		// DB에는 파일 자체를 저장하지 않고 메타데이터만 저장
		// 실제 파일은 서버의 디스크 특정 폴더에 저장
		// 우리는 WAS 의 /Justsurviveoffice/src/main/webapp/resources/files 라는 폴더를 생성해서 여기로 업로드할 것!
		// 여기서 WAS 폴더 = 톰캣이 내 프로젝트를 배포해서 실행 중인 실제 폴더 경로
		
		// 1. 해당 경로(path)는 Controller 에서 알아와서 파라미터에 넣었음!
		File dir = new File(path);
		if(!dir.exists()) {
			dir.mkdirs();
		}
		
		// 2. 파일첨부를 위한 변수의 설정 및 값을 초기화 한 후 파일 올리기
		if (attach != null && !attach.isEmpty()) {
			String newFileName = "";
			// WAS(톰캣)의 디스크에 저장될 파일명
			
			byte[] bytes = null;
			// 첨부파일의 내용물을 담는 것
			
			try {
				// MultipartFile 은 스프링이 제공하는 인터페이스로, 업로드된 파일을 다룰 수 있게 해주는 객체
				bytes = attach.getBytes();// getBytes() 메서드를 호출하면 그 파일의 내용 전체를 byte[] (바이트 배열) 로 변환해서 꺼내줌.
				// 첨부파일의 내용물을 읽어오는 것
				/*
					📌 비유
					파일 = 편지봉투
					파일 이름(originalFilename) = 편지봉투 겉면에 적힌 제목
					getBytes() = 봉투를 뜯어서 안에 있는 편지 내용 전체를 바이트 단위로 꺼내는 것
				*/
				
				String originalFilename = attach.getOriginalFilename();
				// attach.getOriginalFilename() 이 첨부파일명의 파일명(예: 강아지.png) 이다. 
				
				newFileName = fileManager.doFileUpload(bytes, originalFilename, path);
				// 첨부되어진 파일을 업로드 하는 것이다.
				
				// === BoardDTO boardDto 에 fileName 값과 orgFilename 값과 fileSize 값을 넣어주기 === //
				boardDto.setBoardFileName(newFileName);
				// WAS에 disk 상에 저장된 파일명
				
				boardDto.setBoardFileOriginName(originalFilename);
				// 게시판 페이지에서 첨부된 파일(강아지.png)을 보여줄 때 사용.
				// 또한 사용자가 파일을 다운로드 할때 사용되어지는 파일명으로 사용.
				
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		mapper.add(boardDto);	// 매퍼로 보내주기(DB 작업하러감) 
	}
	
	
	// 카테고리별 페이징 처리된 검색된 리스트 목록 가져오기(페이지당 3개의 목록 고정)
	@Override
	public List<BoardDTO> getBoardList(Map<String, String> paraMap) {
		List<BoardDTO> boardDtoList = mapper.getBoardList(paraMap);
		
		// boardContent 에 스마트에디터로 글 작성할 경우 HTML 형식으로 저장되므로 해당 HTML 을 파싱하는 방법
		/*
			Jsoup이란?
			
			Java 기반 HTML 파서 라이브러리
			HTML 문자열을 DOM(Document Object Model) 구조로 바꿔서, 자바 코드에서 웹페이지처럼 다룰 수 있게 해줌.
			CSS 선택자(div > p, .class, #id)로 원하는 요소를 쉽게 뽑을 수 있음.
			태그 제거, 속성 추출, 텍스트 변환, XSS 방어(안전한 HTML 정화) 같은 작업에 특화.
			한마디로: "HTML = 문자열"을 "객체(트리 구조)"로 변환해서 편하게 다룰 수 있게 해주는 도구.
			
			사용 방법
			build.gradle 에
			dependencies {
				implementation 'org.jsoup:jsoup:1.18.1'
			} 추가해야 한다.
			
			관련 문법
			
			HTML → DOM(문서 객체) 변환
			Document doc = Jsoup.parse("<p>Hello <b>World</b></p>");
			
			doc.text()
			.text() = 태그 다 없애고 글자만 가져오기
			
			Element p = doc.selectFirst("p"); // 첫 번째 <p> 태그
			.select("CSS선택자") → 태그 여러 개 찾기
			.selectFirst("CSS선택자") → 첫 번째만 찾기
			.html() → 내부 HTML 그대로
			
			String text = Jsoup.clean("<script>alert(1)</script><p>안녕</p>", Safelist.none());
			System.out.println(text);	// 출력: 안녕
																			Safelist.none() → 모든 태그 제거, 텍스트만 남김
																			Safelist.basic() → <b>, <i>, <a> 같은 기본 태그만 허용
			
		*/
		
		for(BoardDTO dto : boardDtoList) {
			// 1. 텍스트 변환
			String boardContentText = Jsoup.clean(dto.getBoardContent()
					.replaceAll("(?i)<br\\s*/?>", "\n")	// 대소문자 구분 없이, <br>, <br/>, <br >, <BR/> 같은 줄바꿈 태그를 전부 찾기, 및 공백 변환
					.replace("&nbsp;", " "), Safelist.none());
			dto.setBoardContentText(boardContentText);
			
			// 2. 이미지 체크 및 추출
			Element img = Jsoup.parse(dto.getBoardContent()).selectFirst("img[src]");	// import org.jsoup.nodes.Element;
			if (img != null) {
				String boardContentImg = img.attr("src");
				dto.setBoardContentImg(boardContentImg);
			}
		}// end of for----------------
		
		return boardDtoList;
	}
	
	
	// 해당 카테고리 검색된 게시글의 총 개수
	@Override
	public int getBoardCount(Map<String, String> paraMap) {
		int totalCount = mapper.getBoardCount(paraMap);
		return totalCount;
	}
	
	
	// 키워드 관련 로직 구현
	@Override
	public List<Map.Entry<String,Integer>> getKeyWord(String fk_categoryNo) {
		
		// 보드 테이블에서 제목과 내용 가져오기
		List<BoardDTO> boardListKey = mapper.getBoardContents(fk_categoryNo);
		
		// 키워드 넣을 리스트 생성
		List<String> keyword = new ArrayList<>();
		
		// 게시글 제목과 내용을 하나의 문장으로 합치기
		for (BoardDTO dto : boardListKey) {
			String name = dto.getBoardName() == null ? "" : dto.getBoardName();
			String content = dto.getBoardContent() == null ? "" : dto.getBoardContent();
			keyword.add(name + " " + content);
		}
		
		// 1) HTML 대충 제거 & 소문자화 , 정규식 사용
		String keyword_check = String.join(" ", keyword)
				.replace("&nbsp;", " ")
				.toLowerCase()
				.replaceAll("<[^>]+>", " ")				// <p> 처럼 태그 형태 제거
				.replaceAll("[^0-9a-zA-Z가-힣]+", " ")	// 한글/영문/숫자 빼고 다 공백 처리
				.replaceAll("\\s+", " ")				// \\s → 정규식에서 공백 문자(whitespace) 를 의미, 공백 정리
														// replaceAll("\\s+", " ") 은 연속된 모든 종류의 공백(스페이스/탭/줄바꿈 등)을 스페이스 하나 로 바꾸는 코드
				.trim();
		
		// 2) 불용어/길이 필터(아주 최소)
		Set<String> stop = Set.of("은","는","이","가","을","를","에","의","와","과","도","로","으로","하고","그리고","또는","더","것","수","등","및","the","and","or","to","of","in");
		// 의미 없는 단어 모음집 (stop) 만들기
		
		Map<String, Integer> keywordCount = new HashMap<>();	// 단어별 빈도 수 조사하기!
		
		for (String key : keyword_check.split(" ")) {	// 공백을 기준으로 단어 나눠주기
			if (key.length() >= 2 && !stop.contains(key)) {	// 단어 길이 2이상 및 stop 집합에 들어있는 단어가 아닌지 체크하기
				keywordCount.merge(key, 1, Integer::sum);
				/*
					map.merge(key, value, remappingFunction)
					key → 찾을 키
					value → 기본값 (키가 없을 때 넣을 값)
					remappingFunction → 키가 이미 있으면 (oldValue, value)를 받아서 새 값을 계산하는 함수
					
					Integer::sum 뜻
					메서드 참조 문법 (Java 8)
					사실상 (oldVal, newVal) -> oldVal + newVal 람다랑 같음
					즉, 키가 이미 있으면 → 기존 값 + 새 값 으로 업데이트하라는 의미
				*/
			}
		}
		
		List<Map.Entry<String,Integer>> entryList = new ArrayList<>(keywordCount.entrySet());
		/*
			Map 안에서 "자바"=5 같이 Key와 Value가 묶여 있는 걸 Entry라고 불
			
			entrySet()
			map.entrySet() → Map 안에 있는 모든 Entry(=Key-Value 쌍) 를 모아둔 Set을 반환
			즉, Set<Map.Entry<K,V>> 타입
			예시 ["자바"=5, "스프링"=3]
		*/
		
		// 정렬: value 내림차순, 같으면 key 오름차순
		entryList.sort((a,b) -> {
			int c = Integer.compare(b.getValue(), a.getValue());	// 벨류 값 비교해서 큰 값이 앞으로 옴 (내림차순)
			return (c != 0 ? c : a.getKey().compareTo(b.getKey()));	// 벨류 값이 같다면 compareTo는 문자열을 유니코드 순서대로 비교
		});
		
		// 상위 3개만 뽑기
		List<Map.Entry<String,Integer>> keyword_top = entryList.subList(0, Math.min(3, entryList.size()));	// entryList의 크기가 3보다 작으면, 있는 만큼만 뽑음
		
		return keyword_top;
	}
	
	
	// 자동 검색어 완성시키기
	@Override
	public List<Map<String, String>> getSearchWordList(Map<String, String> paraMap) {
		
		List<String> wordList = mapper.getSearchWordList(paraMap);	// 자동 검색어 완성시킬 제목 or 이름 가져오기
		
		List<Map<String, String>> mapList = new ArrayList<>();
		
		if(wordList != null) {
			for(String word : wordList) {
				Map<String, String> map = new HashMap<>();
				map.put("word", word);
				
				mapList.add(map);
			}// end of for-----------------
		}
		
		return mapList;
	}
	
	
	// 글 1개 가져오기
	@Override
	public BoardDTO selectView(Map<String, String> paraMap) {
		BoardDTO bdto = mapper.selectView(paraMap);
		return bdto;
	}
	
	
	// 글 삭제하기
	@Override
	public int delete(Map<String, String> paraMap) {
		
		BoardDTO bdto = mapper.selectView(paraMap);
		if (bdto == null) return 0;
		
		int n = mapper.delete(paraMap);	// 글 삭제하기
		
		if(n == 1) {
			// 파일 체크 후 있으면 삭제하기
			if(bdto.getBoardFileName() != null && !bdto.getBoardFileName().equals("")) {
				
				String filepath = paraMap.get("root") + "resources" + File.separator + "files";
				
				try {
					fileManager.doFileDelete(bdto.getBoardFileName(), filepath);
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
			
			// 게시글 본문 이미지 체크 후 있으면 전부 삭제
			Elements imgList = Jsoup.parse(bdto.getBoardContent()).select("img[src]");
			/*
				<img src="/justsurviveoffice/resources/photo_upload/20250825162405_39bcb4d270da4a16b38db1cd9fd6a079.png" title="20250825162405_39bcb4d270da4a16b38db1cd9fd6a079.png" width="333" height="382" rwidth="333" rheight="382.5" style="border-color: rgb(0, 0, 0); width: 333px; height: 382.5px;">
				<img src="/justsurviveoffice/resources/photo_upload/20250825162422_52a49e1fe76142b4af77406883112d8a.png" title="20250825162422_52a49e1fe76142b4af77406883112d8a.png" sqeid="QE_175610666370418462" style="border-color: rgb(0, 0, 0);">
			*/
			
			if(imgList != null) {
				
				String imgFilepath = paraMap.get("root") + "resources" + File.separator + "photo_upload";
				
				for(Element img : imgList) {
					
					String ContentImg = img.attr("src");
				//	System.out.println(ContentImg);
					/*
						/justsurviveoffice/resources/photo_upload/20250825162405_39bcb4d270da4a16b38db1cd9fd6a079.png
						/justsurviveoffice/resources/photo_upload/20250825162422_52a49e1fe76142b4af77406883112d8a.png
					*/
					
					String imgFilename = new File(ContentImg).getName();	// File.getName() 은 경로 구분자(/, \) 다 처리해주니까 OS 상관없이 안전
				//	System.out.println(imgFilename);
					/*
						20250825162405_39bcb4d270da4a16b38db1cd9fd6a079.png
						20250825162422_52a49e1fe76142b4af77406883112d8a.png
					*/
					
					try {
						fileManager.doFileDelete(imgFilename, imgFilepath);
					} catch (Exception e) {
						e.printStackTrace();
					}
					
				}// end of for--------------------------------
				
			}// end of if(imgList != null) -------------------------
			
		}// end of if(n == 1)----------------------------
		
		return n;
	}
	
	
	
}
