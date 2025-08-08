$(function(){
	
	$('td#error').hide();
	
	// [충전결제하기] 에 마우스를 올리거나 마우스를 빼면
	// $('td#purchase').hover( 마우스 오버, 마우스 아웃); 
	$('td#purchase').hover(function(e){
		$(e.target).addClass("purchase"); // 마우스를 올라간 곳에 purchase클래스의 css를 준다.
		
	},function(e){
		$(e.target).removeClass("purchase");
	});
	
	/////////////////////////////////////
	
	$('input:radio[name="coinmoney"]').bind('click',function(e){
		
		const index = $('input:radio[name="coinmoney"]').index($(e.target));
		// console.log("=== 확인용 index : " + index);
		
		// === 확인용 index : 0
		// === 확인용 index : 1
		// === 확인용 index : 2
		// 자바스크립트에서 태그는 객체이다. 노드리스트
		$('td > span').removeClass("stylePoint");
		$('td > span').eq(index).addClass("stylePoint");
		
		// 전체에서 1개를 주고싶으면 1. 전부 없애버린다. 2. 선택된 요소로만 추가한다
		
		// $("td>span").eq(index); ==> $("td>span")중에 index 번째의 요소인 
		// 엘리먼트를 선택자로 보는 것이다.
		// $("td>span")은 마치 배열로 보면 된다. $("td>span").eq(index) 
		// 은 배열중에서 특정 요소를 끄집어 오는 것으로 보면 된다. 예를 들면 arr[i] 와 비슷한 뜻이다.
	});
	
}); // end of $(function(){}) =================

// [충전결제하기] 를 클릭했을 때 이벤트 처리하기
function goCoinPayment(ctxPath,userid){
	
	const checked_cnt = $('input:radio[name="coinmoney"]:checked').length;
	
	if(checked_cnt == 0){
		//결제금액을 선택안한 경우
		
		$('td#error').show();
		return; //종료	
	}
	else {
		// 결제하러 들어감
		// 충전금액이 얼마인지 알아봐야 함. value값 선택	
		
		const coinmoney = $('input:radio[name="coinmoney"]:checked').val();
		// alert(`${coinmoney}원 결제가 됩니다.`);
		
		/*  === 팝업창에서 부모창 함수 호출하는 방법 3가지 (오프너)
			1-1. 일반적인 방법
		    opener.location.href = "javascript:부모창스크립트 함수명();";
		                        
		    1-2. 일반적인 방법
		    window.opener.부모창스크립트 함수명();

		    2. jQuery를 이용한 방법
		    $(opener.location).attr("href", "javascript:부모창스크립트 함수명();");
		
		*/
		
		// 해당 시트 기준 login.js 
		
		// opener.location.href = "javascript:test()"; login.js 에 test 헤헤헤가 나온다.
		opener.location.href = `javascript:goCoinPurchaseEnd("${ctxPath}", 
							   "${coinmoney}", "${userid}")`;
		
		self.close(); // 자신의 팝업창을 닫는것이다.
	}
	
}; // end of function goCoinPayment(ctxPath,userid){