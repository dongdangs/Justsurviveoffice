package com.spring.app.board.model;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class BoardDAO_imple implements BoardDAO {
	
	// 의존객체를 생성자 주입(DI : Dependency Injection)
	@Qualifier("sqlsession")
	private final SqlSessionTemplate sql;

	
	// '금쪽이' 게시판 리스트
	@Override
	public List<Map<String, String>> nointerList() {
		List<Map<String, String>> nointerList = sql.selectList("board.nointerList");
		return nointerList;
	}
	
	
	
	

}
