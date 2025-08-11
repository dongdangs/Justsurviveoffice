package com.spring.app.begin.model;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

import com.spring.app.begin.domain.BeginDTO;

@Repository
public class BeginDAO_imple implements BeginDAO {
	
	private final SqlSessionTemplate sql;
	
	public BeginDAO_imple(@Qualifier("sqlsession") SqlSessionTemplate sql) {
		this.sql = sql;
	}
	
	
	// 간단 select
	@Override
	public List<BeginDTO> select() {
		List<BeginDTO> begindtoList = sql.selectList("begin.select");
		return begindtoList;
	}
	
}
