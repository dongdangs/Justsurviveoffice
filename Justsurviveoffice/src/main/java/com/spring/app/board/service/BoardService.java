package com.spring.app.board.service;

import java.util.List;
import java.util.Map;

import com.spring.app.users.domain.BoardDTO;
import com.spring.app.users.domain.BookMarkDTO;

public interface BoardService {
	
	// 작성한 폼 
	List<BoardDTO> getBoardsByWriterId(String fk_id);

	//북마크
	List<BookMarkDTO> getBookmarksById(String fk_id);

	// '금쪽이' 게시판 리스트
	List<Map<String, String>> nointerList();
	

	
	

	


	


}
