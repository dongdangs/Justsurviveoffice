package com.spring.app.entity;

import java.time.LocalDateTime;

import com.spring.app.domain.UserDTO;

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
@Table(name="users") // 이름을 적지 않으면 클래스 이름이 테이블 이름.
@Getter               // private 으로 설정된 필드 변수를 외부에서 접근하여 사용하도록 getter()메소드를 만들어 주는 것.
@Setter               // private 으로 설정된 필드 변수를 외부에서 접근하여 수정하도록 setter()메소드를 만들어 주는 것.
@AllArgsConstructor   // 모든 필드 값을 파라미터로 받는 생성자를 만들어주는 것
@NoArgsConstructor    // 파라미터가 없는 기본생성자를 만들어주는 것
@Builder			  // 생성자 대신, 필요한 값만 선택해서 체이닝 방식으로 객체를 만들 수 있게 해주는 것.
@ToString
public class User {
	
	@Id 
	@Column(name="id", nullable=false, length=50)
	private String id;
	
	@Column(name="name", nullable=false, length=30)
	private String name;
	
	@Column(name="password", nullable=false, length=50)
	private String password; 
	
	@Column(name="email", nullable=false, length=50)
	private String email; 
	
	@Column(name="mobile", nullable=false, length=40)
	private String mobile; 
	
	@Column(name="point", nullable=false)
	private int point; 
	
	@Column(name="fk_categoryNo", nullable=false, length=50)
	private String fkCategoryNo;
	
	@Column(nullable = false, columnDefinition = "DATE DEFAULT SYSDATE", insertable = false, updatable = false)
	private LocalDateTime registerday; 
	
	@Column(nullable = false, columnDefinition = "DATE DEFAULT SYSDATE", insertable = false, updatable = false)
	private String passwordChanged; 
	
	@Column(nullable = false, columnDefinition = "NUMBER DEFAULT 0", insertable = false)
	private int isDormant; 
	
	@Column(nullable = false, columnDefinition = "NUMBER DEFAULT 0", insertable = false)
	private int isDeleted; 
	
	
	public UserDTO toDTO() {
		
		return UserDTO.builder()
				.id(this.id)
				.name(this.name)
				.password(this.password)
				.email(this.email)
				.mobile(this.mobile)
				.point(this.point)
				.fkCategoryNo(this.fkCategoryNo)
				.registerday(this.registerday)
				.passwordChanged(this.passwordChanged)
				.isDormant(this.isDormant)
				.isDeleted(this.isDeleted)
				.build();
		
	}

}
