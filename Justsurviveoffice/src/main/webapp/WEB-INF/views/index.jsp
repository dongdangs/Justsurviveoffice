<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
    String ctxPath = request.getContextPath();
    //     /justsurviveoffice
%>

<jsp:include page="header/header1.jsp" />
	
<div class="col-md-9" style="background-image: url('<%= ctxPath %>/images/background.png');display:flex;justify-content:center;">
				
				<div class="row" style="width: 90%; margin: 5%">
				<!-- 테스트 카드 (고정) -->
				    <div class="col-md-4 mb-4">
						<a href="<%= ctxPath%>/categoryTest/survey" class="card text-decoration-none h-100" style="background-color: #3C396B; border-radius: 15px">
							<div style="margin: 5% 5%; height:60%;">
								<img src="<%= ctxPath%>/images/unassigned.png" class="card-img-top" alt="테스트" style="width:100%; height:100%; object-fit:cover;">
							</div>
							<div class="card-body">
								<h4 class="card-title" style="font-weight: bold; color: #39FF14;">테스트</h4>
								<p class="card-text" style="color: white;">당신의 성향을 알아보세요!</p>
							</div>
						</a>
					</div>
					<%-- begin과 end로 1번부터 5번 카테고리 1 증감식으로 수정함 0825 --%>
					<c:forEach var="indexList" items="${IndexList}" begin="0" end="4" step="1">
					  <div class="col-md-4 mb-4">
						<a href="<%= ctxPath%>/board/list/${indexList.categoryNo}" class="card text-decoration-none h-100" style="background-color: #3C396B; border-radius: 15px">
						  	<div style= "margin: 5% 5%;height: 60%;">
						  		<img src="${pageContext.request.contextPath}/images/${indexList.categoryImagePath}" alt="${indexList.categoryDTO.categoryName}" 
						  					style="width:100%; height:100%; object-fit:cover; border-radius: 10px">
						  	</div>
						  	<div class="card-body">
						      <h4 class="card-title" style="font-weight: bold; color: #39FF14;">${indexList.categoryName}</h4>
						      <p class="card-text" style="color: white;">설명: ${indexList.categoryDescribe}</p>
						    </div>
						 </a>
					  </div>
					</c:forEach>
			</div>
		</div>
	</div>
</body>
</html>