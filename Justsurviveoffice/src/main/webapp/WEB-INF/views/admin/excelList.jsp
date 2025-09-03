<%@ page language="java" contentType="text/html; charset=UTF-8" 
	pageEncoding="UTF-8"%> 
	
<% 
	String ctxPath = request.getContextPath(); 
%>
	
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 

<jsp:include page="../header/header2.jsp" /> 

<style> 
	.table-container { margin-top: 20px; } 
	table { width: 100%; border-collapse: collapse; } 
	th, td { border: 1px solid #ccc; padding: 8px; text-align: center; } 
	th { background-color: #f0f0f0; } .action-buttons { margin: 15px 0; } 
</style> 

<div class="col-md-10"> 
	<div style="width:100%; min-height:700px; margin:auto;"> 
		<h2>가입자 통계</h2> 
		
		<!-- ✅ 통계 종류 + 월 선택 -->
		<form id="searchForm" method="get" action="<%= ctxPath%>/admin/userExcelList">
		  <label for="chartSelect">통계 종류: </label>
		  <select id="chartSelect" name="chart" onchange="this.form.submit()">
		    <option value="register" ${chart eq 'register' ? 'selected' : ''}>월별 가입자 통계</option>
		    <option value="registerDay" ${chart eq 'registerDay' ? 'selected' : ''}>일자별 가입자 통계</option>
		  </select>
		
		  <!-- ✅ 일자별 통계일 때만 월 선택 표시 -->
		  <c:if test="${chart eq 'registerDay'}">
			  <label for="monthSelect">월: </label>
			  <select id="monthSelect" name="month" onchange="this.form.submit()">
			    <c:forEach var="m" begin="1" end="12">
			      <option value="${m < 10 ? '0' + m : m}" ${m eq month ? 'selected' : ''}>${m}월</option>
			    </c:forEach>
			  </select>
			</c:if>
		</form>
		
		
		<!-- ✅ 엑셀 다운로드 버튼 --> 
		<div class="action-buttons"> 
		  <form id="downloadForm" method="post">
		    <input type="hidden" name="chart" value="${chart}" />
		    <input type="hidden" name="month" value="${month}" />
		    <button type="button" id="btnExcel">엑셀 다운로드</button>
		  </form>
		</div>
		
		<!-- ✅ 데이터 테이블 --> 
		<div class="table-container"> 
			<table id="statTable"> 
				<thead> 
					<tr> 
						<c:choose> 
							<c:when test="${chart eq 'register'}">
								<th>월</th>
							</c:when> 
							<c:when test="${chart eq 'registerDay'}">
								<th>일</th>
							</c:when> 
						</c:choose> 
						<th>가입자 수</th> 
						<th>퍼센티지</th> 
					</tr> 
				</thead> 
				<tbody> 
					<c:forEach var="row" items="${list}"> 
						<tr> 
							<c:choose> 
								<c:when test="${chart eq 'register'}">
									<td>${row.mm}</td>
								</c:when> 
								<c:when test="${chart eq 'registerDay'}">
									<td>${row.dd}</td>
								</c:when> 
							</c:choose> 
							<td class="cnt">${row.cnt}</td> 
							<td class="pct">${row.pct}</td> 
						</tr> 
					</c:forEach> 
				</tbody> 
				<tfoot>
				  <tr>
				    <th>합계</th>
				    <th id="totalCnt">
				      <c:choose>
				        <%-- 서버에서 내려준 total 있을 때 --%>
				        <c:when test="${not empty total}">
				          <fmt:formatNumber value="${total}" type="number"/>명
				        </c:when>
				        <%-- 조회 모드에서는 JS가 계산 --%>
				        <c:otherwise></c:otherwise>
				      </c:choose>
				    </th>
				    <th id="totalPct">
				      <c:choose>
				        <c:when test="${not empty total and total ne 0}">100.00%</c:when>
				        <c:otherwise>0.00%</c:otherwise>
				      </c:choose>
				    </th>
				  </tr>
				</tfoot>
			</table> 
		</div> 
	</div> 
</div> 

<script>
$(function() {
    let total = 0;

    // 합계 계산
    $('#statTable tbody tr').each(function() {
        const cnt = parseInt($(this).find('.cnt').text()) || 0;
        total += cnt;
    });

    // 퍼센티지 채우기
    $('#statTable tbody tr').each(function() {
        const cnt = parseInt($(this).find('.cnt').text()) || 0;
        const pct = total === 0 ? 0 : (cnt * 100 / total);
        $(this).find('.pct').text(pct.toFixed(2) + '%');
    });

    // 합계 표시
    $('#totalCnt').text(total.toLocaleString() + "명");

    // ✅ 총합이 0이면 0.00%, 아니면 100.00%
    $('#totalPct').text(total === 0 ? '0.00%' : '100.00%');
    
    $('#btnExcel').click(function(){
        const frm = document.getElementById("downloadForm");
        frm.action = "<%= ctxPath%>/admin/downloadExcelFile";
        frm.submit();
     });
});
</script>

