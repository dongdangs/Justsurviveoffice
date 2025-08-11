package com.spring.app.model;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.spring.app.entity.Member;

//Spring Data JPA는 "JpaRepository"라는 기능을 사용하면 매우 간단히 데이터를 입력,수정,삭제,검색을 할 수 있게 해준다.

//JpaRepository 인터페이스는 org.springframework.data.jpa.repository 패키지의 "JpaRepository"라는 인터페이스를 상속하여 만든다. 
//아래와 같이 만든다.
//public interface 인터페이스이름 extends JpaRepository <엔티티클래스명, ID필트타입>

//클래스의 선언 앞에 "@Repository"라는 어노테이션이 붙여져 있다. 
//그러면 이 인터페이스가 JpaRepository임을 나타낸다. 스프링레거시 에서는 반드시 @Repository 어노테이션을 붙여 두어야 한다.
//그런데 스프링부트 에서는 @Repository 를 생략해도 가능하다.
// @Repository
public interface MemberRepository extends JpaRepository<Member, String> {
	
	/*
		MemberRepository 를 이용해 엔티티클래스명의 테이블(tbl_member)에 SQL문장 없이 CRUD 작업이 되어진다. 
		JpaRepository 는 아래와 같은 내장된 쿼리메소드를 사용하여 CRUD 작업이 되어진다.
		
		- insert 작업 : save(엔티티 객체) 
		- select 작업 : findAll(), findById(키 타입)
		- update 작업 : save(엔티티 객체) 
		- delete 작업 : deleteById(키 타입) 
		   
		특이하게도 insert와 update 작업에는 동일한 메서드인 save()를 이용하는데 
		그 이유는 JPA의 구현체가 메모리상(엔티티들을 관리해주는 Entity Manager 가 메모리에 올라감)에서 
		엔티티 객체(행)가 없다면 insert, 엔티티 객체(행)가 존재한다면 update 를 동작시키는 방식으로 실행되기 때문이다.
	 */
	
	// === 쿼리메소드 생성하기 ===
	// !!! findBy 다음에 붙는 것은 필드명이지 컬럼명이 아니다. !!!
	// userName 으로 조회
	
	// select user_id, user_name, user_pwd, gender, reg_date from tbl_member where user_name = 'King';
	List<Member> findByUserName(String userName);
	
	// select user_id, user_name, user_pwd, gender, reg_date from tbl_member where user_name != 'King';
	List<Member> findByUserNameNot(String userName);
	
	// select user_id, user_name, user_pwd, gender, reg_date from tbl_member where user_name like 'K%';
	List<Member> findByUserNameStartingWith(String prefix);
	
	// select user_id, user_name, user_pwd, gender, reg_date from tbl_member where user_name like '%g'; 
	List<Member> findByUserNameEndingWith(String suffix);
	
	// select user_id, user_name, user_pwd, gender, reg_date from tbl_member where user_name like '%in%';
	List<Member> findByUserNameContaining(String word);
	
	// select user_id, user_name, user_pwd, gender, reg_date from tbl_member where lower(user_name) like lower('K')||'%';
	// Spring Data JPA의 쿼리 메서드 이름만으로는 LOWER() 함수 사용이 불가능하다.
	// 따라서 이 경우는 @Query를 사용하는 방식이 필요하다.
	@Query(value = "select user_id, user_name, user_pwd, gender, reg_date from tbl_member where lower(user_name) like lower(:prefix)||'%'"
		  ,nativeQuery = true)	// nativeQuery : false 이면 JPQL, true 이면 SQL, 기본 false
	List<Member> findByUserNameStartingWithIgnoreCase(@Param("prefix") String prefix);
	
	
	// select user_id, user_name, user_pwd, gender, reg_date from tbl_member where user_name > 'King';
	List<Member> findByUserNameGreaterThan(String userName);
	
	// select user_id, user_name, user_pwd, gender, reg_date from tbl_member where user_name >= 'King';
	List<Member> findByUserNameGreaterThanEqual(String userName);
	
	// select user_id, user_name, user_pwd, gender, reg_date from tbl_member where user_name < 'King';
	List<Member> findByUserNameLessThan(String userName);
	
	// select user_id, user_name, user_pwd, gender, reg_date from tbl_member where user_name <= 'King';
	List<Member> findByUserNameLessThanEqual(String userName);
	
	// select user_id, user_name, user_pwd, gender, reg_date from tbl_member where gender = 2;
	List<Member> findByGender(Integer gender);
	
	// select user_id, user_name, user_pwd, gender, reg_date from tbl_member where user_name = 'King' and gender = 1;
	List<Member> findByUserNameAndGender(String userName, Integer gender);
	
	// select user_id, user_name, user_pwd, gender, reg_date from tbl_member where user_name like '%in%' and gender = 1;
	List<Member> findByUserNameContainingAndGender(String userName, Integer gender);
	
	// select user_id, user_name, user_pwd, gender, reg_date from tbl_member where lower(user_name) like '%'||lower('iN')||'%' and gender = 1;
	@Query(value = "select user_id, user_name, user_pwd, gender, reg_date from tbl_member where lower(user_name) like '%'||lower(:userName)||'%' and gender = :gender"
		  ,nativeQuery = true)
	List<Member> findByUserNameContainingIgnoreCaseAndGender(@Param("userName")String userName, @Param("gender")Integer gender);
	
	// select user_id, user_name, user_pwd, gender, reg_date from tbl_member where user_name = 'King' or gender = 2;
	List<Member> findByUserNameOrGender(String userName, Integer gender);
	
	// select user_id, user_name, user_pwd, gender, reg_date from tbl_member where user_name in ('King', 'Lee');
	List<Member> findByUserNameIn(List<String> names);
	// 서비스단에서 호출하는 방법 : List<Member> members = memberRepository.findByUserNameIn(Arrays.asList("King", "Lee"));
	
}
