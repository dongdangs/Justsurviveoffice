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
	public List<BoardDTO> pagingboardList(int categoryNo) {
		List<BoardDTO> boardList = sql.selectList("board.pagingboardList", categoryNo);
		return boardList;
	}


	// 글 1개 조회하기
	@Override
	public BoardDTO getnointerDetail(Map<String, String> paraMap) {
		BoardDTO boardDto = sql.selectOne("board.getnointerDetail", paraMap);
		return boardDto;
	}


	// 글 조회수 증가시키기
	@Override
	public int incease_readCount(String boardNo) {
		int n = sql.update("board.incease_readCount", boardNo);
		return n;
	}


	// 첨부파일이 없는 경우 글쓰기
	@Override
	public int write(BoardDTO boardDto) {
		int n = sql.insert("board.write", boardDto);
		return n;
	}


	// 첨부파일이 있는 경우 글쓰기
	@Override
	public int writeFile(BoardDTO boardDto) {
		int n = sql.insert("board.writeFile", boardDto);
		return n;
	}


	// 총 게시물 건수
	@Override
	public int getTotalCount() {
		int totalCount = sql.selectOne("board.getTotalCount");
		return totalCount;
	}

	
	// 댓글 목록
	@Override
	public List<CommentDTO> getCommentList(String boardNo) {
		List<CommentDTO> commentList = sql.selectList("board.getCommentList", boardNo);
		return commentList;
	}


	// 댓글 쓰기
	@Override
	public int commentWrite(CommentDTO commentDTO) {
		int n = sql.insert("board.commentWrite", commentDTO);
		return n;
	}


	
	
	
	
	
	

}
