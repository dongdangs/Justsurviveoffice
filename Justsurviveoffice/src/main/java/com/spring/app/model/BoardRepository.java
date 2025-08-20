package com.spring.app.model;

import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.spring.app.entity.Board;
import com.spring.app.users.domain.BoardDTO;

public interface BoardRepository extends JpaRepository<Board, Long> { 
	
	// 내가 쓴 글
	List<Board> findByUsers_IdOrderByCreatedAtBoardDesc(String id);


    

}
