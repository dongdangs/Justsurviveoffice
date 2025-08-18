<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
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
    <script type="text/javascript" src="<%=ctxPath%>/smarteditor/js/HuskyEZCreator.js" charset="utf-8"></script>

	<%-- 스피너 및 datepicker 를 사용하기 위해 jQueryUI CSS 및 JS --%>
    <link rel="stylesheet" type="text/css" href="<%=ctxPath%>/jquery-ui-1.13.1.custom/jquery-ui.min.css" />
    <script type="text/javascript" src="<%=ctxPath%>/jquery-ui-1.13.1.custom/jquery-ui.min.js"></script>
	
</head>
<body>
	<div id="mycontainer">
		<div id="myheader">
			<jsp:include page="../menu/menu1.jsp" />
		</div>
		
		<div id="mycontent">
