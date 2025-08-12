package com.spring.app.model;

import org.springframework.data.jpa.repository.JpaRepository;

import com.spring.app.entity.Users;

public interface UsersRepository extends JpaRepository<Users, String> {
	
	// 아이디 중복 체크
	boolean existsById(String id);

	// 이메일 중복 체크
	boolean existsByEmail(String email);

}
