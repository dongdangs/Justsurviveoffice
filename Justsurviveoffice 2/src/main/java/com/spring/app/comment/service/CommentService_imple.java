package com.spring.app.comment.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.spring.app.comment.domain.CommentDTO;
import com.spring.app.comment.model.CommentDAO;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class CommentService_imple implements CommentService {

    private final CommentDAO commentDao;



    // 댓글 추가
    @Override
    public void insertComment(CommentDTO comment) {
    	commentDao.insertComment(comment);
    }

   
    //댓글 삭제 (본인만 가능)
    @Override
    public int deleteComment(Long commentNo) {
        int n =  commentDao.deleteComment(commentNo) ;
        
        return n;
    }


    //대댓글 작성
	@Override
	public int insertReply(CommentDTO comment) {
		return commentDao.insertReply(comment);
	}

	//대댓글 삭제 (본인만 가능)
    @Override
    public int deleteReply(Long commentNo) {
        int n =  commentDao.deleteReply(commentNo) ;
        
        return n;
    }


    //대댓글 목록 조회
	@Override
	public CommentDTO getReplyById(Long commentNo) {
		return commentDao.getReplyById(commentNo);
	}


    


	

   


}