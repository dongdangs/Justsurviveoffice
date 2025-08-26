package com.spring.app.board.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.spring.app.board.domain.BoardDTO;
import com.spring.app.board.model.BoardDAO;
import com.spring.app.comment.model.CommentDAO;
import com.spring.app.common.FileManager;
import com.spring.app.users.domain.CommentDTO;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class BoardService_imple implements BoardService {

    private final BoardDAO boardDao;
    private final FileManager fileManager;
    private final CommentDAO commentDao;
	
    // 게시글 업로드 메소드
	@Override
	@Transactional(value="transactionManager_final_orauser2",
	   propagation=Propagation.REQUIRED, 
	   isolation=Isolation.READ_COMMITTED, 
	   rollbackFor = {Throwable.class})
	public int insertBoard(BoardDTO boardDto) {
		
		int result = 0;
		
		if(boardDto.getBoardFileName() == null ||
			"".equals(boardDto.getBoardFileName())) {
			// 파일첨부 안 된 경우.
			result = boardDao.insertBoard(boardDto);
		}
		else {
			// 파일첨부 된 경우.
			result = boardDao.insertBoardWithFile(boardDto);
		}
		
		return result;
	}

	// 게시물의 리스트를 추출해오며, 검색 목록이 있는 경우도 포함.
	@Override
	public List<BoardDTO> boardList(Map<String, String> paraMap) {
		
		List<BoardDTO> boardList = boardDao.selectBoardList(paraMap);

		return boardList;
	}

	// 조회수 증가 및 페이징 기법이 포함된 게시물 상세보기 메소드
	@Override
	public BoardDTO selectView(Long boardNo) {

		BoardDTO boardDto = boardDao.selectView(boardNo);
		
		return boardDto;
	}

	// 게시물 삭제하기 == boardDeleted = 0 으로 전환하기 == update
	@Override
	public int deleteBoard(Long boardNo) {
		
		int n = boardDao.softDeleteBoard(boardNo);
		
		return n;
	}

	// 조회수 증가시키기! ip측정 및 스케줄러는 컨트롤러&서비스에서!
	@Override
	public int updateReadCount(Long boardNo) {
		
		int n = boardDao.updateReadCount(boardNo);

		return n;
	}


	 //내가 작성한 글 목록
    @Override
    public List<BoardDTO> getMyBoards(String fkId) {
        return boardDao.getMyBoards(fkId);
    }

    // 북마크한 글 목록
    @Override
    public List<BoardDTO> getBookmarksById(String fkId) {
        return boardDao.getBookmarksById(fkId);
    }

    
    // 댓글목록
	@Override
	public List<CommentDTO> getCommentList(Long boardNo) {
	    return commentDao.getCommentList(boardNo);
	}

	
	//게시글 좋아요 여부
	@Override
	public boolean isBoardLiked(Long boardNo, String fkId) {
		 
		Map<String, Object> boardLike = new HashMap<>();
		
		boardLike.put("fkId", fkId);
		boardLike.put("boardNo", boardNo);
		return false;
		
	}

	@Override
	public void deleteBoardLike(Long boardNo, String id) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void insertBoardLike(Long boardNo, String id) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public int getBaordLikeCount(Long boardNo) {
		return boardDao.getLikeCount(boardNo);
	}
	
    
    
	
}




