package com.spring.app.opendata.service;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.spring.app.opendata.domain.Seoul_bicycle_rental_DTO;
import com.spring.app.opendata.model.OpendataDAO;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor  // @RequiredArgsConstructor는 Lombok 라이브러리에서 제공하는 애너테이션으로, final 필드 또는 @NonNull이 붙은 필드에 대해 생성자를 자동으로 생성해준다. 
public class OpendataService_imple implements OpendataService {

  /*
	@Autowired  // Type에 따라 알아서 Bean 을 주입해준다.
	private OpendataDAO dao;
	// Type 에 따라 Spring 컨테이너가 알아서 bean 으로 등록된 com.spring.app.opendata.model.OpendataDAO_imple 의 bean 을 dao 에 주입시켜준다. 
    // 그러므로 dao 는 null 이 아니다.
  */
	
  /*	
	private final OpendataDAO dao;
	
	public OpendataService_imple(OpendataDAO dao) {
		this.dao = dao;
	}
  */
	private final OpendataDAO dao;
	
	
	// === 서울따릉이 오라클 입력 하기 === //
	@Override
	public int insert_seoul_bicycle_rental(Seoul_bicycle_rental_DTO vo) {
		int n = dao.insert_seoul_bicycle_rental(vo);
		return n;
	}	
	
	
	// === 서울따릉이 오라클 조회 하기 === //
	@Override
	public List<Map<String, String>> select_seoul_bicycle_rental() {
		List<Map<String, String>> mapList = dao.select_seoul_bicycle_rental();
		return mapList;
	}
	
}
