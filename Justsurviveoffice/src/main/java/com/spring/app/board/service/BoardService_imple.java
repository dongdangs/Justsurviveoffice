package com.spring.app.board.service;

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
	public List<BoardDTO> pagingboardList(int categoryNo) {
		List<BoardDTO> boardList = boardDao.pagingboardList(categoryNo);
		return boardList;
	}


	// 조회수 증가와 함께 글 1개 조회
	@Override
	public BoardDTO getnointerDetail(Map<String, String> paraMap) {
		
		BoardDTO boardDto = boardDao.getnointerDetail(paraMap); // 글 1개 조회하기
		
		String loginUserid = paraMap.get("loginUserid");
		// paraMap.get("loginUserid") 은 로그인을 한 상태이라면 로그인한 사용자의 userid 이고,
		// 로그인을 하지 않은 상태이라면  paraMap.get("loginUserid") 은 null 이다.
		
		if(loginUserid != null &&
		   !loginUserid.equals(boardDto.getFk_id())) {
			// 글조회수 증가는 로그인을 한 상태에서 다른 사람의 글을 읽을때만 증가
			
			int n = boardDao.incease_readCount(paraMap.get("boardNo")); // 글 조회수 증가시키기
			
			if(n==1) {
				boardDto.setReadCount(boardDto.getReadCount() + 1);
			}
		}
		
		return boardDto;
	}


	// 조회수 증가 없고, 글 1개 조회
	@Override
	public BoardDTO getnointerDetail_no_increase(Map<String, String> paraMap) {
		BoardDTO boardDto = boardDao.getnointerDetail(paraMap);
		return boardDto;
	}

}

