package com.spring.app.entity;

import java.time.LocalDateTime;

import com.spring.app.domain.UsersDTO;

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
@Table(name="Users")
@Getter               // private 으로 설정된 필드 변수를 외부에서 접근하여 사용하도록 getter()메소드를 만들어 주는 것.
@Setter               // private 으로 설정된 필드 변수를 외부에서 접근하여 수정하도록 setter()메소드를 만들어 주는 것.
@AllArgsConstructor   // 모든 필드 값을 파라미터로 받는 생성자를 만들어주는 것
@NoArgsConstructor    // 파라미터가 없는 기본생성자를 만들어주는 것
@Builder			  // 생성자 대신, 필요한 값만 선택해서 체이닝 방식으로 객체를 만들 수 있게 해주는 것.
@ToString
public class Users {

	@Id
	@Column(name = "id", nullable = false, length = 50)
	private String id;
	
	@Column(nullable = false, length = 30)
	private String name;
	
	@Column(nullable = false, length = 50)
	private String password;
	
	@Column(nullable = false, length = 50)
	private String email;
	
	@Column(nullable = false, length = 40)
	private String modbile;
	
	@Column(nullable = false)
	private int point;

// insertable = false 로 설정하면 엔티티 저장(insert)시 이 필드를 빼라는 말이다.
// updatable = false 로 설정하면 엔티티 변경(update)이 안되게 한다는 뜻이다.
	@Column(nullable = false, columnDefinition = "DATE DEFAULT SYSDATE",
  		    insertable = false, updatable = false)  
	private LocalDateTime registerday;
	
	@ManyToOne // 외래키 제약을 걸고 싶을 때 추가!
	@JoinColumn(name = "fk_categoryNo", referencedColumnName = "categoryNo", nullable = true)
	private Category fk_categoryNo;


	@Column(nullable = false, columnDefinition = "DATE DEFAULT SYSDATE")
	private LocalDateTime passwordChanged;
	
	@Column(nullable = false, columnDefinition = "NUMBER DEFAULT 0",
			insertable = false)
	private int isDormant;
			
	@Column(nullable = false, columnDefinition = "NUMBER DEFAULT 0",
			insertable = false)
	private int isDeleted;
	
	// Entity를 DTO로 변환하기
	public UsersDTO toDTO() {
		
		return UsersDTO.builder()
				.id(this.id)
				.name(this.name)
				.password(this.password)
				.point(this.point)
				//.fk_categoryNo(this.fk_categoryNo)
				.registerday(this.registerday)
				.passwordChanged(this.passwordChanged)
				.isDormant(this.isDormant)
				.isDeleted(this.isDeleted)
				.build();
		
	}
	
}
