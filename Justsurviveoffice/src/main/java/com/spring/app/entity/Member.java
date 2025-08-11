package com.spring.app.entity;

import java.time.LocalDateTime;

import com.spring.app.domain.MemberDTO;

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
@Table(name="tbl_member")
@Getter				// private 으로 설정된 필드 변수를 외부에서 접근하여 사용하도록 getter()메소드를 만들어 주는 것.
@Setter				// private 으로 설정된 필드 변수를 외부에서 접근하여 수정하도록 setter()메소드를 만들어 주는 것.
@AllArgsConstructor	// 모든 필드 값을 파라미터로 받는 생성자를 만들어주는 것
@NoArgsConstructor	// 파라미터가 없는 기본생성자를 만들어주는 것
@Builder			// 생성자 대신, 필요한 값만 선택해서 체이닝 방식으로 객체를 만들 수 있게 해주는 것.
@ToString
public class Member {
	
/*	
	@Id
	@Column(nullable=false, length=50)	// nullable 기본이 true임
	private String userId;	// Spring Boot는 기본적으로 필드명에 카멜 표기를 사용하면 DB 컬럼명을 스네이크 표기(언더바)로 변환함. 
							// (필드명 userId 은 DB 컬럼명이 user_id 으로 되어짐).
							// 자바는 카멜 표기를 권장하고, DB는 스네이크 표기(언더바)를 권장한다.
*/	
	
/*	
	@Id
	@Column(name="userid", nullable=false, length=50)
	private String userId;	// 필드명에 카멜 표기를 사용한 userId 이라서 DB 컬럼명은 user_id 가 될 것인데
							// DB 컬럼명을 user_id 이 아닌 다른 컬럼명으로 사용하고 싶다면 name 속성을 따로 주어야 한다.
							// 지금은 name 속성을 userid 로 주었으므로 DB 컬럼명이 userid 가 되어진다.
*/	
	
/*	
	@Id
	@Column(nullable=false, length=50)
	private String userId;	// application.yml 에서 
							// jpa.hibernate.naming.physical-strategy: org.hibernate.boot.model.naming.PhysicalNamingStrategyStandardImpl 으로 설정 했다면  
							// 이것은 필드명이 그대로 DB 컬럼명이 되어지게 끔 하겠다는 것이므로 DB 컬럼명도 userId 가 되어진다.
*/	
	
	@Id
	@Column(name="user_id", nullable=false, length=50)
	private String userId;	// Spring Boot는 기본적으로 필드명에 카멜 표기를 사용하면 DB 컬럼명을 스네이크 표기(언더바)로 변환함. 
							// (필드명 userId 은 DB 컬럼명이 user_id 으로 되어짐).
							// Primary Key 로 사용되어지는 @Id 컬럼에는 name 속성을 꼭 주도록 하자. 왜냐하면 자식 엔티티 클래스에서 Foreign Key 생성시 참조받는 컬럼명을 미리 적어주어야 하기 때문이다.
	
	@Column(nullable = false, length = 30)
	private String userName;
	
	@Column(nullable = false, length = 50)
	private String userPwd;
	
/*	
	@Column(nullable = false, length = 50, unique = true)	// unique = true 이 unique 제약이다.
	private String email;
*/	
	@Column(nullable = false)
	private int gender;
	
	@Column(nullable = false, columnDefinition = "DATE DEFAULT SYSDATE", insertable = false, updatable = false)
	private LocalDateTime regDate;
	// LocalDateTime 은 년월일T시분초	현재시각은 LocalDateTime.now()
	// LocalDate 	 은 년월일
	// LocalTime 	 은 시분초
	
	// columnDefinition 은 DB 컬럼의 정보를 직접 주는 것이다. 예를 들어 columnDefinition = "Nvarchar2(20) default '사원'" 인 것이다.
	// insertable = false 로 설정하면 엔티티 저장(insert)시 이 필드를 빼라는 말이다.
	// insertable = true 로 설정하면 엔티티 저장(insert)시 이 필드는 들어간다는 말이다.
	// 기본값은 true 이므로 생략하면 insertable = true 이다. 
	// 다시 설명하자면, insertable=false 로 했으므로 JPA가 INSERT 시에 이 필드를 쿼리에 포함하지 않는다.
	// 즉, INSERT INTO tbl_member (...) VALUES (...) 쿼리에서 reg_date 컬럼은 빼라는 말이다.
	// 왜냐하면 columnDefinition = "DATE DEFAULT SYSDATE" 으로 했기 때문에
	// 엔티티 저장(insert)시 reg_date 컬럼을 빼더라도 reg_date 컬럼에는 DB에서 자동적으로 SYSDATE 가 들어가기 때문이다.
	
	// updatable = false 로 설정하면 JPA가 UPDATE 시에도 이 필드는 수정하지 않겠다는 말이다.
	// 즉, UPDATE tbl_member SET reg_date = ? 이런 쿼리는 절대 생성하지 않겠다는 말이다.
	// 즉, 한번 데이터 입력 후 reg_date 컬럼의 값은 수정 불가라는 뜻이다.
	
	
/*	
	@PrePersist	// INSERT 전에 호출한다.	그런데 지금은 위에서 columnDefinition="DATE DEFAULT SYSDATE", insertable = false 을 했으므로 별의미가 없어서 주석처리 했다.
	public void prePersist() {
		this.regDate = this.regDate == null
				? LocalDateTime.now()
				: this.regDate;
	}
*/	
	
	// Entity 를 DTO 로 변환하기
	public MemberDTO toDTO() {
		
		return MemberDTO.builder()
				.userId(this.userId)
				.userName(this.userName)
				.userPwd(this.userPwd)
				.gender(this.gender)
				.regDate(this.regDate)
				.build();
	}
	
}






