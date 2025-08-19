package com.spring.app.users.service;

import com.spring.app.entity.Users;
import com.spring.app.users.domain.LoginHistoryDTO;
import com.spring.app.users.domain.UsersDTO;

public interface UsersService {

	// 로그인
	UsersDTO getUser(String id, String Pwd);

	// 아이디 중복 체크
	boolean isIdExists(String id);

	// 이메일 존재 여부
	boolean isEmailExists(String email);
	
	//이메일 중복
	public boolean isEmailDuplicated(String email);
	
	// 회원가입
	void registerUser(Users user);

	// 유저 존재 여부 확인
	Users findByIdAndEmail(String id, String email);

	// 비밀번호 업데이트
	void updatePassword(String id, String newPassword);
	


	//  회원 수정 하기
	public UsersDTO updateUser(UsersDTO userDto);

	// 회원 탈퇴하기
	public int delete(String id);
	
	// loginHistory의 user엔티티 생성용 메소드
	Users toEntity(UsersDTO userDto);

	// 로그인 기록 남기기
	void saveLoginHistory(LoginHistoryDTO loginHistoryDTO);

	UsersDTO getIdFind(String name, String email);

	//휴면상태로 업데이트 (비밀번호 변경대상)
	boolean updateDormantStatus(String id);


}
