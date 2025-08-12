package com.spring.app.service;

import com.spring.app.entity.Users;
import com.spring.app.users.domain.UsersDTO;

public interface UserService {

	
	//  회원 수정 하기
	public Users updateUser(UsersDTO dto);

	//이메일 중복
	public boolean isEmailDuplicated(String email, String myId);
	
	

		
}
