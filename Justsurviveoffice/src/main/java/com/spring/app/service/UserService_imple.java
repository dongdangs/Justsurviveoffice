package com.spring.app.service;


import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.stereotype.Service;

import com.spring.app.entity.Users;
import com.spring.app.model.UsersRepository;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class UserService_imple implements UserService {

	private final UsersRepository usersRepository;

	//회원 수정하기
	@Override
	public Users updateUser(Users users) {
		Users user = usersRepository.save(users);
		return user;
		
	}

	//이메일 중복확인
	@Override
	public boolean isEmailDuplicated(String email) {
        return usersRepository.existsByEmail(email);
	}

	//회원탈퇴하기
	@Override
	public int delete(String id) {
		
		int n = 0;
		
		try {
			usersRepository.deleteById(id);
			
			n = 1;
		} catch (EmptyResultDataAccessException e) {
			
		}
			
		return n;
	}

	
	
	
	

}
