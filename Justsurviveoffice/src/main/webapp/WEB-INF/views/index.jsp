<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>    

<%
	String ctxPath = request.getContextPath();
	// ctxPath => Justsurviveoffice
%>     
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Spring JPA(Java Persistence API)</title>

<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<link rel="stylesheet" type="text/css" href="<%= ctxPath%>/bootstrap-4.6.2-dist/css/bootstrap.min.css">

<script type="text/javascript" src="<%= ctxPath%>/js/jquery-3.7.1.min.js"></script>
<script type="text/javascript" src="<%= ctxPath%>/bootstrap-4.6.2-dist/js/bootstrap.bundle.min.js" ></script>

<script type="text/javascript">

	$(function(){
		
		$('button.btn-primary').click(function(){
			location.href="<%= ctxPath%>/users/list";
		});
		
        $('button.btn-danger').click(function(){
        	location.href="<%= ctxPath%>/board/list";
		});
		
	});// end of $(function(){})------------------
	
</script>

</head>
<body>
<h1>dkdk</h1>
	<div class="container">
	  <div class="row">
		<div class="col-md-8 offset-md-2 my-5">
		   <h1 class="border text-center py-5">Spring JPA(Java Persistence API)</h1>
		   <c:if test="${not empty sessionScope.loginuser}">
		      <p class="text-center h3 mt-4">
		         ${sessionScope.loginuser.userName}님 로그인중...
		         <a class="btn btn-secondary ml-3" href="<%= ctxPath%>/login/logout" role="button">로그아웃</a>
		      </p> 
		   </c:if>
        </div>
        <div class="col-md-6 text-center">
           <button class="btn btn-primary" style="width: 40%; height: 120px; font-size: 26pt;">회원관리</button>
        </div>
        <div class="col-md-6 text-center">
           <button class="btn btn-danger" style="width: 40%; height: 120px; font-size: 26pt;">게시판</button>
        </div>
	  </div>	   	
	</div>
</body>
</html>