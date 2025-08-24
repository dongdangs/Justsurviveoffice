package com.spring.app.board.model;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

import com.spring.app.board.domain.BoardDTO;

import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class BoardDAO_imple implements BoardDAO {
	
	@Qualifier("sqlsession")
	private final SqlSessionTemplate sql;
	
	// 파일첨부 안 된 게시물 업로드
	@Override
	public int insertBoard(BoardDTO boardDto) {
		return sql.insert("board.insertBoard", boardDto);
	}
	// 파일첨부 된 게시물 업로드
	@Override
	public int insertBoardWithFile(BoardDTO boardDto) {
		return sql.insert("board.insertBoardWithFile", boardDto);
	}
	// 게시물의 리스트를 추출해오며, 검색 목록이 있는 경우도 포함.
	@Override
	public List<BoardDTO> selectBoardList(Map<String, String> paraMap) {
		return sql.selectList("board.selectBoardList", paraMap);
	}
	// 조회수 증가 및 페이징 기법이 포함된 게시물 상세보기 메소드
	@Override
	public BoardDTO selectView(Long boardNo) {
		return sql.selectOne("board.selectView", boardNo);
	}
	// 게시물 삭제하기 == boardDeleted = 0 으로 전환하기 == update
	@Override
	public int softDeleteBoard(Long boardNo) {
		return sql.update("board.softDeleteBoard", boardNo);
	}
	// 조회수 증가시키기! ip측정 및 스케줄러는 컨트롤러&서비스에서!
	@Override
	public int updateReadCount(Long boardNo) {
		return sql.update("board.updateReadCount", boardNo);
	}
	
	
	
}


