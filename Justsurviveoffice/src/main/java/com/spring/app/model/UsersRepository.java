package com.spring.app.model;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import com.spring.app.entity.Users;

// Spring Data JPA는 "JpaRepository"라는 기능을 사용하면 매우 간단히 데이터를 입력,수정,삭제,검색을 할 수 있게 해준다.

// JpaRepository 인터페이스는 org.springframework.data.jpa.repository 패키지의 "JpaRepository"라는 인터페이스를 상속하여 만든다. 
// 아래와 같이 만든다.
// public interface 인터페이스이름 extends JpaRepository <엔티티클래스명, ID필트타입>

// 클래스의 선언 앞에 "@Repository"라는 어노테이션이 붙여져 있다. 
// 그러면 이 인터페이스가 JpaRepository임을 나타낸다. 스프링레거시 에서는 반드시 @Repository 어노테이션을 붙여 두어야 한다.
// 그런데 스프링부트 에서는 @Repository 를 생략해도 가능하다.
// @Repository
public interface UsersRepository extends JpaRepository<Users, String> { // String 이라고 쓴 이유는 Member 엔티티 클래스에 @ID 로 사용되는 userId 필드의 타입이 String 이기 때문이다. 
 /*		- insert 작업 : save(엔티티 객체) 
		- select 작업 : findAll(), findById(키 타입)
		- update 작업 : save(엔티티 객체) 
		- delete 작업 : deleteById(키 타입) 
		
		insert와 update 작업에는 save()를 이용하기.
		객체(행)이 없을 시 insert, 
		해당 객체가 존재한다면 update   		*/	

	// 아이디 중복 체크
	boolean existsById(String id);

	// 이메일 중복 체크
	boolean existsByEmail(String email);

	Optional<Users> findByNameAndEmail(String name, String email);

	// 비밀번호 찾기
	Users findByIdAndEmail(String id, String email);

	
	
	
}

