<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
    
<%
    String ctxPath = request.getContextPath();
    //     /myspring
%>    
    
<!DOCTYPE html>
<html>
<head>
	<%-- Required meta tags --%>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
	<title>대사살 (대충사무실에서살아남기)</title>

    <%-- Bootstrap CSS --%>
    <link rel="stylesheet" href="<%= ctxPath%>/bootstrap-4.6.2-dist/css/bootstrap.min.css" type="text/css">

    <%-- Font Awesome 6 Icons --%>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
  
    <%-- 직접 만든 CSS 1 --%>
    <link rel="stylesheet" type="text/css" href="<%=ctxPath%>/css/style1.css" />
    <link rel="stylesheet" type="text/css" href="<%=ctxPath%>/css/common.css" />
    
    <%-- Optional JavaScript --%>
    <script type="text/javascript" src="<%=ctxPath%>/js/jquery-3.7.1.min.js"></script>
    <script type="text/javascript" src="<%=ctxPath%>/bootstrap-4.6.2-dist/js/bootstrap.bundle.min.js" ></script>

	<%-- 스피너 및 datepicker 를 사용하기 위해 jQueryUI CSS 및 JS --%>
    <link rel="stylesheet" type="text/css" href="<%=ctxPath%>/jquery-ui-1.13.1.custom/jquery-ui.min.css" />
    <script type="text/javascript" src="<%=ctxPath%>/jquery-ui-1.13.1.custom/jquery-ui.min.js"></script>
	
	<style>
		.col-md-2 ul {height:100%;background-color:green;display:flex;}
		.admTab {width:100%;background-color:#d5d5d5; display:block;color:#000;border-bottom:1px solid #5f0f0f;padding:1.5% 0; text-align:center;}
		.admTab:hover {background-color:#fff;}
	</style>
</head>
<script type="text/javascript">
	$(function(){
		
		updateClock();
		setInterval(updateClock, 1000);
		
	}) // end of function(){}
	
	function admOut(){
	   if(confirm('로그아웃 하시겠어요?')) {
	     location.href = '<%= ctxPath %>/users/logout';
	   }
	 }
	 
	 function updateClock() {
	   const now = new Date();
	   const daysOfWeek = ["일","월","화","수","목","금","토"];
	   const dayOfWeek = daysOfWeek[now.getDay()];
	   const year = now.getFullYear();
	   const month = String(now.getMonth() + 1).padStart(2, '0');
	   const day = String(now.getDate()).padStart(2, '0');
	   const minutes = String(now.getMinutes()).padStart(2, '0');
	   const seconds = String(now.getSeconds()).padStart(2, '0');

	   const hours24 = now.getHours();
	   const ampm = hours24 >= 12 ? 'PM' : 'AM';
	   const displayHours = (hours24 % 12) || 12;

	   var timeString =
	       year + '-' + month + '-' + day +
	       ' (' + dayOfWeek + ') ' +
	       displayHours + ':' + minutes + ':' + seconds + ' ' + ampm;

	   var el = document.getElementById('clock');
	   if (el) el.textContent = timeString;
	 }


</script>
<body>
	<div id="mycontainer" style="padding:0;">
		<div class="row">
			<div class="col-md-12">
				<ul style="border-right:1px solid #000;display:flex;">
				  <li class="admTab" style="background-image: url(/justsurviveoffice/images/logo2.png);display: block;background-size: contain;background-repeat: no-repeat;background-position: center;cursor:pointer;"
				  		onclick="location.href='<%=ctxPath %>/index'"></li>
				  <%-- <li class="admTab">${sessionScope.loginUser.name}</li> --%>
				  <li class="admTab"><i class="fa-solid fa-chart-simple"></i>&nbsp;<a href="chart">회원 통계보기</a></li>
				  <li class="admTab"><i class="fa-solid fa-user"></i>&nbsp;<a href="usersList">사용자 관리</a></li>
				  <li class="admTab"><i class="fa-solid fa-user"></i>&nbsp;<a href="userExcelList">회원목록 엑셀</a></li>
				  <li class="admTab admOut"  onclick="admOut()"><i class="fa-solid fa-house">&nbsp;</i>로그아웃</li>
				  <li class="admTab"><i class="fa-solid fa-rotate-left"></i><a href="javascript:history.back();">&nbsp;뒤로가기</a></li>
				  <li class="admTab"><div id="clock"></div></li>
				</ul>
			</div>