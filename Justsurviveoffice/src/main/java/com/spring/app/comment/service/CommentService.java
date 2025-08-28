package com.spring.app.comment.service;

import java.util.List;

import com.spring.app.entity.Board;
import com.spring.app.entity.Comments;
import com.spring.app.users.domain.CommentDTO;
import com.spring.app.users.domain.UsersDTO;

public interface CommentService {
	
    // 댓글 목록 조회
    //List<CommentDTO> getCommentsByBoard(Long fk_boardNo);

	// 댓글 작성
    void insertComment(CommentDTO comment);

    //댓글삭제
	int deleteComment(Long commentNo);
	
	//댓글수정
	boolean updateComment(Long commentNo, String newContent, String fk_id);

	// 유저가 하루동안 쓴 댓글의 개수를 얻어오는 메소드 (3개 이하면 pointUp)
	public int getCreatedAtCommentCnt(String id);






	
	


	


}
