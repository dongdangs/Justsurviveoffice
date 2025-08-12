package com.spring.app.service;

import java.util.List;

import com.spring.app.domain.BoardDTO;
import com.spring.app.domain.BookMarkDTO;

public interface BoardService {
	
	// 작성한 폼 
	List<BoardDTO> getBoardsByWriterId(String fk_id);

	//북마크
	List<BookMarkDTO> getBookmarksById(String fk_id);


	


}
