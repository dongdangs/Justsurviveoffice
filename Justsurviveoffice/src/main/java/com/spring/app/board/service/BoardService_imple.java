package com.spring.app.board.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Optional;
import java.util.Set;


import org.jsoup.Jsoup;
import org.jsoup.nodes.Element;
import org.jsoup.safety.Safelist;
import org.jsoup.select.Elements;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.spring.app.board.domain.BoardDTO;
import com.spring.app.board.model.BoardDAO;
import com.spring.app.comment.domain.CommentDTO;
import com.spring.app.comment.model.CommentDAO;
import com.spring.app.common.FileManager;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class BoardService_imple implements BoardService {

	private final BoardDAO boardDao;
    private final FileManager fileManager;
    private final CommentDAO commentDao;
	
    // 게시글 업로드 메소드
	@Override
	@Transactional(value="transactionManager_final_orauser2",
	   			   propagation=Propagation.REQUIRED, 
	   			   isolation=Isolation.READ_COMMITTED, 
	   			   rollbackFor = {Throwable.class})
	public int insertBoard(BoardDTO boardDto) {
		
		int result = 0;
		// SQL문 if 처리해도 되지만, service 단에서 처리하는 실무연습.
		if(boardDto.getBoardFileName() == null ||
		   "".equals(boardDto.getBoardFileName())) {
			// 파일첨부 안 된 경우.
			result = boardDao.insertBoard(boardDto);
		}
		else {
			// 파일첨부 된 경우.
			result = boardDao.insertBoardWithFile(boardDto);
		}
		return result;
	}

	// 게시물의 리스트를 추출해오며, 검색 목록이 있는 경우도 포함.
	@Override
	public List<BoardDTO> boardList(Map<String, String> paraMap) {
		
		List<BoardDTO> boardList = boardDao.selectBoardList(paraMap);
		
		for(BoardDTO dto : boardList) {
			// 1. 텍스트 변환
			String textForBoardList = Jsoup.clean(dto.getBoardContent()
					.replaceAll("(?i)<br\\s*/?>", "\n")	// 대소문자 구분 없이, <br>, <br/>, <br >, <BR/> 같은 줄바꿈 태그를 전부 찾기, 및 공백 변환
					.replace("&nbsp;", " "), Safelist.none());
			dto.setTextForBoardList(textForBoardList.length() > 20
									? textForBoardList.substring(0,20) + "..."
									: textForBoardList);
			// 2. 이미지 체크 및 추출
			Element img = Jsoup.parse(dto.getBoardContent()).selectFirst("img[src]");	// import org.jsoup.nodes.Element;
			if (img != null) {
				String imgForBoardList = img.attr("src");
				dto.setImgForBoardList(imgForBoardList);
				System.out.println("스마트에디터이미지는 경로 >> " +imgForBoardList);
				System.out.println("첨부이미지는 경로 >> " +dto.getBoardFileName());
			} 
		}
		//이렇게 하지않으면, JSP가 HTML 스마트 에디터의 태그까지 문자열로 찍어주기 때문에 레이아웃이 깨짐!

		return boardList;
	}

	// 스마트에디터파일을 DB에서 받아와, List로 반환하기.
	@Override
	public List<String> fetchPhoto_upload_boardFileNameList(Long boardNo) {
		BoardDTO dto = selectView(boardNo);
		// 스마트 에디터 이미지만 추출하기!
		Elements imgList = Jsoup.parse(dto.getBoardContent()).select("img[src]");
		// import org.jsoup.nodes.Elements;
		List<String> photo_upload_boardFileNameList = new ArrayList<>();
		for(Element img : imgList) {
			System.out.println(img);
			if (img != null) {
				String src = img.attr("src");
		        // 파일명만 추출: 마지막 "/" 뒤 문자만
		        String fileName = src.substring(src.lastIndexOf("/") + 1);
				photo_upload_boardFileNameList.add(fileName);
				System.out.println(fileName);
			}
		}
		return photo_upload_boardFileNameList;
	}

	
	// 조회수 증가 및 페이징 기법이 포함된 게시물 상세보기 메소드
	@Override
	public BoardDTO selectView(Long boardNo) {

		BoardDTO boardDto = boardDao.selectView(boardNo);
		
		return boardDto;
	}

	// 게시물 삭제하기 == boardDeleted = 0 으로 전환하기 == update
	@Override
	public int deleteBoard(Long boardNo) {
		
		int n = boardDao.softDeleteBoard(boardNo);
		
		return n;
	}

	// 조회수 증가시키기! ip측정 및 스케줄러는 컨트롤러&서비스에서!
	@Override
	public int updateReadCount(Long boardNo) {
		
		int n = boardDao.updateReadCount(boardNo);

		return n;
	}

	// 게시물 수정하기, 수정시 기존 파일은 삭제!
	@Override
	public int updateBoard(BoardDTO boardDto) {
		
		int n = boardDao.updateBoard(boardDto);

		return n;
	}
	
	// 메인페이지 카테고리 자동 불러오기 메서드
	@Override
	public List<Map<String, String>> getIndexList(String fk_categoryNo) {
		List<Map<String, String>> IndexList = boardDao.getIndexList(fk_categoryNo);
		return IndexList;
	}


	@Override
	public BoardDTO getView(Long boardNo) {
		BoardDTO boardDto = boardDao.getView(boardNo);
			
		return boardDto;
	}

	//내가 작성한 글 목록
//  @Override
//  public List<BoardDTO> getMyBoards(String fk_id) {
//    	return boardDao.getMyBoards(fk_id);
//  }
	   
   	// 내가 작성한 글 목록 스크롤
	@Override
    public List<BoardDTO> myBoardsScroll(Map<String, Object> paramMap) {
		return boardDao.myBoardsScroll(paramMap);
    }

    // 북마크한 글 목록
    @Override
    public List<BoardDTO> getBookmarksById(String fk_id) {
        return boardDao.getBookmarksById(fk_id);
    }

    
    // 댓글목록
	@Override
	public List<CommentDTO> getCommentList(Long boardNo) {
	 	List<CommentDTO> commentList = commentDao.getCommentList(boardNo);
		 
	 	for (CommentDTO comment : commentList) {
	 		List<CommentDTO> replies = commentDao.getRepliesByParentNo(comment.getCommentNo());
	 		comment.setReplyList(replies);
	    }

	    return commentList;
	}

	
	////////////////////////////////////////////////////////////////////////////////////
	// 인기 게시글 리스트 (조회수 많은 순)
	@Override
	public List<BoardDTO> getTopBoardsByViewCount() {
		List<BoardDTO> hotReadList = boardDao.getTopBoardsByViewCount();
		return hotReadList;
	}
	
	
	// 댓글 많은 게시글 리스트
	@Override
	public List<BoardDTO> getTopBoardsByCommentCount() {
		List<BoardDTO> hotCommentList = boardDao.getTopBoardsByCommentCount();
		return hotCommentList;
	}

	
	////////////////////////////////////////////////////////////////////////////////////   
	
	
	//게시글 좋아요 여부
	@Override
	public boolean isBoardLiked(String fk_id, Long fk_boardNo) {
		 
		Map<String, Object> paramMap = new HashMap<>();
		
		paramMap.put("fk_id", fk_id);
		paramMap.put("fk_boardNo", fk_boardNo);
		
		int count = boardDao.isBoardLiked(paramMap);
	    return count > 0; // 좋아요가 존재하면 true			
	}

	//게시글 좋아요 취소
	@Override
	public int deleteBoardLike(String fk_id, Long fk_boardNo) {
	    return boardDao.deleteBoardLike(fk_id, fk_boardNo);

		
	}

	//게시글 좋아요 추가
	@Override
	public int insertBoardLike(String fk_id, Long fk_boardNo) {
		int n = boardDao.insertBoardLike( fk_id,fk_boardNo );
		return n;
	}
	

	//게시글 좋아요 수
	@Override
	public int getBoardLikeCount(Long fk_boardNo) {
		return boardDao.getLikeCount(fk_boardNo);
	}
		
		

	

	
	// 총 검색된 게시물 건수
	@Override
	public int searchListCount(Map<String, String> paraMap) {
		int n = boardDao.searchListCount(paraMap);
		return n;
	}
	
	// 자동 검색어 완성시키기
	@Override
	public List<Map<String, String>> getSearchWordList(Map<String, String> paraMap) {
		
		List<String> wordList = boardDao.getSearchWordList(paraMap);	// 자동 검색어 완성시킬 제목 or 이름 가져오기
		
		List<Map<String, String>> mapList = new ArrayList<>();
		
		if(wordList != null) {
			for(String word : wordList) {
				Map<String, String> map = new HashMap<>();
				map.put("word", word);
				System.out.println(word);
				mapList.add(map);
			}// end of for-----------------
		}
		
		return mapList;
	}
	
	// == 키워드 메소드 작성 해봄 == // 
	@Override
	public List<Entry<String, Integer>> getKeyWord(String category) {
		
		// 보드 테이블에서 제목과 내용 가져오기(DB)
		List<BoardDTO> boardListKey = boardDao.getBoardContents(category);
		
		// 키워드 넣을 리스트 생성
		List<String> keyword = new ArrayList<>();
		
		// DB에 가져온 게시글 제목과 내용을 하나의 문장으로 합치기
		for (BoardDTO dto : boardListKey) {
			String name = dto.getBoardName() == null ? "" : dto.getBoardName();	// 게시글 제목이 없다면 ""로 만들기
			String content = dto.getBoardContent() == null ? "" : dto.getBoardContent(); // 게시글 내용이 없다면 ""로 만들기
			keyword.add(name + " " + content);	// 제목과 내용 사이에 공백을 하나두고 한문장으로 합치기
		}
		
		// 1) HTML 대충 제거 & 소문자화 , 정규식 사용
		String keyword_check = String.join(" ", keyword)
				.replace("&nbsp;", " ")
				.toLowerCase()
				.replaceAll("<[^>]+>", " ")				// <p> 처럼 태그 형태 제거
				.replaceAll("[^0-9a-zA-Z가-힣]+", " ")	// 한글/영문/숫자 빼고 다 공백 처리 (잡다한 특수문자도 제거해줌)
				.replaceAll("\\s+", " ")				// \\s → 정규식에서 공백 문자(whitespace) 를 의미, 공백 정리
														// replaceAll("\\s+", " ") 은 연속된 모든 종류의 공백(스페이스/탭/줄바꿈 등)을 스페이스 하나 로 바꾸는 코드
				.trim();								// 문자열 시작과 끝의 공백만 날려줌
		
		// 2) 불용어(의미없는 단어) 및 길이 필터(아주 최소)
		Set<String> stop = Set.of("은","는","이","가","을","를","에","의","와","과","도","로","으로","하고","그리고","또는","더","것","수","등","및","the","and","or","to","of","in");
		// 의미 없는 단어 모음집 (stop) 만들기
		
		Map<String, Integer> keywordCount = new HashMap<>();	// 단어별 빈도 수 조사하기!
		
		for (String key : keyword_check.split(" ")) {	// 공백을 기준으로 나눠서 단어 집합 만들고 집합 순서별 단어 = key
			if (key.length() >= 2 && !stop.contains(key)) {	// 단어 길이 2이상 및 해당 단어가 stop 집합에 들어있는 단어가 포함인지 아닌지 체크하기
				keywordCount.merge(key, 1, Integer::sum);
				/*
					map.merge(key, value, remappingFunction)
					key → 찾을 키(예시: 단어)
					value → 기본값 (키가 없을 때 넣을 값) >> 해당 단어가 없을 때 추가해주고 value = 1 넣어주기 ("단어":1)
					remappingFunction → 키가 이미 있으면 (oldValue, value)를 받아서 새 값을 계산하는 함수 
					>> "상사":3 이라는 값이 저장 되었는데 "상사" 단어가 또 나오면 (3, 1) >> 3 + 1 로 계산해서 4로 저장하라는 것 ("상사":4)
					
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
			기존 Map은 키값을("자바") 알고 있으면 값을 반환해줌(5) 
			Map.Entry 는 "자바"=5 로 저장되어 그 맵을 a라고 표현할 때 a.getKey() / a.getValue() 문법을 통해서 "자바" 또는 5 라는 값을 얻을 수 있다.
			
			entrySet()
			map.entrySet() → Map 안에 있는 모든 Entry(=Key-Value 쌍) 를 모아둔 Set을 반환
			즉, Set<Map.Entry<K,V>> 타입
			예시 ["자바"=5, "스프링"=3]
			여기서 타입을 List<Map.Entry<K,V>> 형식으로 저장했는데 그 이유는 Set에는 순서 개념(정렬)이라는 것이 없어서 정렬하기 위해 List로 저장한 것이다.
		*/
		
		// 정렬: value 내림차순, 같으면 key 오름차순
		entryList.sort((a,b) -> {
			/*
				int result = comparator.compare(a, b);
				comparator.compare(a, b) 	>> a < b 이면 -1
											>> a = b 이면  0
											>> a > b 이면  1
				result < 0 → a가 b보다 앞에 와야 한다
				result == 0 → a와 b의 순서는 바뀌지 않는다 (동등)
				result > 0 → a가 b보다 뒤에 와야 한다
			*/
			// 값을 (a,b) 로 줬는데 compare(a.getValue(), b.getValue()) 라면 오름차순인데 아래는 거꾸로 되있으므로 내림차 순!
			int c = Integer.compare(b.getValue(), a.getValue());	// 벨류 값 비교해서 큰 값이 앞으로 옴 (내림차순) >> (3, 5) -> (5, 3)
			return (c != 0 ? c : a.getKey().compareTo(b.getKey()));	// 벨류 값이 같다면 compareTo는 문자열을 유니코드값 순서대로 비교
																	// a의 Key = "A", b의 key = "B" 라고 가정하자
																	// "A"의 유니코드 U+0041 / "B"의 유니코드 U+0042 >> B가 더 크므로 a가 b보다 앞에 와야 한다.
		});
		
		// 상위 3개만 뽑기
		List<Map.Entry<String,Integer>> keyword_top = entryList.subList(0, Math.min(3, entryList.size()));	// entryList의 크기가 3보다 작으면, 있는 만큼만 뽑음
		// subList >> 해당 리스트의 0번 째부터 Math.min(3, entryList.size()) 까지 잘라서 반환해주기
		// Math.min(3, entryList.size()) => 리스트 크기가 최대 3까지만 잘라올 것, 혹시나 entryList.size() 값이 3보다 작을 경우 대비해 해당 entryList.size() 값을 반환해줌!
		
		return keyword_top;
	}


	
//	// 유저가 하루동안 쓴 글의 개수를 얻어오는 메소드 (3개 이하면 pointUp)
//	@Override
//	public int getCreatedAtBoardCnt(String id) {
//		return boardDao.getCreatedAtBoardCnt(id);
//	}

	
	
}