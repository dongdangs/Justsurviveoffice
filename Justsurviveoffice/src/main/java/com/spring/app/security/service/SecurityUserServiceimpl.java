package com.spring.app.security.service;

import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.spring.app.security.mapper.SecurityMapper;
import com.spring.app.users.domain.UsersDTO;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class SecurityUserServiceimpl implements UserDetailsService  {
	
	private final SecurityMapper securityMapper;
	 
//	private final PasswordEncoder passwordEncoder;
	
	@Override
	public UserDetails loadUserByUsername(String id) throws UsernameNotFoundException {
		
		UsersDTO user = securityMapper.findById(id);	// DB에서 사용자조회
		
		if(user == null) {
			throw new UsernameNotFoundException("사용자를 찾을 수 없습니다: " + id);
		}
		
		return User.withUsername(user.getId())
				.password(user.getPassword())   // DB에 저장된 BCrypt 암호
				.roles(user.getRole())          // 예: "ADMIN", "USER"
				.build();
	}

}
