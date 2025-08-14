package com.spring.app.admin.service;

import org.springframework.data.domain.Page;

import com.spring.app.entity.Users;
import com.spring.app.users.domain.UsersDTO;

public interface AdminService {
	
	// 회원목록 전체보기(페이징 처리)
	Page<Users> getPageBoard(String searchType, String searchWord, int currentShowPageNo, int sizePerPage) throws Exception;
	
	// 특정 회원 1명 상세보기
	UsersDTO getUsers(String id);

}
