package com.spring.app.opendata.domain;

import lombok.Getter;
import lombok.Setter;

// == Lombok 라이브러리에서 제공하는 어노테이션 == 
@Getter                  // private 으로 설정된 필드 변수를 외부에서 접근하여 사용하도록 getter()메소드를 만들어 주는 것.
@Setter                  // private 으로 설정된 필드 변수를 외부에서 접근하여 수정하도록 setter()메소드를 만들어 주는 것.
// @ToString                // 객체를 문자열로 표현할 때 사용
// @RequiredArgsConstructor // final 이거나 @NonNull이 붙은 필드만 포함하는 생성자를 자동으로 생성해준다.
// @AllArgsConstructor      // 모든 필드 값을 파라미터로 받는 생성자를 만들어주는 것
// @NoArgsConstructor       // 파라미터가 없는 기본생성자를 만들어주는 것
// @Data                    // lombok 에서 사용하는 @Data 어노테이션은 @Getter, @Setter, @ToString, @EqualsAndHashCode, @RequiredArgsConstructor 를 모두 합쳐놓은 종합선물세트인 것이다.
public class Seoul_bicycle_rental_DTO {

	private String rntls_id;  // 대여소_ID
	private String addr1;     // 주소1
	private String addr2;     // 주소2
	private double lat;       // 위도
	private double lot;       // 경도
		
}
