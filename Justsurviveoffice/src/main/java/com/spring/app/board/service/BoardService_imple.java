package com.spring.app.board.service;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

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


	// '금쪽이' 게시판 리스트
	@Override
	public List<Map<String, String>> nointerList() {
		List<Map<String, String>> boardList = boardDao.nointerList();
		return boardList;
	}

    
    
	
}

