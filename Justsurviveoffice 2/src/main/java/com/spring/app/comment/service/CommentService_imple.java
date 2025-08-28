package com.spring.app.comment.service;

import java.util.HashMap;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.spring.app.comment.model.CommentDAO;
import com.spring.app.users.domain.CommentDTO;

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


    //댓글 수정 (본인만 가능)

    @Override
    public boolean updateComment(Long commentNo, String content, String fk_id) {
        return commentDao.updateComment(commentNo, content, fk_id) > 0;
    }



}