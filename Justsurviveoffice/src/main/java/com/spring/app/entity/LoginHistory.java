package com.spring.app.entity;

import java.time.LocalDateTime;

import com.spring.app.users.domain.LoginHistoryDTO;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Entity
@Table(name = "loginHistory")
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
@ToString
public class LoginHistory {

	@Id
	@Column(name = "loginHistoryNo", nullable = false)
	private int loginHistoryNo;

	@Column(nullable = false, columnDefinition = "DATE DEFAULT SYSDATE",
			insertable = false)
	private LocalDateTime lastLogin;

	@Column(nullable = false)
	private String ip;
	
	@ManyToOne // 외래키 제약을 걸고 싶을 때 추가!
	@JoinColumn(name = "fk_id", referencedColumnName = "id", nullable = true)
	private Users users;

	public LoginHistoryDTO toDTO() {
		return LoginHistoryDTO.builder()
							  .loginHistoryNo(this.loginHistoryNo)
							  .lastLogin(this.lastLogin)
							  .ip(this.ip)
							  .users(this.users)
							  .build();
	}
	
}
