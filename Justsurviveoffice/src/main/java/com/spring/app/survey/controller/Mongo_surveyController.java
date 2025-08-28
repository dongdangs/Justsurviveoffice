package com.spring.app.survey.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.spring.app.survey.domain.Mongo_QuestionDTO;
import com.spring.app.survey.service.SurveyMongoOperations;

import lombok.RequiredArgsConstructor;

//== 몽고DB 설문 관련 순서2
@Controller
@RequiredArgsConstructor
@RequestMapping("categoryTest/")
public class Mongo_surveyController {
	
	private final SurveyMongoOperations surveyMongo;
	
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
    public Map<String, Object> submit(@RequestParam(name = "answer_arr") List<String> answer_arr) {
    	
    	Map<String, Object> resultMap = new HashMap<>();
    	
		// 임시 카테고리 이름/이미지
		resultMap.put("categoryName", "MZ");
		resultMap.put("categoryImagePath", "mz.png");
		
		// 태그 배열 (List 로 넣으면 자동으로 JSON 배열로 변환해줌)
		List<String> tags = List.of("에어팟필수", "칼퇴", "딴생각장인", "지각러버");
		resultMap.put("tags", tags);
    	
    	return resultMap;
    }
    
}
