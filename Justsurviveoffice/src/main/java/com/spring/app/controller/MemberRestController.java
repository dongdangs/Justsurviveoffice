package com.spring.app.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.spring.app.domain.MemberDTO;
import com.spring.app.entity.Member;
import com.spring.app.service.MemberService;

import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/memberInfo/")
@RequiredArgsConstructor
public class MemberRestController {
	
	private final MemberService memberService;
	
	// 모든 회원 읽어오기
	@GetMapping("allMember")
	public List<MemberDTO> allMember() {
		return memberService.getAllMember();
	}
	
	// 특정 회원 1명 읽어오기
	@GetMapping("oneMember")
	public MemberDTO oneMember(@RequestParam(name = "userId") String userId) {
		return memberService.getMember(userId);
	}
	
	// 회원입력 또는 회원수정하기
	@PostMapping("register")
	public Map<String, Member> register(MemberDTO mbrDto) {
		
		Member member = Member.builder()
							  .userId(mbrDto.getUserId())
							  .userName(mbrDto.getUserName())
							  .userPwd(mbrDto.getUserPwd())
							  .gender(mbrDto.getGender())
							  .build();
		
		Member mbr = memberService.registerMember(member);
		
		Map<String, Member> map = new HashMap<>();
		map.put("member", mbr);
		
		return map;
	}
	
	
	// 회원 1명 삭제하기
	@DeleteMapping("delete")
	public Map<String, Integer> delete(@RequestParam(name = "userId") String userId) {
		int n = memberService.delete(userId);
		
		Map<String, Integer> map = new HashMap<>();
		map.put("n", n);
		
		return map;
	}
	
	
	// 회원검색(쿼리메소드)
	@GetMapping("searchQueryMethod")
	public List<MemberDTO> searchQueryMethod(@RequestParam(name = "userName", defaultValue = "") String userName
											,@RequestParam(name = "gender", defaultValue = "") String gender) {
		
		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("userName", userName);
		paraMap.put("gender", gender);
		
		return memberService.searchQueryMethod(paraMap);
	}
	
	
	// 회원검색 [쿼리DSL(Domain Specific Language)]
	/*
		QueryDSL은 Java 기반의 오픈 소스 프레임워크로, JPQL (Java Persistence Query Language)을 Java 코드로 작성할 수 있도록 해준다. 
		즉, SQL이나 JPQL과 같은 데이터베이스 쿼리를 자바 코드로 작성하여, 타입 안정성과 코드 가독성을 높여준다.  
	*/
	@GetMapping("searchQueryDSL")
	public List<MemberDTO> searchQueryDSL(@RequestParam(name = "userName", defaultValue = "") String userName
										 ,@RequestParam(name = "gender", defaultValue = "") String gender) {
			
		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("userName", userName);
		paraMap.put("gender", gender);
		
	//	return memberService.searchQueryDSL_1(paraMap);
		
		// ==> !!! 동적 조건으로 분기 처리해주는 QueryDSL 전용의 SQL 조건 표현 객체인 BooleanExpression 사용하여 처리하기 !!! <==
		return memberService.searchQueryDSL_2(paraMap);
	}
	
	
	
}
