<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<% 
  String ctxPath = request.getContextPath(); 
%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- Required meta tags -->
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
 
<!-- Bootstrap CSS -->
<link rel="stylesheet" type="text/css" href="<%= ctxPath%>/bootstrap-4.6.2-dist/css/bootstrap.min.css" > 

<!-- Font Awesome 6 Icons -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.1/css/all.min.css">

<!-- Optional JavaScript -->
<script type="text/javascript" src="<%= ctxPath%>/js/jquery-3.7.1.min.js"></script>
<script type="text/javascript" src="<%= ctxPath%>/bootstrap-4.6.2-dist/js/bootstrap.bundle.min.js" ></script> 

<%-- jQueryUI CSS 및 JS --%>
<link rel="stylesheet" type="text/css" href="<%= ctxPath%>/jquery-ui-1.13.1.custom/jquery-ui.min.css" />
<script type="text/javascript" src="<%= ctxPath%>/jquery-ui-1.13.1.custom/jquery-ui.min.js"></script>

<%-- <jsp:include page="../header.jsp" /> --%>

<style type="text/css">
	
	body {
	  	background-color: #9da6ae;
	  	background-image: url("<%= ctxPath%>/images/background.png");
	  	background-size: cover;
	  	background-position: center;
	  	background-attachment: fixed;
	  	background-blend-mode: overlay;
	  	background-repeat:no-repeat;
	}
	
	#headerNav {
	  	position: relative;
	}
	
	/* 전체 컨테이너 */
	#idFindWrap {
	  	margin: 7% auto 17%;
	  	max-width: 500px;
	  	width: 100%;
	}
	
	/* 상단 타이틀 */
	#idTitle {
	  	text-align: center;
	  	padding: 4% 0;
	  	background: #bf83fb;
	  	color: #fff;
	  	border-top-left-radius: 10px;
	  	border-top-right-radius: 10px;
	  	margin-bottom: 1%;
	  	font-weight: 600;
	  	font-size: 15pt;
	}
	
	/* 폼 박스 */
	#idFindFrm {
	  	border: 1px solid #ddd;
	  	border-radius: 10px;
	  	background-color: #fff;
	  	padding-bottom: 10px;
	}
	
	/* 라인별 입력 영역 */
	#idFindFrm .inputRow {
	  	display: flex;
	  	align-items: center;
	  	padding: 15px 25px;
	}
	
	/* 라벨 */
	#idFindFrm .inputRow label {
	  	width: 80px;
	  	font-weight: 500;
	  	margin: 0;
	}
	
	/* 인풋박스 */
	#idFindFrm .inputRow input {
	  	flex: 1;
	  	padding: 8px 10px;
	  	font-size: 1rem;
	  	margin-left: 15px;
	  	border: 1px solid #ccc;
	  	border-radius: 5px;
	}
	
	/* 버튼 영역 */
	#submitBtnBox {
	  	text-align: center;
	}
	
	/* 버튼 */
	#submitBtn {
	  	width: 30%;
	  	margin: 10px auto 25px;
	  	text-align: center;
	  	background-color: #4f46e5; !important;
	  	border: 0px solid #fff !important;
	  	padding: 8px 0;
	  	font-weight: 600;
	  	color: white;
	}
	
	#div_findResult {padding:20px 0 0;text-align:center;}
</style>

<script type="text/javascript" >

	$(function(){

   		const method = "${requestScope.method}";

   		if(method == "GET") {
      		$('div#div_findResult').prop('hidden', true);
   		} 
   		
   		else {
      		$('div#div_findResult').prop('hidden', false);
      		$('input:text[name="name"]').val("${requestScope.name}");
      		$('input:text[name="email"]').val("${requestScope.email}");
      		<%-- idfind class파일에서 setAttribute에서 name과 email을 넘겨줘서 여기서 쓸 수 있었다.--%>
   		} 

	   	$('button.btn-success').click(function(){
	      	goFind();
	   	});
   
   		$('input:text[name="email"]').bind('keyup',function(e){
      		if(e.keyCode == 13){
         		goFind();
      		}
   		});
   
	}); 
	
	
 	function goFind() {
   
   		const name = $('input:text[name="name"]').val().trim();
   		if (name == ""){
      		alert('성명을 입력하십시오.');
      		return; 
   		}
   
   		const email = $('input:text[name="email"]').val();
   
   		const regExp_email = /^[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*\.[a-zA-Z]{2,3}$/i;
   
   		if ( !regExp_email.test(email) ){
      		// 이메일이 정규표현식에 위배된 경우
      		alert('이메일을 올바르게 입력하십시오.');
      		return; // goFind() 함수종료
   		}
   
   		// 다 올바른 경우
   		const frm = document.idFindFrm;
   		frm.action = "<%= ctxPath%>/users/idFind";
   		frm.method = "POST";
   		frm.submit();
	}

 	function form_reset_empty(){
       	document.querySelector('form[name="idFindFrm"]').reset();
       	$('div#div_findResult').empty(); 
       	<%-- 해당 태그내에 값들을 싹 비우는것.--%>
	}

</script>

<div id="idFindWrap">
  	<form id="idFindFrm" name="idFindFrm" style="position:relative;">
  		<p style="background-image:url('<%= ctxPath%>/images/backIco.png');position:absolute;top:21px;left:10px;width:30px;height:30px;z-index:10;background-size:cover;cursor:pointer;" onclick="location.href='http://localhost:9089/justsurviveoffice/'"></p>
    	<p id="idTitle">아이디 찾기</p>

	    <div class="inputRow">
	      	<label for="name">성명</label>
	      	<input type="text" name="name" id="name" />
	    </div>

	    <div class="inputRow">
	      	<label for="email">이메일</label>
	      	<input type="text" name="email" id="email" />
	    </div>

	    <div class="submitBtn" style="text-align:center;">
	      	<button type="button" class="btn btn-success" onclick="goFind()" style="background-color:#c084fc !important;border:0px solid #fff !important;width:30%;">찾기</button>
	   	</div>

	   <div id="div_findResult">
		  <c:if test="${not empty requestScope.usersDTO}">
		    아이디는 <strong style="color:#000; font-size:16pt;">${requestScope.usersDTO}</strong> 입니다.
		  </c:if>
		  <c:if test="${empty requestScope.usersDTO}">
		    <p>입력하신 정보와 일치하는 아이디가 없습니다.</p>
		  </c:if>
		</div>
  	</form>
</div>

<%-- <jsp:include page="../footer.jsp" /> --%>





