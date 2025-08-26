package com.spring.app.board.service;

import java.util.List;
import java.util.Map;
import java.util.Optional;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.spring.app.board.domain.BoardDTO;
import com.spring.app.board.model.BoardDAO;
import com.spring.app.common.FileManager;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class BoardService_imple implements BoardService {

    private final BoardDAO boardDao;
    private final FileManager fileManager;
	
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
	////////////////////////////////////////////////////////////////////////////////////   
	
}




