package com.spring.app.entity;

import com.spring.app.users.domain.CategoryDTO;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Entity
@Table(name = "category")
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
@ToString
public class Category {
	
	
	@Id
	@Column(name = "categoryno", nullable = false)
	private int categoryNo;

	
	@Column(name="categoryname" ,nullable = false, length = 50)
	private String categoryName;
	
	@Column(name="categorydescribe" ,nullable = false, length = 200)
	private String categoryDescribe;	
	
	@Column(name="categoryimagePath" ,nullable = false, length = 255)
	private String categoryImagePath;
	
	public CategoryDTO toDTO() {
		return CategoryDTO.builder()
					   .categoryNo(categoryNo)
					   .categoryName(categoryName)
					   .categoryDescribe(categoryDescribe)
					   .categoryImagePath(categoryImagePath)
					   .build();
	}
	
	
	
	
}
