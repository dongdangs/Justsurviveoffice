package com.spring.app.board.model;

import java.util.HashMap;
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
	
<<<<<<< HEAD
	// 내가 작성한 글 목록 
    @Override
    public List<BoardDTO> getMyBoards(String fkId) {
        return sql.selectList("board.getMyBoards", fkId);
    }
	
	 // 북마크한 게시글 목록 
    @Override
    public List<BoardDTO> getBookmarksById(String fkId) {
    	return sql.selectList("board.getBookmarksById", fkId);
    }
    
    //게시글 좋아요 수
	@Override
	public int getLikeCount(Long boardNo) {
        return sql.selectOne("boardLike.getLikeCount", boardNo);

	}


=======
	////////////////////////////////////////////////////////////////////////////
	// 인기 게시글 리스트 (조회수 많은 순)
	@Override
	public List<BoardDTO> getTopBoardsByViewCount() {
		List<BoardDTO> hotReadList = sql.selectList("board.getTopBoardsByViewCount");
		return hotReadList;
	}
	
	// 댓글 많은 게시글 리스트
	@Override
	public List<BoardDTO> getTopBoardsByCommentCount() {
		List<BoardDTO> hotCommentList = sql.selectList("board.getTopBoardsByCommentCount");
		return hotCommentList;
	}	
	
	// Hot 게시글 전체 리스트 (조회수 많은 순)
	@Override
	public List<BoardDTO> hotAll() {
		List<BoardDTO> hotAllList = sql.selectList("board.hotAll");
		return hotAllList;
	}
>>>>>>> branch 'main' of https://github.com/dongdangs/Justsurviveoffice.git
	
	
	////////////////////////////////////////////////////////////////////////////
	
	// 게시물 좋아요
	@Override
	public int boardLike(String fk_id, Long fk_boardNo) {
		Map<String, Object> paramMap = new HashMap<>();
        paramMap.put("fk_id", fk_id);
        paramMap.put("fk_boardNo", fk_boardNo);
        return sql.insert("boardLike.boardLike", paramMap);
	}
	
}