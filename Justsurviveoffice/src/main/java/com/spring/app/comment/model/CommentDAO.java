package com.spring.app.comment.model;

import java.util.List;

import com.spring.app.users.domain.CommentDTO;

public interface CommentDAO {
	
    // 댓글 작성
    int insertComment(CommentDTO comment);

    //  댓글 목록
	List<CommentDTO> getCommentList(Long boardNo);

    // 댓글 삭제
	int deleteComment(Long commentNo);

    // 댓글 수정
    int updateComment(Long commentNo, String content, String fk_id);

    // 유저가 하루동안 쓴 댓글의 개수를 얻어오는 메소드 (3개 이하면 pointUp)
	int getCreatedAtCommentCnt(String id);



    
}