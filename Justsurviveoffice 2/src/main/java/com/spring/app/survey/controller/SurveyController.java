package com.spring.app.survey.controller;

import java.util.List;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.spring.app.survey.service.SurveyService;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@RequestMapping("categoryTest/")
public class SurveyController {
	
	private final SurveyService surveyService;
	
	
	@GetMapping("survey")
	public String survey() {
		return "/categoryTest/survey";
		//	/WEB-INF/views/rdg7203Work/survey.jsp 파일을 만들어야 한다.
	}
	
	
	@GetMapping("surveyStart")
	@ResponseBody
	public String surveyStart() {
		
		List<Map<String, String>> surveyList = surveyService.surveyStart();	// 설문과 옵션 내용 가져오기
		// questionNo    questionContent    optionNo    optionText  fk_categoryNo
		
		/*
		 * [{"questionNo": 1,"questionContent": "팀 프로젝트에서 당신의 역할은?", "options": [{
		 * "optionNo": 10, "optionText": "리더가 좋다"} ,{ "optionNo": 11,
		 * "optionText": "서포터가 편하다"} ] }]
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
	
	
	@PostMapping("submit")
	@ResponseBody
	public String submit(@RequestParam("answer_arr") List<Integer> answerArr) {
		
	//	System.out.println(answerArr);
		
		// ["categoryName":"MZ", "categoryImagePath ":"mz.png", "tags":["에어팟필수", "칼퇴", "딴생각장인", "지각러버"]]
		
		// 결과 계산은 나중에 만들겠습니다.
		// 현재로서는 내용물 보여지게 여기에만 따로 작성 합니다.
		JSONObject jsonObj = new JSONObject();	// {} 최종 오브젝트
		
		jsonObj.put("categoryName", "MZ");
		jsonObj.put("categoryImagePath", "mz.png");
		
		JSONArray tagArr = new JSONArray();
		tagArr.put("에어팟필수");
		tagArr.put("칼퇴");
		tagArr.put("딴생각장인");
		tagArr.put("지각러버");
		
		jsonObj.put("tags", tagArr);
		
		return jsonObj.toString();
	}
	
}
