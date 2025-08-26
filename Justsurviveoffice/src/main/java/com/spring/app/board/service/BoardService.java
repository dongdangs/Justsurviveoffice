package com.spring.app.board.service;

import java.util.List;
import java.util.Map;

import org.springframework.cache.annotation.Cacheable;

import com.spring.app.board.domain.BoardDTO;
import com.spring.app.users.domain.CommentDTO;

public interface BoardService {
	
	//////////////////////////////////////////////////////////////////////////
	// Hot 게시글 전체 리스트 (조회수 많은 순)
	List<BoardDTO> hotAll();
		
	// 인기 게시글 리스트 (조회수 많은 순)
	@Cacheable("hotReadList")
	List<BoardDTO> getTopBoardsByViewCount();
	
	// 댓글 많은 게시글 리스트
	@Cacheable("hotCommentList")
	List<BoardDTO> getTopBoardsByCommentCount();
	//////////////////////////////////////////////////////////////////////////

	// 게시글 업로드 메소드
	public int insertBoard(BoardDTO boardDto);
	
	// 게시물의 리스트를 추출해오며, 검색 목록이 있는 경우도 포함.
	public List<BoardDTO> boardList(Map<String, String> paraMap);
	
	// 조회수 증가 및 페이징 기법이 포함된 게시물 상세보기 메소드
	public BoardDTO selectView(Long boardNo);
	
	// 게시물 삭제하기 == boardDeleted = 0 으로 전환하기 == update
	public int deleteBoard(Long boardNo);
	
	// 조회수 증가시키기! ip측정 및 스케줄러는 컨트롤러&서비스에서!
	public int updateReadCount(Long boardNo);
	
    
    // 내가 작성한 글 목록
    List<BoardDTO> getMyBoards(String fkId);

    // 북마크한 게시글 목록
    List<BoardDTO> getBookmarksById(String fkId);

	public List<CommentDTO> getCommentList(Long boardNo);

	//게시물 좋아요 여부 확인
	public boolean isBoardLiked(Long boardNo, String fkId);

	//게시물 좋아요 취소
	public void deleteBoardLike(Long boardNo, String fkId);

	//게시물 좋아요
	public void insertBoardLike(Long boardNo, String fkId);

    // 좋아요 수 
	public int getBaordLikeCount(Long boardNo);
	
	

	// 게시물 좋아요
	void boardLike(String fk_id, Long fk_boardNo);
	
	

}
