package com.spring.app.comment.model;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import com.spring.app.comment.domain.CommentDTO;

import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class CommentDAO_imple implements CommentDAO {

    private final SqlSessionTemplate sql;

   
    // 댓글 작성
    @Override
    public int insertComment(CommentDTO comment) {
        return sql.insert("comments.insertComment", comment);
    }

    // 특정 게시글의 댓글 목록
    @Override
	public	List<CommentDTO> getCommentList(Long boardNo) {
        return sql.selectList("comments.getCommentsByBoardNo", boardNo);
    }

    // 댓글 삭제
    @Override
    public int deleteComment(Long commentNo) {
        return sql.delete("comments.deleteComment", commentNo);
    }

    
    //대댓글 삭제
	@Override
	public int deleteReply(Long commentNo) {
        return sql.delete("comments.deleteReply", commentNo);
	}

	//대댓글 작성
	@Override
	public int insertReply(CommentDTO comment) {
		return sql.insert("comments.insertReply", comment);
	}

	//대댓글 목록
	@Override
	public List<CommentDTO> getRepliesByParentNo(Long commentNo) {
		return sql.selectList("comments.getRepliesByParentNo", commentNo);
	}

	//대댓글 조회
	@Override
	public CommentDTO getReplyById(Long commentNo) {
		return sql.selectOne("comments.getReplyById",commentNo);
	}

	
	

  
  
}