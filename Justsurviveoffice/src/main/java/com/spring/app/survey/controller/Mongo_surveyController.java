package com.spring.app.survey.controller;

import java.util.ArrayList;
import java.util.HashMap;
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

import com.spring.app.category.domain.CategoryDTO;
import com.spring.app.survey.domain.Mongo_QuestionDTO;
import com.spring.app.survey.model.SurveyDAO;
import com.spring.app.survey.service.SurveyMongoOperations;

import lombok.RequiredArgsConstructor;

//== 몽고DB 설문 관련 순서2
@Controller
@RequiredArgsConstructor
@RequestMapping("categoryTest/")
public class Mongo_surveyController {
	
	private final SurveyMongoOperations surveyMongo;
	
	private final SurveyDAO sdao;
	
	@GetMapping("survey")
	public String survey() {
		return "/categoryTest/survey";
		//	/WEB-INF/views/rdg7203Work/survey.jsp 파일을 만들어야 한다.
	}
	
	
	// 몽고DB에서 설문 데이터 가져오기
    @GetMapping("surveyStart")
    @ResponseBody
    public List<Mongo_QuestionDTO> surveyStart() {
    	return surveyMongo.findAllQuestions();
    }
	
    
    // 설문 결과를 통한 데이터 가져오기
    @PostMapping("submit")
    @ResponseBody
    public String submit(@RequestParam(name = "answer_arr") List<String> answer_arr) {
    	
    	System.out.println("확인용 대답 : " + answer_arr);
    	// 확인용 대답 : [3, 2, 2, 2, 2]
    	
    	/*
    		리스트에 적힌 카테고리번호 의 갯수를 계산해서 제일 많은 카테고리번호를 가져오고 이에 알맞은 유형 데이터 리턴시켜주기
    		단 Max(카테고리번호)의 값이 같은 경우 >> 최대 3개의 유형까지 같다면 해당 같은 카테고리번호를 뽑아와서 랜덤으로 한개 골라서 리턴시켜주기
    		만약에  Max(카테고리번호)의 값이 4개 이상 같다면 리더형 데이터 리턴시켜주기
    	*/
    	Map<String, Integer> categoryCount = new HashMap<>();
    	
    	for(int i=0; i<answer_arr.size(); i++) {
    		categoryCount.merge(answer_arr.get(i), 1, Integer::sum);	// {"1":2, "2":1, "3":1, "4":3}
    	}// end of for----------------------------------
    	
    	int maxValue = 0;
    	List<String> maxCategoryList = new ArrayList<>();
    	
    	for( Map.Entry<String, Integer> categoryMap : categoryCount.entrySet() ) {
    		int k = categoryMap.getValue();
    		// System.out.println(k);
    		if(k > maxValue) {
    			maxValue = k;
    			maxCategoryList.clear();	// 리스트 비우기
    			maxCategoryList.add(categoryMap.getKey());
    		}
    		
    		else if(k == maxValue){			// k가 쌓이면서 maxValue가 같을때도 수정
    			maxCategoryList.add(categoryMap.getKey());
    		}
    	}// end of for---------------------------
    	// System.out.println("확인용 max : " + maxCategoryList);
    	String categoryNo = "";
    	
    	if(maxCategoryList.size() >= 4) {	// 값이 4개 이상 저장되어 있을 경우 리더형
    		categoryNo = "6";
    	}
    	else if(maxCategoryList.size() == 1) {	// 값이 1개 있는 경우
    		categoryNo = maxCategoryList.get(0);
    	}
    	else {	// 값이 1개가 저장된게 아닐 경우 랜덤으로 유형 선택
    		int idx = (int) (Math.random() * maxCategoryList.size());	// Math.random() -> 0 ~ 1.0 사이의 실수 * 리스트의 크기 => 0 ~ 리스트의 크기 -1 사이의 정수
    		categoryNo = maxCategoryList.get(idx);
    	}
    	
    	CategoryDTO cdto = sdao.selectCategory(categoryNo);	// 해당 카테고리의 유형 정보 가져오기
    	
    	// {"categoryName":"MZ", "categoryImagePath ":"~", "tags":["에어팟필수", "칼퇴", "딴생각장인", "지각러버"]}
    	JSONObject jsonObj = new JSONObject();	// {} 최종 오브젝트
		jsonObj.put("categoryName", cdto.getCategoryName());
		jsonObj.put("categoryImagePath", cdto.getCategoryImagePath());
		
		JSONArray tagArr = new JSONArray();	// []
		for(String tag : cdto.getTags().split(",")) {
			tag = tag.trim();	// 혹시 모를 공백 제거
			tagArr.put(tag);
		}
		
		jsonObj.put("tags", tagArr);
		
		return jsonObj.toString();	
    }
    
}
