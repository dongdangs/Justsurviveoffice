package com.spring.app.opendata.model;

import java.util.List;
import java.util.Map;

import com.spring.app.opendata.domain.Seoul_bicycle_rental_DTO;

public interface OpendataDAO {

	// === 서울따릉이 오라클 입력 하기 === //
	int insert_seoul_bicycle_rental(Seoul_bicycle_rental_DTO vo);	
	
	// === 서울따릉이 오라클 조회 하기 === //
	List<Map<String, String>> select_seoul_bicycle_rental();
	
}
