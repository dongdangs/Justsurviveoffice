package com.spring.app.opendata.model;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import com.spring.app.opendata.domain.Seoul_bicycle_rental_DTO;

import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor  // @RequiredArgsConstructor는 Lombok 라이브러리에서 제공하는 애너테이션으로, final 필드 또는 @NonNull이 붙은 필드에 대해 생성자를 자동으로 생성해준다. 
public class OpendataDAO_imple implements OpendataDAO {

 /*	
	@Autowired
	@Qualifier("sqlsession")
	private SqlSessionTemplate sqlsession;
	// com.spring.app.config.Datasource_mymvcuser_Configuration 클래스에서 SqlSessionTemplate 클래스의 bean 이름이 sqlsession 인 bean을 주입하라는 뜻이다. 
	// 그러므로 sqlsession 는 null 이 아니다.
 */
 
 /*	
	private final SqlSessionTemplate sqlsession;
	
	public OpendataDAO_imple(@Qualifier("sqlsession") SqlSessionTemplate sqlsession) {
		this.sqlsession = sqlsession;
	}
 */
	private final SqlSessionTemplate sqlsession;
	
	// === 서울따릉이 오라클 입력 하기 === //
	@Override
	public int insert_seoul_bicycle_rental(Seoul_bicycle_rental_DTO vo) {
		int n = sqlsession.insert("opendata.insert_seoul_bicycle_rental", vo); 
		return n;
	}
	
	// === 서울따릉이 오라클 조회 하기 === //
	@Override
	public List<Map<String, String>> select_seoul_bicycle_rental() {
		List<Map<String, String>> mapList = sqlsession.selectList("opendata.select_seoul_bicycle_rental");
		return mapList;
	}
	
}
