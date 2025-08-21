package com.spring.app.users.domain;

import java.time.LocalDateTime;

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
public class BoardDTO {

	private Long boardNo;

	private Long fk_categoryNo;

	private String boardName;

	private String boardContent;

	private LocalDateTime createdAtBoard;

	private LocalDateTime updatedAtBoard;

	private int readCount;

	private String fk_id;

	private String boardFileName;

	private String boardFileOriginName;

	private int boardDeleted ;
	
	private Users users;
	
	
	// select 용
	private String preNo;     // 이전글번호
	private String preName; // 이전글제목
	private String nextNo;         // 다음글번호
	private String nextName;     // 다음글제목 
}
