<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%
	String ctxPath = request.getContextPath();
%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<script type="text/javascript" src="<%=ctxPath%>/smarteditor/js/HuskyEZCreator.js" charset="utf-8"></script>

<style type="text/css">
	
	.pagination .page-item.active .page-link {
		background-color: #5f5fff;
		border-color: #5f5fff;
	}
	
	table > tbody > tr {
		cursor: pointer;
	}
	
</style>


</head>
<jsp:include page="../header/header2.jsp" />	

	<!-- 박스 -->
	<div class="container mt-4 mb-5 p-5" id="userListBox">
		
		<!-- 영역 -->
		<div class="bg-white rounded-xl shadow-sm p-4 mb-4">
			
			<button type="button" onclick="location.href='<%= ctxPath%>/admin/usersList'" class="btn mr-auto" style="background-color: #5f5fff; color: white;">
					관리자 페이지
				</button>
			
		</div>
		
		<!-- 👥 신고 테이블 -->
		<div class="bg-white rounded-xl shadow-sm mb-4">
			<div class="table-responsive">
				<table class="table table-hover table-bordered text-center" id="userTbl">
					<thead class="thead-light">
						<tr>
							<th>신고번호</th>
							<th>아이디</th>
							<th>게시글제목</th>
							<th>신고사유</th>
							<th>신고날짜</th>
							<th>상태</th>
						</tr>
					</thead>
					<tbody>
						<c:if test="${not empty requestScope.reportDtoList}">
							<c:forEach var="report" items="${requestScope.reportDtoList}" varStatus="status">
								<tr class="user-row userInfo">
									<fmt:parseNumber var="currentShowPageNo" value="${requestScope.currentShowPageNo}" />
									<fmt:parseNumber var="sizePerPage" value="${requestScope.sizePerPage}" />
									<td>
										${(requestScope.totalDataCount) - (currentShowPageNo - 1) * sizePerPage - (status.index)}
										<input type="hidden" name="reportNo" value="${report.reportNo}" />
										</td>
									<td>${report.fk_id}</td>
									<td>
										<c:choose>
											<c:when test="${fn:length(report.board.boardName) < 10}">
												${report.board.boardName}
											</c:when>
											<c:otherwise>
												${fn:substring(report.board.boardName, 0, 10)}...
											</c:otherwise>
										</c:choose>
										<input type="hidden" name="boardNo" value="${report.board.boardNo}" />
									</td>
									<td>${report.reportReason}</td>
									<td><c:out value="${fn:replace(report.createdAtReport, 'T', ' ')}"/></td>
									<td>
										<c:if test="${report.reportStatus == 0}">
											<button type="button" name="wait" class="btn btn-primary">접수</button>
										</c:if>
										
										<c:if test="${report.reportStatus != 0}">
											<button name="success" class="btn btn-success">완료</button>
										</c:if>
									</td>
								</tr>
							</c:forEach>
						</c:if>
						<c:if test="${empty requestScope.reportDtoList}">
							<tr>
								<td colspan="6" class="text-center text-muted">데이터가 존재하지 않습니다.</td>
							</tr>
						</c:if>
					</tbody>
				</table>
			</div>
		</div>
		
		<!-- 페이지네이션 -->
		<div class="bg-white rounded shadow-sm p-3" >
			<div class="d-flex justify-content-center align-items-center flex-wrap">
				<ul class="pagination justify-content-center justify-content-sm-end mb-0">
					${requestScope.pageBar}
				</ul>
			</div>
		</div>
		
	</div>
	
<form name="report_frm">
	<input type="hidden" name="boardNo" />
</form>


<script type="text/javascript">
	
	$(function(){
		
		// === 클릭시 상세 페이지 이동 === //
		$(document).on('click', 'table > tbody > tr', function(e) {
			
			if ($(e.target).is('button') || $(e.target).closest('button').length) {
				
				if(confirm("접수 완료 하시겠습니까?")) {
					
					const reportNo = $(this).find('input[name="reportNo"]').val();
					
					$.ajax({
						url:"<%= ctxPath%>/admin/reportComplete",
						data:{"reportNo":reportNo},
						success:function(n){
							if(n == 1){
								alert("완료!");
								location.reload();
							}
							else {
								alert("실패!");
							}
						},
						error: function(request, status, error){
							console.log("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
						} 
					});
					
					return;
				}
				else {
					return;
				}
			}
			
			const boardNo = $(this).find('input[name="boardNo"]').val();
		//	alert(boardNo);
			
			const frm = document.report_frm
			frm.boardNo.value = boardNo;
			frm.action = "<%= ctxPath%>/board/view";
			frm.submit();
		});
		
	});// end of $(function(){})-----------------------------
	
	
	// Function Declaration
	
</script>

