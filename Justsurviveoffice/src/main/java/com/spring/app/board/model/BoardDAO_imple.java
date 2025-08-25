package com.spring.app.board.model;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

import com.spring.app.users.domain.BoardDTO;
import com.spring.app.users.domain.CategoryDTO;
import com.spring.app.users.domain.CommentDTO;

import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class BoardDAO_imple implements BoardDAO {
	
	// 의존객체를 생성자 주입(DI : Dependency Injection)
	@Qualifier("sqlsession")
	private final SqlSessionTemplate sql;
	
	
	// 인덱스 페이지 카테고리 리스트
	@Override
	public List<CategoryDTO> categoryList() {
		List<CategoryDTO> categoryList = sql.selectList("board.categoryList");
		return categoryList;
	}


	// 글 목록
	@Override
	public List<BoardDTO> boardList(String categoryNo) {
		List<BoardDTO> boardList = sql.selectList("board.boardList", categoryNo);
		return boardList;
	}


	// 글 상세 조회
	@Override
	public BoardDTO getboardDetail(Map<String, String> paraMap) {
		BoardDTO boardDto = sql.selectOne("board.getboardDetail", paraMap);
		return boardDto;
	}


	// 조회수 증가
	@Override
	public void incrementReadCount(String boardNo) {
		sql.update("board.incrementReadCount", boardNo);
	}
	
	
	// 댓글 목록
	@Override
	public List<CommentDTO> getCommentList(String boardNo) {
		List<CommentDTO> commentList = sql.selectList("comment.getCommentList", boardNo);
		return commentList;
	}


	// 댓글 쓰기
	@Override
	public int commentWrite(CommentDTO commentDto) {
		int n = sql.insert("comment.commentWrite", commentDto);
		return n;
	}


	// 댓글 쓴 후 포인트 점수 올리기
	@Override
	public int updateUsersPoint(Map<String, String> paraMap) {
		int n = sql.update("comment.updateUsersPoint", paraMap);
		return n;
	}

	
	////////////////////////////////////////////////////////////////////////////
		
	// 인기 게시글 리스트 (조회수 많은 순)
	@Override
	public List<BoardDTO> getTopBoardsByViewCount() {
		List<BoardDTO> hotReadList = sql.selectList("board.getTopBoardsByViewCount");
		return hotReadList;
	}


	// Hot 게시글 전체 리스트 (조회수 많은 순)
	@Override
	public List<BoardDTO> hotAll() {
		List<BoardDTO> hotAllList = sql.selectList("board.hotAll");
		return hotAllList;
	}


	// 댓글 많은 게시글 리스트
	@Override
	public List<BoardDTO> getTopBoardsByCommentCount() {
		List<BoardDTO> hotCommentList = sql.selectList("board.getTopBoardsByCommentCount");
		return hotCommentList;
	}	
	
	
	
	

}
