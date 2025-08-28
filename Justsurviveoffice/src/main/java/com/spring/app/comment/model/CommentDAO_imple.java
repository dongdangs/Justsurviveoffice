package com.spring.app.comment.model;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import com.spring.app.users.domain.CommentDTO;

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

    // 댓글 수정
    @Override
    public int updateComment(Long commentNo, String content, String fk_id) {
        java.util.Map<String, Object> paramMap = new java.util.HashMap<>();
        paramMap.put("commentNo", commentNo);
        paramMap.put("content", content);
        paramMap.put("fk_id", fk_id);
        return sql.update("comments.updateComment", paramMap);
    }
    
    // 유저가 하루동안 쓴 댓글의 개수를 얻어오는 메소드 (3개 이하면 pointUp)
	@Override
	public int getCreatedAtCommentCnt(String id) {
		int n = sql.selectOne("comments.getCreatedAtCommentCnt", id);
		return n;
	}

  
}