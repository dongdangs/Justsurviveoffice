package com.spring.app.board.model;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

import com.spring.app.users.domain.BoardDTO;

import lombok.RequiredArgsConstructor;

//=== Repository(DAO) 선언 ===
@Repository
@RequiredArgsConstructor  // @RequiredArgsConstructor는 Lombok 라이브러리에서 제공하는 애너테이션으로, final 필드 또는 @NonNull이 붙은 필드에 대해 생성자를 자동으로 생성해준다.
public class BoardDAO_imple implements BoardDAO {

	// 의존객체를 생성자 주입(DI : Dependency Injection)
	@Qualifier("sqlsession")
	private final SqlSessionTemplate sql;

	@Override
	public List<Map<String, String>> getBoardList() {
		List<Map<String, String>> mapList = sql.selectList("board.getBoardList");
		return mapList;
	}

	@Override
	public BoardDTO getView(Map<String, String> paraMap) {
		BoardDTO boardDTO = sql.selectOne("board.getView", paraMap);
		return boardDTO;
	}

	@Override
	public List<Map<String, String>> PaginationList() {
		List<Map<String, String>> mapList = sql.selectList("board.PaginationList");
		return mapList;
	}
		
		
	
}
