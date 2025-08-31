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

	//대댓글 삭제
	int deleteReply(Long commentNo);

	//대댓글 작성
	int insertReply(CommentDTO comment);

	//대댓글 목록
	List<CommentDTO> getRepliesByParentNo(Long commentNo);

	//대댓글조회
	CommentDTO getReplyById(Long commentNo);



    // 유저가 하루동안 쓴 댓글의 개수를 얻어오는 메소드 (3개 이하면 pointUp)
	int getCreatedAtCommentCnt(String id);

	int updateComment(Long commentNo, String content, String fk_id);



    
}