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

	// 유저 존재 여부 확인
	Users findByIdAndEmail(String id, String email);

	// 비밀번호 업데이트
	void updatePassword(String id, String newPassword);

	//  회원 수정 하기
	public Users updateUser(Users users);
	
	//이메일 중복
	public boolean isEmailDuplicated(String email);

	// 회원 탈퇴하기
	public int delete(String id);

	//휴면상태로 업데이트 (비밀번호 변경대상)
	boolean updateDormantStatus(String id);
	

	

}
