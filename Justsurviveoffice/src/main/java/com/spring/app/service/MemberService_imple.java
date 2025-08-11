package com.spring.app.service;

import static com.spring.app.entity.QMember.member;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.NoSuchElementException;
import java.util.Optional;
import java.util.stream.Collectors;

import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.stereotype.Service;

import com.querydsl.core.types.dsl.BooleanExpression;
import com.querydsl.core.types.dsl.Expressions;
import com.querydsl.jpa.impl.JPAQueryFactory;
import com.spring.app.domain.MemberDTO;
import com.spring.app.entity.Member;
import com.spring.app.model.MemberRepository;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class MemberService_imple implements MemberService {
	
	private final MemberRepository memberRepository;
	
	// 특정 회원 1명 읽어오기
	@Override
	public MemberDTO getMember(String userId) {
		
		MemberDTO mbrDto = null;
		
		try {
			Optional<Member> member = memberRepository.findById(userId);
			/*
				Java8에서는 Optional<T> 클래스를 사용해 NullPointerException 을 방지할 수 있도록 도와준다. 
				Optional<T>는 null이 올 수 있는 값을 감싸는 Wrapper 클래스 이므로, 참조하더라도 NullPointerException 이 발생하지 않도록 도와준다. 
				Optional 클래스는 null 이더라도 바로 NullPointerException 이 발생하지 않으며, 클래스이기 때문에 각종 메소드를 제공해준다. 
			*/		
			
			Member mbr = member.get();
			// java.util.Optional.get() 은 값이 존재하면 값을 리턴시켜주고, 값이 없으면 NoSuchElementException 을 유발시켜준다.
			
			mbrDto = mbr.toDTO();
			
		} catch (NoSuchElementException e) {
			// member.get() 에서 데이터가 존재하지 않는 경우
		}
		
		return mbrDto;
	}
	
	
	// 모든 회원 읽어오기
	@Override
	public List<MemberDTO> getAllMember() {
		
		List<MemberDTO> memberDtoList = new ArrayList<>();
		
		List<Member> members = memberRepository.findAll();
		
	/*	
		for(Member mbr : members) {
			memberDtoList.add(mbr.toDTO());
		}// end ofo for------------------
	*/	
		// 또는
		memberDtoList = members.stream()
							   .map(Member::toDTO)
							   .collect(Collectors.toList());
		
		return memberDtoList;
	}
	
	
	// 회원 입력 또는 회원 수정 하기
	@Override
	public Member registerMember(Member member) {
		Member mbr = memberRepository.save(member);	// save(엔티티) 쿼리메소드의 리턴타입은 저장된(또는 업데이트된) 엔티티 객체를 리턴해준다.
		return mbr;
	}
	
	
	// 회원 1명 삭제하기
	@Override
	public int delete(String userId) {
		
		int n = 0;
		
		try {
			memberRepository.deleteById(userId);	// 해당 ID의 Entity가 존재하면 삭제한다.
													// 존재하지 않으면 EmptyResultDataAccessException 예외가 발생할 수 있다.
													// 리턴 타입은 void 이다.
			n = 1;
		} catch (EmptyResultDataAccessException e) {
			n = 0;
		}
		
		return n;
	}
	
	
	// 회원검색(쿼리메소드)
	@Override
	public List<MemberDTO> searchQueryMethod(Map<String, String> paraMap) {
		
		List<MemberDTO> memberDtoList = new ArrayList<>();
		
		String userName = paraMap.get("userName");
		String gender = paraMap.get("gender");
		
		List<Member> members = null;
		
		if((userName != null && !userName.trim().isEmpty()) 
		   && 
		   (gender != null && !gender.trim().isEmpty())) {
			// 회원명 및 성별 검색
			
		//	members = memberRepository.findByUserNameAndGender(userName, Integer.parseInt(gender));	// 회원명 전체일치
		//	members = memberRepository.findByUserNameContainingAndGender(userName, Integer.parseInt(gender));	// 회원명 일부만 일치
			members = memberRepository.findByUserNameContainingIgnoreCaseAndGender(userName, Integer.parseInt(gender));	// 회원명 대, 소문자 구분 없이 일부만 일치
			
		}
		
		else if((userName != null && !userName.trim().isEmpty()) 
				&& 
				(gender == null || gender.trim().isEmpty())) {
			//  회원명 검색
			
		//	members = memberRepository.findByUserName(userName); // 회원명 전체일치
			members = memberRepository.findByUserNameContaining(userName); // 회원명 일부만 일치
		}
		
		else if((userName == null || userName.trim().isEmpty()) 
				&& 
				(gender != null && !gender.trim().isEmpty())) {
			//  성별 검색
			members = memberRepository.findByGender(Integer.parseInt(gender));
		}
		
		else {
			// 전체조회
			members = memberRepository.findAll();
		}
		
	/*	
		for(Member mbr : members) {
			memberDtoList.add(mbr.toDTO());
		}
	*/	
		// 또는
		
		memberDtoList = members.stream()
							   .map(Member::toDTO)
							   .collect(Collectors.toList());
		
		return memberDtoList;
	}
	
	
	// 회원검색하기 [ Query DSL(Domain Specific Language) 를 사용하여 구하기 ]
	/*
		QueryDSL은 Java 기반의 오픈 소스 프레임워크로, JPQL (Java Persistence Query Language)을 Java 코드로 작성할 수 있도록 해준다. 
		즉, SQL이나 JPQL과 같은 데이터베이스 쿼리를 자바 코드로 작성하여, 타입 안정성과 코드 가독성을 높여준다.  
		
		1. 특정 조건으로 조회하기 (WHERE)
			      
		같다:       .eq()
		크거나 같다: .goe()
		작거나 같다: .loe()
		크다:      .gt()
		작다:      .lt()
		포함한다 (LIKE %값%): .contains()
		시작한다 (LIKE 값%):  .startsWith()
		끝난다 (LIKE %값):   .endsWith()
		널(null)이다:       .isNull()
		널(null)이 아니다:   .isNotNull()
		목록 안에 있다 (IN):  .in()
		
		  
		2. 정렬하기 (ORDER BY)
		
		오름차순: .asc()
		내림차순: .desc()
		
		
		3. **일부만 가져오기 (LIMIT/OFFSET 또는 페이징)
		
		시작점 지정:     .offset()
		가져올 개수 지정: .limit()
		
		
		4. **그룹화 및 집계 함수 (GROUP BY, COUNT, SUM, AVG 등)
		
		그룹화:    .groupBy()
		개수 세기: .count()
		합계:     .sum()
		평균:     .avg()
		최대값:   .max()
		최소값:   .min()
		
		
		5. **조건이 여러 개일 때 (AND, OR)
		
		AND 조건: .and()
		OR 조건:  .or()
	*/
	
	private final JPAQueryFactory jPAQueryFactory;
	
	@Override
	public List<MemberDTO> searchQueryDSL_1(Map<String, String> paraMap) {
		
		List<MemberDTO> memberDtoList = new ArrayList<>();
		
		String userName = paraMap.get("userName");
		String gender = paraMap.get("gender");
		
		List<Member> members = null;
		
		if((userName != null && !userName.trim().isEmpty()) 
		   && 
		   (gender != null && !gender.trim().isEmpty())) {
			// 회원명 및 성별 검색
			
			members = jPAQueryFactory
						.selectFrom(member)	// 위에서 import static com.spring.app.entity.QMember.member; 해야 함.
					//	.where(member.userName.eq(userName))					// 회원명 전체일지
					//	.where(member.userName.contains(userName))				// 회원명 일부만 일치
						.where(member.userName.containsIgnoreCase(userName),	// 회원명 대.소문자 구분없이 일부만 일치
							   member.gender.eq(Integer.parseInt(gender)))
						.fetch();
		}
		
		else if((userName != null && !userName.trim().isEmpty()) 
				&& 
				(gender == null || gender.trim().isEmpty())) {
			//  회원명 검색
			
			members = jPAQueryFactory
					.selectFrom(member)	// 위에서 import static com.spring.app.entity.QMember.member; 해야 함.
				//	.where(member.userName.eq(userName))					// 회원명 전체일지
				//	.where(member.userName.contains(userName))				// 회원명 일부만 일치
					.where(member.userName.containsIgnoreCase(userName))	// 회원명 대.소문자 구분없이 일부만 일치
					.fetch();
		}
		
		else if((userName == null || userName.trim().isEmpty()) 
				&& 
				(gender != null && !gender.trim().isEmpty())) {
			//  성별 검색
			members = jPAQueryFactory
					.selectFrom(member)	// 위에서 import static com.spring.app.entity.QMember.member; 해야 함.
					.where(member.gender.eq(Integer.parseInt(gender)))
					.fetch();
		}
		
		else {
			// 전체조회
			members = jPAQueryFactory
					.selectFrom(member)	// 위에서 import static com.spring.app.entity.QMember.member; 해야 함.
					.fetch();
		}
		
		/*	
			for(Member mbr : members) {
				memberDtoList.add(mbr.toDTO());
			}
		*/	
		// 또는
		
		memberDtoList = members.stream()
							   .map(Member::toDTO)
							   .collect(Collectors.toList());
		
		return memberDtoList;
	}
	
	
	// 회원검색하기 [ Query DSL(Domain Specific Language) 를 사용하여 구하기 ] 
	// ==> !!! 동적 조건으로 분기 처리해주는 QueryDSL 전용의 SQL 조건 표현 객체인 BooleanExpression 사용하여 처리하기 !!! <==
	/*
		QueryDSL은 Java 기반의 오픈 소스 프레임워크로, JPQL (Java Persistence Query Language)을 Java 코드로 작성할 수 있도록 해준다. 
		즉, SQL이나 JPQL과 같은 데이터베이스 쿼리를 자바 코드로 작성하여, 타입 안정성과 코드 가독성을 높여준다.  
	*/
	@Override
	public List<MemberDTO> searchQueryDSL_2(Map<String, String> paraMap) {
		
		List<MemberDTO> memberDtoList = new ArrayList<>();
		
		String userName = paraMap.get("userName");
		String gender = paraMap.get("gender");
		
		//   >>> BooleanExpression은 QueryDSL 에서 제공해주는 클래스 이다.
		//       BooleanExpression 클래스는 QueryDSL 전용의 SQL의 WHERE 조건 표현 객체로서 QueryDSL의 .where(), .and(), .or() 에만 사용된다. <<<
		
		BooleanExpression condition = Expressions.TRUE;
		// Expressions.TRUE 라고 준것은 기본 조건 (항상 참)으로 시작해서 조건을 점진적으로 추가한다. 마치 WHERE 1=1 과 같은 뜻이다. 
		
		if(userName != null && !userName.trim().isEmpty()) {
			condition = condition.and(member.userName.containsIgnoreCase(userName));	// 마치 WHERE 1=1 AND userName like '%'||'haNbIn'||'%' 와 같은 것이다.
		}
		
		if(gender != null && !gender.trim().isEmpty()) {
			condition = condition.and(member.gender.eq(Integer.parseInt(gender)));	// 마치 WHERE 1=1 AND userName like '%'||'haNbIn'||'%' AND gender = 1 와 같은 것이다.
		}																			// 또는 마치 WHERE 1=1 AND gender = 1 와 같은 것이다.
		
		List<Member> members = jPAQueryFactory
								.selectFrom(member)
								.where(condition)
								.fetch();
		
		/*	
			for(Member mbr : members) {
				memberDtoList.add(mbr.toDTO());
			}
		*/	
		// 또는
		
		memberDtoList = members.stream()
							   .map(Member::toDTO)
							   .collect(Collectors.toList());
		
		return memberDtoList;
	}

}





