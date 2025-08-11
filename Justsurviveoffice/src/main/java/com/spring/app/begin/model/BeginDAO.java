package com.spring.app.begin.model;

import java.util.List;

import com.spring.app.begin.domain.BeginDTO;

public interface BeginDAO {
	
	// 간단 select
	List<BeginDTO> select();

}
