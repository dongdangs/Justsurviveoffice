package com.spring.app.users.service;

import java.io.UnsupportedEncodingException;
import java.security.GeneralSecurityException;
import java.security.NoSuchAlgorithmException;
import java.util.NoSuchElementException;
import java.util.Optional;

import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.stereotype.Service;

import com.spring.app.common.AES256;

import com.spring.app.common.SecretMyKey;

import com.spring.app.common.Sha256;
import com.spring.app.entity.LoginHistory;
import com.spring.app.entity.Users;
import com.spring.app.model.HistoryRepository;
import com.spring.app.model.UsersRepository;
import com.spring.app.users.domain.LoginHistoryDTO;
import com.spring.app.users.domain.UsersDTO;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class UsersService_imple implements UsersService {

	private final UsersRepository usersRepository;
	private final HistoryRepository historyRepository;

	private AES256 aes;

		
	@Override
	public UsersDTO getUser(String id, String Pwd) {
		
		UsersDTO usersDto = null;
		
		try {
			Optional<Users> user = usersRepository.findById(id);
/*			Java8에서는 Optional<T> 클래스를 사용해 NullPointerException 을 방지할 수 있도록 도와준다. 
        	Optional<T>는 null이 올 수 있는 값을 감싸는 Wrapper 클래스 이므로, 참조하더라도 NullPointerException 이 발생하지 않도록 도와준다. 
        	Optional 클래스는 null 이더라도 바로 NullPointerException 이 발생하지 않으며, 클래스이기 때문에 각종 메소드를 제공해준다. */
			Users users = user.get();
			// java.util.Optional.get() 은 값이 존재하면 값을 리턴시켜주고, 값이 없으면 NoSuchElementException 을 유발시켜준다.
			
			
				try {
					usersDto = users.toDTO();
					System.out.println(usersDto.getId());
					System.out.println(Sha256.encrypt(Pwd));
					// usersDto.setPassword(Sha256.encrypt(Pwd));
				} catch (Exception e) {	
					e.printStackTrace();
				}
			
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
		try {
			
			aes = new AES256(SecretMyKey.KEY);
			user.setMobile(aes.encrypt(user.getMobile()));
			user.setEmail(aes.encrypt(user.getEmail()));
			user.setPassword(Sha256.encrypt(user.getPassword()));
			
		} catch (Exception e) {
			e.printStackTrace();
		}
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
		
		@Override
		public Users toEntity(UsersDTO userDto) {
		    return Users.builder()
		            .id(userDto.getId())
		            .password(userDto.getPassword())
		            .build();
		}

		 /* 250818 GIT 김예준 오후 14:00 git 업데이트 전 시작 v1*/
		 @Override
		 public void saveLoginHistory(LoginHistoryDTO loginHistoryDTO) {
		        LoginHistory loginHistory = LoginHistory.builder()
							                .lastLogin(loginHistoryDTO.getLastLogin())
							                .ip(loginHistoryDTO.getIp())
							                .users(loginHistoryDTO.getUsers())
							                .build();

		        historyRepository.save(loginHistory);
		   }
		  /* 250818 GIT 김예준 오후 14:00 git 업데이트 전 끝 v1*/

		  @Override
		  public UsersDTO getIdFind(String name, String email) {
		        return usersRepository.findByNameAndEmail(name.trim(), email.trim())
		                .map(Users::toDTO) // Users 엔티티에 toDTO() 있다고 가정
		                .orElse(null);
		 }

	
}
