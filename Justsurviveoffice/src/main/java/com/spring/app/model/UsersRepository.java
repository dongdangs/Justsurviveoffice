package com.spring.app.model;


import org.springframework.data.jpa.repository.JpaRepository;

import com.spring.app.entity.Users;

public interface UsersRepository extends JpaRepository<Users, String> {

    // 이메일 중복확인
	 boolean existsByEmail(String email);
	
}