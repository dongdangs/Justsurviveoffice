package com.spring.app.rdg.service;

import java.util.List;
import java.util.Map;

import com.spring.app.users.domain.BoardDTO;

public interface RdgService {
	
	// 이 서비스에서 제공하는 기능의 계약(명세)
	
	// 글쓰기 버튼 클릭 메소드
	void add(BoardDTO boardDto, String path);
	
	// 카테고리별 페이징 처리된 검색된 리스트 목록 가져오기(페이지당 3개의 목록 고정)
	List<BoardDTO> getBoardList(Map<String, String> paraMap);
	
	// 해당 카테고리 검색된 게시글의 총 개수
	int getBoardCount(Map<String, String> paraMap);
	
	// 키워드 관련 로직 구현
	List<Map.Entry<String,Integer>> getKeyWord(String fk_categoryNo);
	
	// 자동 검색어 완성시키기
	List<Map<String, String>> getSearchWordList(Map<String, String> paraMap);
	
	// 글 1개 가져오기
	BoardDTO selectView(Map<String, String> paraMap);
	
}
