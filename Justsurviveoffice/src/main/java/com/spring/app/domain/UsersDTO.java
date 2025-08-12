package com.spring.app.domain;

import java.time.LocalDateTime;

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
public class UsersDTO {

	private String id; //pk
	private String name;
	private String password;
	private String email;
	private String mobile;
	private int point;

	private int fk_categoryNo;//fk
	private LocalDateTime registerday;
	private LocalDateTime passwordChanged;
	private int isDormant;//0 또는 1
	private int isDeleted;//0 또는 1

	
}
