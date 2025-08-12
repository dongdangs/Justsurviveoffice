package com.spring.app.service;

import com.spring.app.entity.Users;

public interface UserService {

	
	//  회원 수정 하기
	public Users updateUser(Users users);
	
	//이메일 중복
	public boolean isEmailDuplicated(String email);

	// 회원 탈퇴하기
	public int delete(String id);


	
	

		
}
