package com.spring.app.comment.service;

import java.util.Map;

import com.spring.app.comment.domain.CommentDTO;

public interface CommentService {
	
    // 댓글 목록 조회
    //List<CommentDTO> getCommentsByBoard(Long fk_boardNo);

	// 댓글 작성
    void insertComment(CommentDTO comment);

    //댓글삭제
	int deleteComment(Long commentNo);
	
	//대댓글 작성
	void insertReply(CommentDTO comment);
	
	
	//대댓글삭제
	int deleteReply(Long commentNo);
	


}
