package com.spring.app.service;

import java.util.List;


import org.springframework.stereotype.Service;

import com.spring.app.domain.BoardDTO;
import com.spring.app.domain.BookMarkDTO;
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
    
    // 내가 작성한 폼
    @Override
    public List<BoardDTO> getBoardsByWriterId(String id) {
        List<Board> board = boardRepository.findByFkIdOrderByCreatedAtBoardDesc(id);
        return board.stream()
                     .map(Board::toDTO)
                     .toList();
    }
    
    
    // 북마크
	@Override
	public List<BookMarkDTO> getBookmarksById(String id) {
		List<Bookmark> bookmark = bookMarkRepository.findByUsers_Id(id);
		

		return bookmark.stream()
				        .map(Bookmark::toDTO) // 엔티티 → DTO 변환
				        .toList();
	}

    
    

    
    
	

    
    
	
}

