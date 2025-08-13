$(function() {

	$.ajax({
		url: "/myMVC/shop/categoryListJSON.up",
		/*data:"", where절이고 몽땅다 들고올거라서 필요없음*/
		// url 작성하고 command properties 작성
		dataType: "json",
		success: function(json) {

			/*
			console.log("===확인용 JSON :", JSON.stringify(json));
			/*
			결과물이 3개가 나올예정 => 배열로
			1 100000 전자제품
			2 200000 의류
			3 300000 도서
			==== 확인용 json => [
							   {"cnum":1, "code":"100000", "cname":"전자제품"},
							   {"cnum":2, "code":"200000", "cname":"의류"},
							   {"cnum":3, "code":"300000", "cname":"도서"}
							   ]
			*/
			let v_html = ``;

			if (json.length == 0) {
				v_html = `현재 카테고리 준비중입니다.`
				$('div#categoryList').html(v_html);
			}

			else if (json.length > 0) {
				v_html = ` <div style="width: 95%; margin: 0 auto;">
				                        <div style="border: solid 1px gray;
				                                    padding-top: 5px;
				                                    padding-bottom: 5px;
				                                    text-align: center;
				                                    color: navy;
				                                    font-size: 14pt;
				                                    font-weight: bold;">
				                            CATEGORY LIST
				           				</div>
				           				<div style="border: solid 1px gray;
				                                    border-top: hidden;
				                                    padding-top: 5px;
				                                    padding-bottom: 5px;
				                                    text-align: center;">
				           						<a href="mallHomeMore.up">전체</a>&nbsp;&nbsp;`;
						 /*   
						   // 자바스크립트 사용하는 경우
						   json.forEach(function(item, index, array){
						      
						   });
						               
						   // jQuery 를 사용하는 경우
						      $.each(json, function(index, item){
						                  
						   });
						 */
						$.each(json, function(index, item){
							
							// 빨리 빨리 넘겨줘야해서 get방식 
							v_html += `<a href="/myMVC/shop/mallByCategory.up?cnum=${item.cnum}">${item.cname}</a>&nbsp;&nbsp; `;
							 
						}); // end of $.each(json, function(index, item){ 
							
							
						v_html += `</div>
								  </div>`;
								  
						$('div#categoryList').html(v_html);
						//카테고리 선택자는 header1.jsp에 있다.
						
						   
			}// end of if(json.length>0);
			
			
		},
		error: function(request, status, error) {
			alert("code: " + request.status + "\n" + "message: " + request.responseText + "\n" + "error: " + error);
		}
	});

});