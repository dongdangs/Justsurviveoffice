package com.spring.app.bookmark.service;

import java.util.List;

import com.spring.app.users.domain.BookMarkDTO;

public interface BookmarkService {

    // 북마크 추가
	void addBookmark(String fk_id, Long fk_boardNo);

    // 북마크 삭제
	long removeBookmark(String fk_id, Long fk_boardNo);

	boolean toggleBookmark(String fk_id, Long fk_boardNo);

	//북마크리스트
	List<BookMarkDTO> getUserBookmarks(String fk_id);

	boolean isBookmarked(String fk_id, Long fk_boardNo);


    
}