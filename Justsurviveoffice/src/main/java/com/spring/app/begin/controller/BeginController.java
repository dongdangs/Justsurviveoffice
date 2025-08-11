package com.spring.app.begin.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.spring.app.begin.domain.BeginDTO;
import com.spring.app.begin.service.BeginService;

import jakarta.servlet.http.HttpServletRequest;

@Controller
@RequestMapping(value="/test")
public class BeginController {
	
	private final BeginService service;
	
	public BeginController(BeginService service) {
		this.service = service;
	}
	
	
	@GetMapping("select")
    public String selectPage(HttpServletRequest request) {
		
		List<BeginDTO> begindtoList = service.select();
		
		request.setAttribute("begindtoList", begindtoList);
		
		return "begin/select";
	}
	
}
