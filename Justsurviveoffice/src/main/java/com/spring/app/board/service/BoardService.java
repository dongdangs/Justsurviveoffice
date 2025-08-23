package com.spring.app.board.service;

import java.util.List;
import java.util.Map;

import com.spring.app.users.domain.BoardDTO;
import com.spring.app.users.domain.BookMarkDTO;
import com.spring.app.users.domain.CategoryDTO;
import com.spring.app.users.domain.CommentDTO;

public interface BoardService {
	
	// 작성한 폼 
	List<BoardDTO> getBoardsByWriterId(String fk_id);

	//북마크
	List<BookMarkDTO> getBookmarksById(String fk_id);
	
	// 인덱스 페이지 카테고리 리스트
	List<CategoryDTO> categoryList();
	
	// 글 목록
	List<BoardDTO> pagingboardList(int categoryNo);

	// 조회수 증가와 함께 글 1개 조회
	BoardDTO getnointerDetail(Map<String, String> paraMap);

	// 조회수 증가 없고, 글 1개 조회
	BoardDTO getnointerDetail_no_increase(Map<String, String> paraMap);
 

	
	

	


	


}
