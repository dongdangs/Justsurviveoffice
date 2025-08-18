package com.spring.app.board.service;

import java.util.List;

import com.spring.app.entity.Users;
import com.spring.app.users.domain.*;

public interface BoardService {
	
	// 작성한 폼 
	List<BoardDTO> getBoardsByWriterId(String fk_id);

	//북마크
	List<BookMarkDTO> getBookmarksById(String fk_id);



	


}
