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

<jsp:include page="../header/header1.jsp" />

<script type="text/javascript">
$(function(){
	
	
});  // end of $(function()}{})

function goView(boardNo){
	 const frm = document.goViewFrm;
	 frm.boardNo.value = boardNo;
	 
	 frm.method = "post";
	 frm.action = "<%= ctxPath%>/board/view";
	 frm.submit();
}
</script>

<div class="mainContainer mt-4">
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
					<h6 style="font-weight: bolder;">대사살 Hot! 게시글</h6>
					<table class="table table-sm table-borderless">
						<tbody style="font-size: 10pt;">
							<tr>
								<td style="width: 5%; font-weight: bold;">01</td>
								<td style="width: 95%;">hot 게시글 1등 제목입니다.~~~~~~~<span class="text-right text-danger">(4)</span></td>
							</tr>
							<tr>
								<td style="width: 5%; font-weight: bold;">02</td>
								<td style="width: 95%;">hot 게시글 2등 제목입니다.!!!!!!!!!!!!!!!!!!!!<span class="text-right text-danger">(9)</span></td>
							</tr>
							<tr>
								<td style="width: 5%; font-weight: bold;">03</td>
								<td style="width: 95%;">hot 게시글 3등 제목입니다.#######<span class="text-right text-danger">(9)</span></td>
							</tr>
							<tr>
								<td style="width: 5%; font-weight: bold;">04</td>
								<td style="width: 95%;">hot 게시글 4등 제목입니다.<span class="text-right text-danger">(9)</span></td>
							</tr>
							<tr>
								<td style="width: 5%; font-weight: bold;">05</td>
								<td style="width: 95%;">hot 게시글 5등 제목입니다.<span class="text-right text-danger">(9)</span></td>
							</tr>
							<tr>
								<td style="width: 5%; font-weight: bold;">06</td>
								<td style="width: 95%;">hot 게시글 6등 제목입니다.~~~~~~~<span class="text-right text-danger">(4)</span></td>
							</tr>
							<tr>
								<td style="width: 5%; font-weight: bold;">07</td>
								<td style="width: 95%;">hot 게시글 7등 제목입니다.!!!!!!!!!!!!!!!!!!!!<span class="text-right text-danger">(9)</span></td>
							</tr>
							<tr>
								<td style="width: 5%; font-weight: bold;">08</td>
								<td style="width: 95%;">hot 게시글 8등 제목입니다.#######<span class="text-right text-danger">(9)</span></td>
							</tr>
							<tr>
								<td style="width: 5%; font-weight: bold;">09</td>
								<td style="width: 95%;">hot 게시글 9등 제목입니다.<span class="text-right text-danger">(9)</span></td>
							</tr>
							<tr>
								<td style="width: 5%; font-weight: bold;">10</td>
								<td style="width: 95%;">hot 게시글 10등 제목입니다.<span class="text-right text-danger">(9)</span></td>
							</tr>
						</tbody>
					</table>
				</div>
				
				<div class="mt-5" style="width: 70%; border: solid 1px green;">
					<h6 style="font-weight: bolder;">대사살 댓글많은 게시글</h6>
					<table class="table table-sm table-borderless">
						<tbody style="font-size: 10pt;">
							<tr>
								<td style="width: 5%; font-weight: bold;">01</td>
								<td style="width: 95%;">댓글많은 게시글 1등 제목입니다.~~~<span class="text-right text-danger">(100)</span></td>
							</tr>
							<tr>
								<td style="width: 5%; font-weight: bold;">02</td>
								<td style="width: 95%;">댓글많은 게시글 2등 제목입니다.!!!!<span class="text-right text-danger">(55)</span></td>
							</tr>
							<tr>
								<td style="width: 5%; font-weight: bold;">03</td>
								<td style="width: 95%;">댓글많은 게시글 3등 제목입니다.@@@@<span class="text-right text-danger">(55)</span></td>
							</tr>
							<tr>
								<td style="width: 5%; font-weight: bold;">04</td>
								<td style="width: 95%;">댓글많은 게시글 4등 제목입니다.####<span class="text-right text-danger">(55)</span></td>
							</tr>
							<tr>
								<td style="width: 5%; font-weight: bold;">05</td>
								<td style="width: 95%;">댓글많은 게시글 5등 제목입니다.$$$$$<span class="text-right text-danger">(55)</span></td>
							</tr>
							<tr>
								<td style="width: 5%; font-weight: bold;">06</td>
								<td style="width: 95%;">댓글많은 게시글 6등 제목입니다.~~~<span class="text-right text-danger">(100)</span></td>
							</tr>
							<tr>
								<td style="width: 5%; font-weight: bold;">07</td>
								<td style="width: 95%;">댓글많은 게시글 7등 제목입니다.!!!!<span class="text-right text-danger">(55)</span></td>
							</tr>
							<tr>
								<td style="width: 5%; font-weight: bold;">08</td>
								<td style="width: 95%;">댓글많은 게시글 8등 제목입니다.@@@@<span class="text-right text-danger">(55)</span></td>
							</tr>
							<tr>
								<td style="width: 5%; font-weight: bold;">09</td>
								<td style="width: 95%;">댓글많은 게시글 9등 제목입니다.####<span class="text-right text-danger">(55)</span></td>
							</tr>
							<tr>
								<td style="width: 5%; font-weight: bold;">10</td>
								<td style="width: 95%;">댓글많은 게시글 10등 제목입니다.$$$$$<span class="text-right text-danger">(55)</span></td>
							</tr>
						</tbody>
					</table>
				</div>
				
			</div>
			<p>
			<div class="col-md-9" style="background-image: url('<%= ctxPath %>/images/background.png'); border: solid 2px blue;">
					<c:forEach var="boardDTO" items="${mapList}">
							<div onclick="goView('${boardDTO.boardNo}')">
								<div class="boardTab" style="background-color:#fff;">
								  <p class="boardName">${boardDTO.boardName}</p>
								  <p class="boardCont">${boardDTO.boardContent}</p>
								  <p class="boardWritt" style="padding-bottom:10px;">${boardDTO.name}</p>
								  <div style="display:flex;justify-content:space-between;">
									  <p class="boardWritt">조회수:&nbsp;${boardDTO.readCount}&nbsp;회</p>
									  <p class="boardDate" style="text-align:right;"></p>
								  </div>
								</div>
							</div>
					</c:forEach>
				</a>
			</div>
			
		</div>
	</div>

<form name="goViewFrm">
	  <input type="hidden" name="boardNo" />
	  <input type="hidden" name="boardWritt" />
</form>