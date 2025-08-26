package com.spring.app.rdg.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.spring.app.users.domain.BoardDTO;

@Mapper
public interface RdgMapper {
	
	// 글쓰기 버튼 클릭 메소드
	void add(BoardDTO boardDto);
	
	// 카테고리별 페이징 처리된 검색된 리스트 목록 가져오기(페이지당 3개의 목록 고정)
	List<BoardDTO> getBoardList(Map<String, String> paraMap);
	
	// 해당 카테고리 검색된 게시글의 총 개수
	int getBoardCount(Map<String, String> paraMap);
	
	// 해당 카테고리 제목 + 내용 가져오기
	List<BoardDTO> getBoardContents(String fk_categoryNo);
	
	// 자동 검색어 완성시킬 제목 or 이름 가져오기
	List<String> getSearchWordList(Map<String, String> paraMap);
	
	// 글 1개 가져오기
	BoardDTO selectView(Map<String, String> paraMap);
	
	// 글 삭제하기
	int delete(Map<String, String> paraMap);

}
