package com.spring.app.model;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.spring.app.entity.Board;

public interface BoardRepository extends JpaRepository<Board, Long> { 
	
	//내가 쓴 글
	List<Board> findByUsers_IdOrderByCreatedAtBoardDesc(String id);
  


    

}
