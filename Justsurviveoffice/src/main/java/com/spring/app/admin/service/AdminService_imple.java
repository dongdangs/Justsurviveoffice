package com.spring.app.admin.service;

import static com.spring.app.entity.QCategory.category;
import static com.spring.app.entity.QUsers.users;

import java.util.List;
import java.util.NoSuchElementException;
import java.util.Optional;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

import com.querydsl.core.types.dsl.BooleanExpression;
import com.querydsl.core.types.dsl.Expressions;
import com.querydsl.jpa.impl.JPAQueryFactory;
import com.spring.app.entity.Users;
import com.spring.app.admin.model.AdminRepository;
import com.spring.app.users.domain.UsersDTO;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor  // @RequiredArgsConstructor는 Lombok 라이브러리에서 제공하는 애너테이션으로, final 필드 또는 @NonNull이 붙은 필드에 대해 생성자를 자동으로 생성해준다.
public class AdminService_imple implements AdminService {
	
	private final AdminRepository adminRepository;
	
	private final JPAQueryFactory jPAQueryFactory;
	
	
	// 회원목록 전체보기(페이징 처리)
	@Override
	public Page<Users> getPageBoard(String searchType, String searchWord, int currentShowPageNo, int sizePerPage) 
			throws Exception {
		
		Page<Users> page = Page.empty();	// 기본값으로 내용이 없는 빈 페이지임. null 아니므로 안전하게 메서드 호출 가능함.
		// 검색 결과가 없을 때, 기본값으로 반환
		
		try {
			Pageable pageable = PageRequest.of(currentShowPageNo - 1, sizePerPage, Sort.by(Sort.Direction.DESC, "num"));
			
			BooleanExpression condition = Expressions.TRUE; 
			
			if("name".equals(searchType) &&
			   (searchWord != null && !searchWord.trim().isEmpty())) {	// 검색대상이 "name" 가 아니거나 검색어가 없거나 공백이라면 해당 조건은 무시됨.
				
				condition = condition.and(users.name.containsIgnoreCase(searchWord));
				// 맨 위에서 import static com.spring.app.entity.QUsers.users; 해야 함.
			}
			
			if("id".equals(searchType) &&
			   (searchWord != null && !searchWord.trim().isEmpty())) {	// 검색대상이 "id" 가 아니거나 검색어가 없거나 공백이라면 해당 조건은 무시됨.
				
				condition = condition.and(users.id.containsIgnoreCase(searchWord));
			}
			
			if("email".equals(searchType) &&
			   (searchWord != null && !searchWord.trim().isEmpty())) {	// 검색대상이 "email" 가 아니거나 검색어가 없거나 공백이라면 해당 조건은 무시됨.
				
				condition = condition.and(users.email.containsIgnoreCase(searchWord));
			}
			
			if("categoryName".equals(searchType) &&
			   (searchWord != null && !searchWord.trim().isEmpty())) {	// 검색대상이 "categoryName" 가 아니거나 검색어가 없거나 공백이라면 해당 조건은 무시됨.
				
				condition = condition.and(category.categoryName.containsIgnoreCase(searchWord));
				// 맨 위에서 import static com.spring.app.entity.QCategory.category; 해야 함. 
			}
			
			List<Users> userss = jPAQueryFactory
					.selectFrom(users)								// Users 엔티티를 기준으로 조회
					.leftJoin(users.category, category).fetchJoin()	// Users와 category를 fetch join 으로 조인 (board.member 는 연관관계 필드)
					.where(condition)								// 조건절 (BooleanExpression 을 사용하여 동적 조건 처리)
					.offset(pageable.getOffset())					// 페이지 시작 위치 (예: 0, 10, 20...).  pageable.getOffset() 은 Spring Data JPA에서 페이징 처리 시 데이터베이스에서 조회를 시작할 위치를 말하는 것이다.       
					.limit(pageable.getPageSize())					// 한 페이지당 데이터 수
					.orderBy(users.name.desc())						// 정렬 기준 지정: name 컬럼 기준 내림차순 
					.fetch();										// 최종적으로 리스트 형태로 결과 반환
			
			// 특정 조건에 맞는 멤버행의 총 개수를 조회
			Long total = jPAQueryFactory
					.select(users.count())
					.from(users)
					.leftJoin(users.category, category)
					.where(condition)
					.fetchOne();	// 단일 결과를 반환한다. count 는 하나의 숫자만 반환되므로 fetchOne()을 사용한다.
			
			page = new PageImpl<>(userss, pageable, total != null ? total : 0);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return page;
	}
	
	
	// 특정 회원 1명 상세보기
	@Override
	public UsersDTO getUsers(String id) {
		
		UsersDTO uDto = null;
		
		try {
			Optional<Users> user = adminRepository.findById(id);
			
			Users us = user.get();
			
			uDto = us.toDTO();
			
		} catch (NoSuchElementException e) {
			// user.get() 에서 데이터가 존재하지 않는 경우
		}
		
		return uDto;
	}
	
	
	
}
