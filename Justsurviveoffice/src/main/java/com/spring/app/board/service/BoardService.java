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
	List<BoardDTO> boardList(String categoryNo);

	// 조회수 증가와 상세조회
	BoardDTO getboardDetail(Map<String, String> paraMap);

	// 조회수 증가 없이 상세조회
	BoardDTO getboardDetailNoIncrease(Map<String, String> paraMap);
	
	// 댓글 목록
	List<CommentDTO> getCommentList(String boardNo);

	// 댓글 쓰기
	int commentWrite(CommentDTO commentDto);

	////////////////////////////////////////////////////////////////////////// 
	
	// 인기 게시글 리스트 (조회수 많은 순)
	List<BoardDTO> getTopBoardsByViewCount();

	// Hot 게시글 전체 리스트 (조회수 많은 순)
	List<BoardDTO> hotAll();

	// 댓글 많은 게시글 리스트
	List<BoardDTO> getTopBoardsByCommentCount();
	
 

	
	

	


	


}
