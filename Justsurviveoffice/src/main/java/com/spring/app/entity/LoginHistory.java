package com.spring.app.entity;

import java.time.LocalDateTime;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
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

	@Column(nullable = false)
	private String fk_id;

	@Column(nullable = false, columnDefinition = "DATE DEFAULT SYSDATE")
	private LocalDateTime lastLogin;

	@Column(nullable = false)
	private String ip;
}
