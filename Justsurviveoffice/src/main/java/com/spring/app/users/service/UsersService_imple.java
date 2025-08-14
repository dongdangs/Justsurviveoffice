package com.spring.app.users.service;

import java.util.NoSuchElementException;
import java.util.Optional;

import org.springframework.stereotype.Service;

import com.spring.app.common.Sha256;
import com.spring.app.entity.Users;
import com.spring.app.model.UsersRepository;
import com.spring.app.users.domain.UsersDTO;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class UsersService_imple implements UsersService {

	private final UsersRepository usersRepository;
		
	@Override
	public UsersDTO getUser(String id) {
		
		UsersDTO usersDto = null;
		
		try {
			Optional<Users> user = usersRepository.findById(id);
/*			Java8에서는 Optional<T> 클래스를 사용해 NullPointerException 을 방지할 수 있도록 도와준다. 
        	Optional<T>는 null이 올 수 있는 값을 감싸는 Wrapper 클래스 이므로, 참조하더라도 NullPointerException 이 발생하지 않도록 도와준다. 
        	Optional 클래스는 null 이더라도 바로 NullPointerException 이 발생하지 않으며, 클래스이기 때문에 각종 메소드를 제공해준다. */
			Users users = user.get();
			// java.util.Optional.get() 은 값이 존재하면 값을 리턴시켜주고, 값이 없으면 NoSuchElementException 을 유발시켜준다.
			
			usersDto = users.toDTO();
			
		} catch(NoSuchElementException e) {
			// member.get() 에서 데이터가 존재하지 않는 경우
		}
		return usersDto;
	}

	
	// 아이디 중복 체크
	@Override
	public boolean isIdExists(String id) {
		return usersRepository.existsById(id);
	}


	// 이메일 중복 체크
	@Override
	public boolean isEmailExists(String email) {
		return usersRepository.existsByEmail(email);
	}


	// 회원가입
	@Override
	public void registerUser(Users user) {
		usersRepository.save(user);  // JPA가 DB에 저장해줌
	}


	// 유저 존재 여부 확인
	@Override
	public Users findByIdAndEmail(String id, String email) {
		return usersRepository.findByIdAndEmail(id, email);
	}


	// 비밀번호 업데이트
	@Override
	public void updatePassword(String id, String newPassword) {
		
		Users user = usersRepository.findById(id).orElseThrow(() -> new RuntimeException("사용자를 찾을 수 없습니다."));
		user.setPassword(Sha256.encrypt(newPassword));
		usersRepository.save(user);
	}


}
