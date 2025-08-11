package com.spring.app.service;

import java.util.List;
import java.util.Map;

import com.spring.app.domain.MemberDTO;
import com.spring.app.entity.Member;

public interface MemberService {

	// 특정 회원 1명 읽어오기
	public MemberDTO getMember(String userId);
	
	// 모든 회원 읽어오기
	public List<MemberDTO> getAllMember();
	
	// 회원 입력 또는 회원 수정 하기
	public Member registerMember(Member member);
	
	// 회원 1명 삭제하기
	public int delete(String userId);
	
	// 회원검색(쿼리메소드)
	public List<MemberDTO> searchQueryMethod(Map<String, String> paraMap);
	
	// 회원검색(쿼리DSL)
	public List<MemberDTO> searchQueryDSL_1(Map<String, String> paraMap);
	
	// 회원검색(쿼리DSL)
	// 동적 조건으로 분기 처리해주는 QueryDSL 전용의 SQL 조건 표현 객체인 BooleanExpression 사용하여 처리하기
	public List<MemberDTO> searchQueryDSL_2(Map<String, String> paraMap);
	
	
}
