package com.spring.app.board.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.spring.app.users.domain.BoardDTO;
import com.spring.app.users.domain.BookMarkDTO;
import com.spring.app.users.domain.CategoryDTO;
import com.spring.app.users.domain.CommentDTO;
import com.spring.app.board.model.BoardDAO;
import com.spring.app.entity.Board;
import com.spring.app.entity.Bookmark;
import com.spring.app.model.BoardRepository;
import com.spring.app.model.BookMarkRepository;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class BoardService_imple implements BoardService {

    private final BoardRepository boardRepository;
    private final BookMarkRepository bookMarkRepository;
    private final BoardDAO boardDao;
    
    // 내가 작성한 폼
    @Override
    public List<BoardDTO> getBoardsByWriterId(String fk_id) {
        return boardRepository.findByUsers_IdOrderByCreatedAtBoardDesc(fk_id)
                              .stream()
                              .map(Board::toDTO)
                              .toList();
    }
    
    
    // 북마크
	@Override
	public List<BookMarkDTO> getBookmarksById(String fk_id) {
		List<Bookmark> bookmark = bookMarkRepository.findByUsers_Id(fk_id);
		

		return bookmark.stream()
				        .map(Bookmark::toDTO) // 엔티티 → DTO 변환
				        .toList();
	}
	
	
	// 인덱스 페이지 카테고리 리스트
	@Override
	public List<CategoryDTO> categoryList() {
		List<CategoryDTO> categoryList = boardDao.categoryList();
		return categoryList;
	}


	// 글 목록
	@Override
	public List<BoardDTO> boardList(String categoryNo) {
		List<BoardDTO> boardList = boardDao.boardList(categoryNo);
		return boardList;
	}


	// 조회수 증가와 상세조회
	@Override
	public BoardDTO getboardDetail(Map<String, String> paraMap) {
		boardDao.incrementReadCount(paraMap.get("boardNo"));  // 조회수증가
		BoardDTO boardDto = boardDao.getboardDetail(paraMap); // 조회수 증가 없이 글 조회
		return boardDto;
	}


	// 조회수 증가 없이 상세조회
	@Override
	public BoardDTO getboardDetailNoIncrease(Map<String, String> paraMap) {
		BoardDTO boardDto = boardDao.getboardDetail(paraMap); // 조회수 증가 없이 글 조회
		return boardDto;
	}
	
	
	// 댓글 목록
	@Override
	public List<CommentDTO> getCommentList(String boardNo) {
		List<CommentDTO> commentList = boardDao.getCommentList(boardNo);
		return commentList;
	}

	// 댓글 쓰기
	@Override
	public int commentWrite(CommentDTO commentDto) {
		
		int n = boardDao.commentWrite(commentDto);
		
		if(n==1) {
			Map<String, String> paraMap = new HashMap<>();
			paraMap.put("id", commentDto.getFk_id());
			paraMap.put("point", "50");
			
			n = boardDao.updateUsersPoint(paraMap);
		}
		
		return n;
	}

	////////////////////////////////////////////////////////////////////////////////////	

	// 인기 게시글 리스트 (조회수 많은 순)
	@Override
	public List<BoardDTO> getTopBoardsByViewCount() {
		List<BoardDTO> hotReadList = boardDao.getTopBoardsByViewCount();
		return hotReadList;
	}


	// Hot 게시글 전체 리스트 (조회수 많은 순)
	@Override
	public List<BoardDTO> hotAll() {
		List<BoardDTO> hotAllList = boardDao.hotAll();
		return hotAllList;
	}


	// 댓글 많은 게시글 리스트
	@Override
	public List<BoardDTO> getTopBoardsByCommentCount() {
		List<BoardDTO> hotCommentList = boardDao.getTopBoardsByCommentCount();
		return hotCommentList;
	}


	

}

