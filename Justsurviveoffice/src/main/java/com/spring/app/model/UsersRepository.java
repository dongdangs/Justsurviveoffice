package com.spring.app.model;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.spring.app.entity.Users;

public interface UsersRepository extends JpaRepository<Users, String> {

    // 이메일 중복 체크/조회에 편리
    Optional<Users> findByEmail(String email);
    boolean existsByEmail(String email);

    // 삭제되지 않은 활성 사용자만 찾고 싶을 때
    @Query("select u from Users u where u.id = :id and u.isDeleted = 0")
    Optional<Users> findActiveById(@Param("id") String id);
}