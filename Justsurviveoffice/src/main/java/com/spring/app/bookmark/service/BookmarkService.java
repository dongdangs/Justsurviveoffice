package com.spring.app.bookmark.service;

import java.util.List;
import java.util.Map;

import com.spring.app.bookmark.domain.BookMarkDTO;

public interface BookmarkService {

    // 북마크 추가
	int addBookmark(String fk_id, Long fk_boardNo);

    // 북마크 삭제
	int removeBookmark(String fk_id, Long fk_boardNo);

	//북마크리스트
	List<BookMarkDTO> getUserBookmarks(String fk_id);

	boolean isBookmarked(String fk_id, Long fk_boardNo);

	// 마이페이지 북마크 목록 스크롤
	List<BookMarkDTO> bookmarkScroll(Map<String, Object> paramMap);


    
}