package com.spring.app.users.service;

import com.spring.app.entity.Users;
import com.spring.app.users.domain.UsersDTO;

public interface UsersService {

	// 로그인
	UsersDTO getUser(String id);

	// 아이디 중복 체크
	boolean isIdExists(String id);

	// 이메일 중복 체크
	boolean isEmailExists(String email);

	// 회원가입
	void registerUser(Users user);

}
