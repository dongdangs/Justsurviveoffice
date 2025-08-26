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
	
</head>
<body>
	<div id="mycontainer">
		<div id="myheader">
			<jsp:include page="../menu/menu1.jsp" />
		</div>
		
		<div id="mycontent">
			<div class="row">
				<div class="col-md-3 d-flex flex-column align-items-center justify-content-start" style="border:solid 2px red;">
					<div>
						<img src="<%=ctxPath%>/images/mz.png" alt="프로필" class="mb-3">
	                	<div class="text-muted small mb-3">${sessionScope.loginUser.email}</div>
		                <div class="mb-3">
		                	<span style="size:20pt; color:blue;">${sessionScope.loginUser.name} 님 </span>
		                    포인트 : <b><fmt:formatNumber value="${sessionScope.loginUser.point}" pattern="#,###"/> point</b>
		                </div>
					</div>
					<div style="width: 70%; margin-top:30%; border: solid 1px green;">
                		<div class="d-flex justify-content-between align-items-center mb-2">
		                   		<h6 style="font-weight: bolder; margin: 0;">대사살 Hot! 게시글</h6>
		                    <a href="<%= ctxPath%>/board/hot/all" class="text-primary" style="font-size: 0.9rem; text-decoration: none;">
		                        
		                    </a>
               			 </div>
                <table class="table table-sm table-borderless">
                    <tbody style="font-size: 10pt;">
                        <c:forEach var="hotRead" items="${hotReadList}">
                            <tr>
                                <td style="width: 5%; font-weight: bold;">
                                    ${hotRead.rank}
                                </td>
                                <td style="width: 95%;">
                                    <a href="<%= ctxPath%>/board/view?categoryNo=${hotRead.fk_categoryNo}&boardNo=${hotRead.boardNo}">
                                        ${hotRead.boardName}
                                    </a>
                                    <span class="text-right text-danger">(${hotRead.readCount})</span>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
            <div style="width: 70%; margin-top:30%; border: solid 1px green;">
                <div class="d-flex justify-content-between align-items-center mb-2">
                    <h6 style="font-weight: bolder; margin: 0;">대사살 댓글많은 게시글</h6>
                    <a href="<%= ctxPath%>/board/hot/all" class="text-primary" style="font-size: 0.9rem; text-decoration: none;">
                        
                    </a>
                </div>
                <table class="table table-sm table-borderless">
                    <tbody style="font-size: 10pt;">
                        <c:forEach var="hotComment" items="${hotCommentList}">
                            <tr>
                                <td style="width: 5%; font-weight: bold;">
                                    ${hotComment.rank}
                                </td>
                                <td style="width: 95%;">
                                    <a href="<%= ctxPath%>/board/view?categoryNo=${hotComment.fk_categoryNo}&boardNo=${hotComment.boardNo}">
                                        ${hotComment.boardName}
                                    </a>
                                    <span class="text-right text-danger">(${hotComment.commentCount})</span>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
					
				</div>
			