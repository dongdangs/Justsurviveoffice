package com.spring.app.opendata.controller;

import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.io.Reader;
import java.util.List;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.spring.app.opendata.domain.Seoul_bicycle_rental_DTO;
import com.spring.app.opendata.service.OpendataService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;


@Controller
@RequiredArgsConstructor  // @RequiredArgsConstructor는 Lombok 라이브러리에서 제공하는 애너테이션으로, final 필드 또는 @NonNull이 붙은 필드에 대해 생성자를 자동으로 생성해준다. 
@RequestMapping(value="/opendata/")
public class OpendataController {

	private final OpendataService service;
	
	///////////////////////////////////////////////////////////////////////////////////////////
	// == 한국관광공사사진 == //
	@GetMapping(value="korea_tour_api")
	public String korea_tour() {
	
		return "mycontent1/opendata/korea_tour_api";
		//  /WEB-INF/views/mycontent1/opendata/korea_tour_api.jsp 페이지를 만들어야 한다.
	}
	
	
	// == 서울시 따릉이대여소 마스터 정보 == // 
	@GetMapping(value="seoul_bicycle_rental_JSON")
	@ResponseBody
	public String seoul_bicycle_rental_JSON(HttpServletRequest request) throws IOException, ParseException {

	/*
		서울시 따릉이대여소 마스터 정보
		https://data.seoul.go.kr/dataList/OA-21235/S/1/datasetView.do
		에서 미리보기 > 내려받기(JSON)를 클릭하여 
		/myspring/src/main/webapp/resources/seoul_opendata/seoul_bicycle_rental.json 으로 저장한다.
	*/
		
	/*
		저장된 JSON 파일을 읽고, 파싱하여 값을 읽어오려면 org.json.simple.parser.JSONParser 을 사용하면 된다. 
		먼저, org.json.simple.parser.JSONParser 를 사용하기 위해서는 아래의 dependency 를 추가한다. (MAVEN)
		<dependency>
            <groupId>com.googlecode.json-simple</groupId>
            <artifactId>json-simple</artifactId>
            <version>1.1.1</version>
        </dependency>		
	*/	
		
		// JSON 파일이 저장되어 있는 WAS(톰캣)의 디스크 경로명을 알아와야만 한다. 
		// 이를 위해서 WAS 의 webapp 의 절대경로를 알아와야 한다.
		HttpSession session = request.getSession();
		String root = session.getServletContext().getRealPath("/");
		
		String jsonFilePath = root+"resources"+File.separator+"seoul_opendata"+File.separator+"seoul_bicycle_rental.json";
		//  File.separator 은 경로의 구분자로서 윈도우이라면 "\" 를 말하고,
		//  Mac, Unix, Linux 이라면 "/" 를 말하는 것이다.
		
//	 	jsonFilePath 가 json 파일이 된다.
		//	System.out.println("~~~ 확인용 jsonFilePath => " + jsonFilePath);
		// ~~~ 확인용 jsonFilePath => C:\NCS\workspace_spring_boot_17\myspring\src\main\webapp\resources\seoul_opendata\seoul_bicycle_rental.json 
		
		JSONParser parser = new JSONParser();
		// import 시 org.json.simple.parser.JSONParser 이다.
		
		// 디스크에 저장된 JSON 파일을 읽어오기
		Reader reader = new FileReader(jsonFilePath);
				
		// JSON 파일을 JSONObject 로 만들기
		org.json.simple.JSONObject jsonObj = (org.json.simple.JSONObject) parser.parse(reader);
		             // JSONObject jsonObj = (JSONObject) parser.parse(reader);
				
		// JSONObject 에서 필요한 데이터 가져오기
		org.json.simple.JSONArray jsonArr = (org.json.simple.JSONArray)jsonObj.get("DATA");
				
		return jsonArr.toString();
		// http://localhost:9090/myspring/opendata/seoul_bicycle_rental_JSON 을 실행하여 결과물을 확인한다. 
		 
	}
	
	
	// == 서울따릉이지도 (서울시 따릉이대여소 마스터 정보 값을 가지고 카카오지도에 마커 찍어주기)== // 
	@GetMapping(value="seoul_bicycle_rental")
	public String opendata_seoul_bicycle_rental() {
	
		return "mycontent1/opendata/seoul_bicycle_rental";
		//  /WEB-INF/views/mycontent1/opendata/seoul_bicycle_rental.jsp 페이지를 만들어야 한다.
	}
	
	
	// == 오라클입력및조회 뷰단== //
	@GetMapping("seoul_bicycle_rental_insert")
	public String seoul_bicycle_rental_insert() {
		
		return "mycontent1/opendata/seoul_bicycle_rental_insert";
	    //  /WEB-INF/views/mycontent1/opendata/seoul_bicycle_rental_insert.jsp 페이지를 만들어야 한다.  
	}
	
	
	// == 오라클조회 == //
	@GetMapping("seoul_bicycle_rental_select")
	@ResponseBody
	public String seoul_bicycle_rental_select() {
		
		List<Map<String, String>> mapList = service.select_seoul_bicycle_rental(); 
		
		JSONArray jsonArr = new JSONArray();
		
		if(mapList != null) {
			for(Map<String, String> map : mapList) {
				JSONObject jsonObj = new JSONObject();
				jsonObj.put("GU", map.get("GU"));
				jsonObj.put("CNT", map.get("CNT"));
				jsonObj.put("PERCENTAGE", map.get("PERCENTAGE"));
				
				jsonArr.put(jsonObj);
			}// end of for----------------------
		}
		
		return jsonArr.toString();
	}
	
	
	// == 오라클입력 == //
	@PostMapping("seoul_bicycle_rental_insert_END")
	@ResponseBody
	public String seoul_bicycle_rental_insert_END(Seoul_bicycle_rental_DTO vo) {
		
		int n = service.insert_seoul_bicycle_rental(vo);
		
		JSONObject jsonObj = new JSONObject();
		jsonObj.put("n", n);
		
		return jsonObj.toString();
	}
	
	
	
	
	
	
}
