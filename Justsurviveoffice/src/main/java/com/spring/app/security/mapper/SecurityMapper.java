package com.spring.app.security.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.spring.app.users.domain.UsersDTO;

@Mapper
public interface SecurityMapper {
	
	// DB에서 사용자조회
	UsersDTO findById(@Param("id")String id);
	
}
