package com.spring.app.board.service;

import java.util.List;
import java.util.Map;

import com.spring.app.entity.Users;
import com.spring.app.users.domain.*;

public interface BoardService {
	
	// 작성한 폼 
	List<BoardDTO> getBoardsByWriterId(String fk_id);

	//북마크
	List<BookMarkDTO> getBookmarksById(String fk_id);

	List<Map<String, String>> BoardList(String fk_categoryNo);

	// 글 1개 조회
	BoardDTO getView(Map<String, String> paraMap);

	// 전체 수 조회
	int getTotalCount(Map<String, String> paraMap);

	// 인덱스 페이지 조회 
	List<Map<String, String>> getIndexList(String fk_categoryNo);



}
