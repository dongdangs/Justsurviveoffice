package com.spring.app.bookmark.service;

import java.util.List;

import org.springframework.stereotype.Service;
import lombok.RequiredArgsConstructor;

import com.spring.app.bookmark.domain.BookMarkDTO;
import com.spring.app.bookmark.model.BookmarkDAO;

@Service
@RequiredArgsConstructor
public class BookmarkService_imple implements BookmarkService {

    private final BookmarkDAO bookMarkDao;

    @Override
    public void addBookmark(String fk_id, Long fk_boardNo) {
    	bookMarkDao.addBookmark(fk_id, fk_boardNo);
    }

    @Override
    public long removeBookmark(String fk_id, Long fk_boardNo) {
        return bookMarkDao.removeBookmark(fk_id, fk_boardNo);
    }


    @Override
    public List<BookMarkDTO> getUserBookmarks(String fk_id) {
        return bookMarkDao.getUserBookmarks(fk_id);
    }

    @Override
    public boolean isBookmarked(String fk_id, Long fk_boardNo) {
        return bookMarkDao.checkBookmark(fk_id, fk_boardNo) > 0;
    }


}