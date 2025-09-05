<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<jsp:include page="../header/header1.jsp" />
<%
    String ctxPath = request.getContextPath();
%>    
<style>
 #mycontent{padding:0 !important;}
 #leftSess {display:none !important;}
 .companyTop {background-image:url("<%=ctxPath %>/images/footerBanner.png");background-size:cover;width:100%;height:100%;padding:5% 0;text-align:center;color:#fff;background-position:center;}
 .cpTop {font-size:2rem;line-height:2.6rem;font-weight:600;}
 .cpInfo {font-size:1.2rem;}

</style>
<body>
	<div class="companyTop">
		<h2 class="cpTop">대사살</h2>
		<article class="cpInfo">신입들과 직장인들이 모여 자유롭게 얘기할 수 있는 커뮤니티 사이트입니다.</article>
	</div>
</div>        
<jsp:include page="../footer/footer1.jsp" />