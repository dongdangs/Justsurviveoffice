package com.spring.app.board.model;

import java.util.List;
import java.util.Map;

import com.spring.app.users.domain.BoardDTO;
import com.spring.app.users.domain.CategoryDTO;
import com.spring.app.users.domain.CommentDTO;

public interface BoardDAO {

	// 인덱스 페이지 카테고리 리스트
	List<CategoryDTO> categoryList();

	// 글 목록
	List<BoardDTO> pagingboardList(int categoryNo);

	// 글 1개 조회하기
	BoardDTO getnointerDetail(Map<String, String> paraMap);

	// 글 조회수 증가시키기
	int incease_readCount(String boardNo);

	// 첨부파일이 없는 경우 글쓰기
	int write(BoardDTO boardDto);

	// 첨부파일이 있는 경우 글쓰기
	int writeFile(BoardDTO boardDto);

	// 총 게시물 건수
	int getTotalCount();

	// 댓글 목록
	List<CommentDTO> getCommentList(String boardNo);

	// 댓글 쓰기
	int commentWrite(CommentDTO commentDTO);

	

}
