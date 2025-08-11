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
	
</style>

</head>
<body style="background-color: #f8f9fa;">
	
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
		
		$('button.btn-start').click(function(){
			$('div.survey-container').empty();
			
			surveyStart();	// 설문 내용 호출
		});
		
	});// end of $(function(){})--------------------------------------
	
	
	// Function Declaration
	function surveyStart() {
		
		$.ajax({
			url:"<%= ctxPath%>/rdg7203Work/surveyStart",
			dataType:"json",
			success:function(json){
				console.log(JSON.stringify(json));
				/*
					[{"questionNo": 1,"questionContent": "팀 프로젝트에서 당신의 역할은?",
					"options": [{ "optionNo": 10, "optionText": "리더가 좋다", "categoryNo": 1}
							   ,{ "optionNo": 11, "optionText": "서포터가 편하다", "categoryNo": 2}
					      	   ]
					}]
				*/
			},
			error: function(request, status, error){
				alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
			}
		});
		
	}// end of function surveyStart()--------------------------------------
	
</script>

</body>
</html>