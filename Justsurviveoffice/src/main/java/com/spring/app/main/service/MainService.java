package com.spring.app.main.service;

import java.util.List;
import java.util.Map;

public interface MainService {
	
	// 설문과 옵션 내용 가져오기
	List<Map<String, String>> surveyStart();

}
