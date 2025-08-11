package com.spring.app.begin.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.spring.app.begin.domain.BeginDTO;
import com.spring.app.begin.model.BeginDAO;

@Service
public class BeginService_imple implements BeginService {
	
	private BeginDAO dao;
	
//	@Autowired
	public BeginService_imple(BeginDAO dao) {
		this.dao = dao;
	}
	
	
	// 간단 select
	@Override
	public List<BeginDTO> select() {
		List<BeginDTO> begindtoList = dao.select();
		return begindtoList;
	}
	
}
