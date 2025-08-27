package com.spring.app.admin.model;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import com.spring.app.category.domain.CategoryDTO;
import com.spring.app.entity.Users;

// 클래스의 선언 앞에 "@Repository"라는 어노테이션이 붙여져 있다. 
// 그러면 이 인터페이스가 JpaRepository임을 나타낸다. 스프링레거시 에서는 반드시 @Repository 어노테이션을 붙여 두어야 한다.
// 그런데 스프링부트 에서는 @Repository 를 생략해도 가능하다.
// @Repository
public interface AdminRepository extends JpaRepository<Users, String> {

	// 카테고리별 인원 통계
	@Query(value = "SELECT COALESCE(c.categoryNo, 0) AS categoryNo, " +
            "       COALESCE(c.categoryName, '미분류') AS categoryName, " +
            "       COUNT(*) AS cnt, " +
            "       ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM users), 2) AS percentage " +
            "FROM users u " +
            "LEFT JOIN category c ON u.fk_categoryNo = c.categoryNo " +
            "GROUP BY c.categoryNo, c.categoryname",
            nativeQuery = true)
	List<CategoryDTO> getCategoryChart();
	
}

