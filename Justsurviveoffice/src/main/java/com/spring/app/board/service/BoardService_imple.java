package com.spring.app.board.service;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.web.context.annotation.RequestScope;

import com.spring.app.users.domain.BoardDTO;
import com.spring.app.users.domain.BookMarkDTO;
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
    private final BoardDAO dao;
    
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

 
	@Override
	public List<Map<String, String>> BoardList(String fk_categoryNo) {
		List<Map<String, String>> mapList = dao.getBoardList(fk_categoryNo);
		return mapList;
		
	}


	@Override
	public BoardDTO getView(Map<String, String> paraMap) {
		
		BoardDTO boardDTO = dao.getView(paraMap);	// 글 1개 조회하기
		
		String login_userid = paraMap.get("login_userid");
		String boardNo = paraMap.get("boardNo");
		
		//if(!boardDTO.getFk_id().equals("login_userid")) { //  로그인한 사용자랑 작성자가 다른경우 //
		//	int n = dao.increaseReadCount(paraMap.get("seq"));
			
		//	if(n==1) {
		//		boardDTO.setReadCount( String.valueOf((Integer.parseInt(boardDTO.getReadCount()) + 1)) );	  
		//	}
		// }
		
		return boardDTO;
		
	}


	// 총 개수 조회
	@Override
	public int getTotalCount(Map<String, String> paraMap) {
		int totalCount = dao.getTotalCount(paraMap);
		return totalCount;
	}


	@Override
	public List<Map<String, String>> getIndexList(String fk_categoryNo) {
		List<Map<String, String>> IndexList = dao.getIndexList(fk_categoryNo);
		return IndexList;
	}






	
}

