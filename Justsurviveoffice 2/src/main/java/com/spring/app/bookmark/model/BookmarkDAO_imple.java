package com.spring.app.bookmark.model;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import com.spring.app.users.domain.BookMarkDTO;

import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class BookmarkDAO_imple implements BookmarkDAO{
	
    private final SqlSessionTemplate sqlsession;

    

    // 북마크 추가 
    @Override
    public int addBookmark(String fk_id, Long fk_boardNo) {
        Map<String, Object> paramMap = new HashMap<>();
        paramMap.put("fk_id", fk_id);
        paramMap.put("fk_boardNo", fk_boardNo);
        return sqlsession.insert("bookmark.addBookmark", paramMap);
    }

    // 북마크 삭제 
    @Override
    public int removeBookmark(String fk_id, Long fk_boardNo) {
        Map<String, Object> paramMap = new HashMap<>();
        paramMap.put("fk_id", fk_id);
        paramMap.put("fk_boardNo", fk_boardNo);
        return sqlsession.delete("bookmark.removeBookmark", paramMap);
    }

    //북마크 여부 체크 
    @Override
    public int checkBookmark(String fk_id, Long fk_boardNo) {
        Map<String, Object> paramMap = new HashMap<>();
        paramMap.put("fk_id", fk_id);
        paramMap.put("fk_boardNo", fk_boardNo);
        return sqlsession.selectOne("bookmark.checkBookmark", paramMap);
    }

    // 북마크 목록 조회 
    @Override
    public List<BookMarkDTO> getUserBookmarks(String fk_id) {
        return sqlsession.selectList("bookmark.getUserBookmarks", fk_id);
    }

}
