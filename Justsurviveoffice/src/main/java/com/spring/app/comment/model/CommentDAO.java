package com.spring.app.comment.model;

import java.util.List;

import com.spring.app.comment.domain.CommentDTO;

public interface CommentDAO {
	
    // 댓글 작성
    int insertComment(CommentDTO comment);

    //  댓글 목록
	List<CommentDTO> getCommentList(Long boardNo);

    // 댓글 삭제
	int deleteComment(Long commentNo);

    // 댓글 수정
    int updateComment(Long commentNo, String content, String fk_id);



    
}