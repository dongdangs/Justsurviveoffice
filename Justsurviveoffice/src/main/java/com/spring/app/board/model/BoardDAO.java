package com.spring.app.board.model;

import java.util.List;
import java.util.Map;

public interface BoardDAO {

	// '금쪽이' 게시판 리스트
	List<Map<String, String>> nointerList();

}
