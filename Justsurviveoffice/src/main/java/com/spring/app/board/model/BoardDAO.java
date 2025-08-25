package com.spring.app.board.model;

import java.util.List;
import java.util.Map;

import com.spring.app.users.domain.BoardDTO;

public interface BoardDAO {

	List<Map<String, String>> getBoardList(String fk_categoryNo);

	BoardDTO getView(Map<String, String> paraMap); // 글 1개 조회하기

	int getTotalCount(Map<String, String> paraMap);// 총 개수 조회학;

	// 카테고리 가져오기
	List<Map<String, String>> getIndexList(String fk_categoryNo);

}
