package com.spring.app.model;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.spring.app.entity.Bookmark;

public interface BookMarkRepository extends JpaRepository<Bookmark, Integer> {
	
    List<Bookmark> findByUsers_Id(String id);

}