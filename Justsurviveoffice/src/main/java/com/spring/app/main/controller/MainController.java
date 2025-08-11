package com.spring.app.main.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.spring.app.main.service.MainService;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor  // @RequiredArgsConstructor는 Lombok 라이브러리에서 제공하는 애너테이션으로, final 필드 또는 @NonNull이 붙은 필드에 대해 생성자를 자동으로 생성해준다.
@RequestMapping(value = "/rdg7203Work/")
public class MainController {
	
	// 의존객체를 생성자 주입(DI : Dependency Injection)
	private final MainService service;
	
	@GetMapping("main")
	public String main() {
		return "/rdg7203Work/main";
		//	/WEB-INF/views/rdg7203Work/main.jsp 파일을 만들어야 한다.
	}
	
	
	@GetMapping("survey")
	public String survey() {
		return "/rdg7203Work/survey";
		//	/WEB-INF/views/rdg7203Work/survey.jsp 파일을 만들어야 한다.
	}
	
	
	@GetMapping("surveyStart")
	@ResponseBody
	public String surveyStart() {
		
		List<Map<String, String>> surveyList = service.surveyStart();	// 설문과 옵션 내용 가져오기
		// questionNo    questionContent    optionNo    optionText  fk_categoryNo
		
		/*
		 * [{"questionNo": 1,"questionContent": "팀 프로젝트에서 당신의 역할은?", "options": [{
		 * "optionNo": 10, "optionText": "리더가 좋다", "categoryNo": 1} ,{ "optionNo": 11,
		 * "optionText": "서포터가 편하다", "categoryNo": 2} ] }]
		 */
		JSONArray jsonArr = new JSONArray();	// [] 최종 리스트
		JSONArray options = null;
		int n = surveyList.size();	// 리스트가 비었을 때 방지용
		
		String questionNoCheck = "";	// 질문번호 체크용
		
		for(int i = 0; i < n; i++) {
			String QNo = surveyList.get(i).get("questionNo");	// 질문번호 체크용
			
			 // ORDER BY 로 정렬 해놔서 새로운 질문번호가 오면 새 JSONObject 생성
			if(!QNo.equals(questionNoCheck)) {
				// 이전 질문 저장해야함
				if(options != null) {
					JSONObject jsonObj = new JSONObject();	// {}
					jsonObj.put("questionNo", surveyList.get(i - 1).get("questionNo"));
					jsonObj.put("questionContent", surveyList.get(i - 1).get("questionContent"));
					jsonObj.put("options", options);
					
					jsonArr.put(jsonObj);
				}
				
				options = new JSONArray();
				questionNoCheck = QNo;
			}
			
			JSONObject option = new JSONObject();	// options에 넣을 {}
			option.put("optionNo", surveyList.get(i).get("optionNo"));
			option.put("optionText", surveyList.get(i).get("optionText"));
			option.put("fk_categoryNo", surveyList.get(i).get("fk_categoryNo"));
			
			options.put(option);
		}// end of for-----------------------
		
		// 마지막 질문 담아주기
		if (options != null && n > 0) {
			JSONObject lastQ = new JSONObject();
			lastQ.put("questionNo", surveyList.get(n - 1).get("questionNo"));
			lastQ.put("questionContent", surveyList.get(n - 1).get("questionContent"));
			lastQ.put("options", options);
			jsonArr.put(lastQ);
		}
		
		return jsonArr.toString();
	}
	
	
}
