<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    
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
<jsp:include page="../header/header1.jsp" />
<script type="text/javascript">
$(function(){
	
	const nextVals = ${boardDTO.nextNo};
	
	if(nextVals == 0) {
		$('div#nextBtn').hide();
	}
	
	const preVals = ${boardDTO.preNo};
	
	if(preVals == 0) {
		$('div#prevBtn').hide();
	}
	
});  // end of $(function()}{})

function goViewA(){
	 const frm = document.goViewFrm;
	 frm.boardNo.value = ${boardDTO.preNo};
	 
	 frm.method = "post";
	 frm.action = "<%= ctxPath%>/board/view";
	 frm.submit();
}

function goViewB(){
	 const frm = document.goViewFrm;
	 frm.boardNo.value = ${boardDTO.nextNo};
	 
	 frm.method = "post";
	 frm.action = "<%= ctxPath%>/board/view";
	 frm.submit();
}
</script>
<div style="padding-top:100px;">
	<p>제목 : ${boardDTO.boardName}</p>
	<p>글쓴이 :${boardDTO.fk_id}</p>
	<p>내용: ${boardDTO.boardContent}</p>		
	<div class="Boardpagination">
			<div id="prevBtn" class="prevBtn" onclick="goViewA('${boardDTO.preNo}')" style="cursor:pointer;">이전글: ${boardDTO.preName}</div>
			<div id="nextBtn" class="nextBtn" onclick="goViewB('${boardDTO.nextNo}')" style="cursor:pointer;">다음글: ${boardDTO.nextName}</div>
		</div>
	<form name="goViewFrm">
	    <input type="hidden" name="boardNo" />
		<input type="hidden" name="boardWritt" />
	</form>
	<input type="hidden" id="preNo" name="preNo"  val="${boardDTO.preNo}" />
	<input type="hidden" id="NextNo" name="nextNo" val="${boardDTO.nextNo}" />
</div>