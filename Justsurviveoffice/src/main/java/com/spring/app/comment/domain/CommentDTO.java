package com.spring.app.comment.domain;

import java.time.LocalDateTime;

import com.spring.app.entity.Board;
import com.spring.app.entity.Users;

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
public class CommentDTO {
	
	private Long commentNo;

	private String fk_id;

	private String fk_name;

	private String content;

	private  LocalDateTime createdAtComment;


	private Long fk_boardNo;

	private Long parentNo;
	
	private Users users;
	
	private Board board;
	

}
