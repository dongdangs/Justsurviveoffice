package com.spring.app.board.model;

import java.util.List;
import java.util.Map;

import com.spring.app.users.domain.BoardDTO;

public interface BoardDAO {

	List<Map<String, String>> getBoardList();

	BoardDTO getView(Map<String, String> paraMap); // 글 1개 조회하기
	
}
