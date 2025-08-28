package com.spring.app.comment.service;

import java.util.List;
import java.util.Map;

import com.spring.app.comment.domain.CommentDTO;

public interface CommentService {
	
	// 댓글 작성
    void insertComment(CommentDTO comment);

    //댓글삭제
	int deleteComment(Long commentNo);
	
	//대댓글 작성
	int insertReply(CommentDTO comment);
	
	
	//대댓글삭제
	int deleteReply(Long commentNo);

	//대댓글 목록 조회
	CommentDTO getReplyById(Long commentNo);


}
