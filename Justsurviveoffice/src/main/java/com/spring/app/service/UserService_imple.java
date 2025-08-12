package com.spring.app.service;

import java.util.NoSuchElementException;
import java.util.Optional;

import org.springframework.stereotype.Service;

import com.spring.app.entity.Users;
import com.spring.app.model.UsersRepository;
import com.spring.app.users.domain.UsersDTO;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class UserService_imple implements UserService {

	private final UsersRepository usersRepository;

	//회원 수정하기
	@Override
	public Users updateUser(UsersDTO dto) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public boolean isEmailDuplicated(String email, String myId) {
		// TODO Auto-generated method stub
		return false;
	}

	
	
	
	

}
