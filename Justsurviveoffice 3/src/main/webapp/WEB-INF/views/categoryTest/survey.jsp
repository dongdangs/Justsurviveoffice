<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%
	String ctxPath = request.getContextPath();
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>설문 시작 페이지</title>

<!-- Bootstrap CSS -->
<link rel="stylesheet" href="<%= ctxPath%>/bootstrap-4.6.2-dist/css/bootstrap.min.css" type="text/css">

<%-- Font Awesome 6 Icons --%>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">

<%-- Optional JavaScript --%>
<script type="text/javascript" src="<%=ctxPath%>/js/jquery-3.7.1.min.js"></script>
<script type="text/javascript" src="<%=ctxPath%>/bootstrap-4.6.2-dist/js/bootstrap.bundle.min.js" ></script>
<script type="text/javascript" src="<%=ctxPath%>/smarteditor/js/HuskyEZCreator.js" charset="utf-8"></script>

<%-- 스피너 및 datepicker 를 사용하기 위해 jQueryUI CSS 및 JS --%>
<link rel="stylesheet" type="text/css" href="<%=ctxPath%>/jquery-ui-1.13.1.custom/jquery-ui.min.css" />
<script type="text/javascript" src="<%=ctxPath%>/jquery-ui-1.13.1.custom/jquery-ui.min.js"></script>

<style type="text/css">
	
	.survey-container {
		max-width: 500px;
		margin: 100px auto;
		text-align: center;
		overflow: hidden; /* 슬라이드 이동 시 바깥 내용 숨김 */
	}
	.survey-image {
		border-radius: 12px;
		overflow: hidden;
		margin: 20px 0;
	}
	.btn-start {
		background-color: #4da3ff;
		border: none;
		padding: 12px 24px;
		font-weight: bold;
		border-radius: 25px;
		color: white;
	}
	.btn-start:hover {
		background-color: #368ce8;
	}
	
	/* -- CSS 로딩화면 구현 시작(bootstrap 에서 가져옴) -- */    
	div.loader {
		border: 16px solid #f3f3f3;
		border-radius: 50%;
		border-top: 12px dotted blue;
		border-right: 12px dotted green; 
		border-bottom: 12px dotted red; 
		border-left: 12px dotted pink; 
		width: 120px;
		height: 120px;
		-webkit-animation: spin 2s linear infinite;
		animation: spin 2s linear infinite;
	}
	
	@-webkit-keyframes spin {
		0% { -webkit-transform: rotate(0deg); }
		100% { -webkit-transform: rotate(360deg); }
	}
	
	@keyframes spin {
		0% { transform: rotate(0deg); }
		100% { transform: rotate(360deg); }
	}
	/* -- CSS 로딩화면 구현 끝(bootstrap 에서 가져옴) -- */
	
</style>

</head>
<body style="background-color: #f8f9fa;">
	
	<%-- CSS 로딩화면 구현한것--%>
	<div style="display: flex">
		<div class="loader" style="margin: auto"></div>
	</div>
	
	<div class="survey-container" style="border: solid 2px blue;">
		
		<h4 class="font-weight-bold text-primary">성향 TEST</h4>
		<p class="text-muted">어떤 유형인지 알아보세요.</p>
		
		<div class="survey-image">
			<img src="<%= ctxPath %>/images/mz.png" class="img-fluid">
		</div>
		
		<button type="button" class="btn-start">설문 시작하기</button>
	</div>

<script type="text/javascript">
	
	$(function(){
		
		$('div.loader').hide();	// CSS 로딩화면 감추기
		
		$('button.btn-start').click(function(){
			$('div.survey-container').empty();
			
			surveyStart();	// 설문 내용 호출
		});
		
	});// end of $(function(){})--------------------------------------
	
	
	// Function Declaration
	function surveyStart() {
		
		$.ajax({
			url:"<%= ctxPath%>/categoryTest/surveyStart",
			dataType:"json",
			success:function(json){
			//	console.log(JSON.stringify(json));
				/*
					[{"questionNo": 1,"questionContent": "팀 프로젝트에서 당신의 역할은?",
					"options": [{ "optionNo": 10, "optionText": "리더가 좋다"}
							   ,{ "optionNo": 11, "optionText": "서포터가 편하다"}
					 ]}, ...
					]
				*/
				
				// === 슬라이드 문제 만들기 시작 === //
				let v_html = `<div class="slides" id="slides" style="display:flex; width:100%; transition:transform .35s ease;">`;
				
				$.each(json, function(index, item){
					
					v_html += `
						<div class="slide" style="min-width:100%; padding:10px 20px; box-sizing:border-box;">
							<div class="QNo mt-5 text-danger font-weight-bold" style="font-size: 20pt;">Q\${index + 1}</div>
							<div class="QText my-5 font-weight-bold" style="font-size:1.2rem;">\${item.text}</div>
					`;
					
					$.each(item.options, function(opt_index, opt_item){
						v_html += `
							<button class="opt-btn btn btn-danger btn-lg btn-block my-5" 
										data-qstno="\${index}" 
										data-opt="\${opt_index + 1}"
										data-cat="\${opt_item.categoryNo}">
								\${opt_item.text}
							</button>
						`;
					});
					
					v_html += `
						</div>
					`;
					
				})// end of $.each(json, function(index, item){})-------------------------------------
				
				v_html += `</div>`;
				
				$('div.survey-container').html(v_html);	// 화면에 삽입해주기
				
				const total = json.length;
				const answer_arr = [];
				let nowNumber = 0;	// 현재 보여줄 슬라이드 번호
				
				// 답 관련 버튼 클릭 동적 함수 작성
				$('div.survey-container').on('click', '.opt-btn', function(){
					
					const qstno = Number($(this).data('qstno'));	// 몇 번째 질문인지 체크
					const optionNo = Number($(this).data('cat'));	// 선택한 옵션번호 에 달려있는 카테고리 번호
					answer_arr[qstno] = optionNo;
					
					if(qstno < total - 1){	// 문제에서 버튼 클릭시 다음 슬라이드
						nowNumber = qstno + 1;
						$('#slides').css('transform', `translateX(-\${nowNumber * 100}%)`);
					} 
					else {	// 마지막이면 제출
						submitAnswers(answer_arr);	// 고른 답 제출하기
					}
				});// end of $('div.survey-container').on('click', '.opt-btn', function(){})--------------------------------
				// === 슬라이드 문제 만들기 끝 === //
			},
			error: function(request, status, error){
				alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
			}
		});
		
	}// end of function surveyStart()--------------------------------------
	
	
	// 결과 제출 함수
	function submitAnswers(answer_arr) {
		
		$("div.loader").show(); // CSS 로딩화면 보여주기
		
		$.ajax({
			url:"<%= ctxPath%>/categoryTest/submit",
			method:"POST",
			data:{"answer_arr":answer_arr},
			dataType:"json",
			success:function(json){
			//	console.log(JSON.stringify(json));
				// {"categoryName":"MZ", "categoryImagePath ":"~", "tags":["에어팟필수", "칼퇴", "딴생각장인", "지각러버"]}
				
				$('div.survey-container').empty();
				
				let r_html = `
				<div class="card shadow-sm border-0">
					<img src="<%= ctxPath %>/images/\${json.categoryImagePath}" class="card-img-top" alt="\${json.categoryName}">
				</div>
				
				<div class="bg-primary text-white rounded mt-3 p-3 fw-bold">`;
				
				$.each(json.tags, function(index, item){
					r_html += `#\${item} `;
					if(index % 4 === 3) r_html += `<br>`;
				});// end of $.each(json, function(index, item){})---------------------------
				
				r_html += `
				</div>
				
				<div class="card shadow-sm border-0 mt-4">
					<div class="card-body text-center">
						<h3 class="text-muted mb-1">\${json.categoryName}</h3>
					</div>
				</div>
				
				<div class="mt-4">
					<button class="btn btn-primary btn-lg w-100 fw-bold mb-2" onclick="saveResult()">
						로그인 후 결과 저장하기
					</button>
					<button class="btn btn-outline-primary btn-lg w-100 fw-bold" onclick="retryTest()">
						테스트 다시하기
					</button>
				</div>`;
				
				$('div.survey-container').html(r_html);
				
			},
			error: function(request, status, error){
				alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
			},
			complete: function() {	// 해당 ajax 가 성공하든 실패하든 실행 하는 코드
				$("div.loader").hide(); // CSS 로딩화면 감추기
			}
		});
		
	}// end of function submitAnswers(answer_arr)-------------------------------
	
	
	function saveResult() {
		alert("로그인 후 저장 안만듬!");
	}
	
	
	function retryTest() {
		location.href = '<%= ctxPath %>/categoryTest/survey';
	}
	
</script>

</body>
</html>