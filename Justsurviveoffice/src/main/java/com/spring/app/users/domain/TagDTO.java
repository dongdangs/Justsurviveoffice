package com.spring.app.users.domain;


import com.spring.app.entity.Category;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter; 
import lombok.NoArgsConstructor;
import lombok.Setter;


@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class TagDTO {

	private int tagNo;

	private String tagName;
	
	private int fk_categoryNo;


	private Category category;



}
