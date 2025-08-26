<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
	
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%
    String ctxPath = request.getContextPath();
    //     /justsurviveoffice
%>

<jsp:include page="header/header1.jsp" />
	
		<div class="row">
			
			<%-- <div class="col-md-3 d-flex flex-column align-items-center justify-content-start" style="border:solid 2px red;">
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
				</div> --%>
				
			</div>
			
			<div class="col-md-9" style="background-image: url('<%= ctxPath %>/images/background.png'); border: solid 2px blue;">
				
				<div class="row" style="width: 80%; margin: 5%">
				<!-- 테스트 카드 (고정) -->
				<div class="col-md-4 mt-4">
					<a href="<%= ctxPath%>/categoryTest/survey" class="card text-decoration-none h-75" style="height: 80%;">
						<div style="margin: auto 5%; border: solid 1px green;">
							<img src="<%= ctxPath%>/images/mz.png" class="card-img-top" alt="테스트">
						</div>
						<!-- <div class="card-body">
							<h5 class="card-title">테스트</h5>
							<p class="card-text">당신의 성향을 알아보세요!</p>
						</div> -->
					</a>
				</div>
				
				<!-- DB 카드 반복 -->
				<div class="col-md-4 mb-4">
					<a href="board/list?category=2" class="card text-decoration-none h-100" style="background-color: navy;">
						<div style="margin: 5% 5%; border: solid 1px red; height: 60%;">
							<img src="<%= ctxPath%>/images/adult.png" class="card-img-top" style="width:100%; height:100%; object-fit:cover;" alt="">
						</div>
						<div class="card-body">
							<h4 class="card-title" style="font-weight: bold; color: #39FF14;">꼰대존</h4>
							<p class="card-text" style="color: white;">#맞말필수 #유능 #야근 #완벽주의자 #위계질서 #30분전출근</p>
						</div>
					</a>
				</div>
				
				<div class="col-md-4 mb-4">
					<a href="board/list?category=3" class="card text-decoration-none h-100" style="background-color: navy;">
						<div style="margin: 5% 5%; border: solid 1px red; height: 60%;">
							<img src="<%= ctxPath%>/images/slave.png" class="card-img-top" style="width:100%; height:100%; object-fit:cover;" alt="">
						</div>
						<div class="card-body">
							<h4 class="card-title" style="font-weight: bold; color: #39FF14;">노예존</h4>
							<p class="card-text" style="color: white;">#말잘들음 #무욕인 #근성보유 #시키면다함 #묵묵 #수동적</p>
						</div>
					</a>
				</div>
				
				<div class="col-md-4 mb-3">
					<a href="board/list?category=5" class="card text-decoration-none h-100" style="background-color: navy;">
						<div style="margin: 5% 5%; border: solid 1px red; height: 60%;">
							<img src="<%= ctxPath%>/images/nointer.png" class="card-img-top" style="width:100%; height:100%; object-fit:cover;" alt="">
						</div>
						<div class="card-body">
							<h4 class="card-title" style="font-weight: bold; color: #39FF14;">금쪽이존</h4>
							<p class="card-text" style="color: white;">#사수소환술 #이유궁금 #궁금한거못참음 #카톡러버 #응애</p>
						</div>
					</a>
				</div>
				
				<div class="col-md-4 mb-4">
					<a href="board/list?category=4" class="card text-decoration-none h-100" style="background-color: navy;">
						<div style="margin: 5% 5%; border: solid 1px red; height: 60%;">
							<img src="<%= ctxPath%>/images/myway.png" class="card-img-top" style="width:100%; height:100%; object-fit:cover;" alt="">
						</div>
						<div class="card-body">
							<h4 class="card-title" style="font-weight: bold; color: #39FF14;">마이웨이존</h4>
							<p class="card-text" style="color: white;">#자유영혼 #타협불가 #독단적 #완벽주의자 #혁신 #열정</p>
						</div>
					</a>
				</div>
				
				<div class="col-md-4 mb-4">
					<a href="board/list?category=1" class="card text-decoration-none h-100" style="background-color: navy;">
						<div style="margin: 5% 5%; border: solid 1px red; height: 60%;">
							<img src="<%= ctxPath%>/images/mz.png" class="card-img-top" style="width:100%; height:100%; object-fit:cover;" alt="">
						</div>
						<div class="card-body">
							<h4 class="card-title" style="font-weight: bold; color: #39FF14;">MZ존</h4>
							<p class="card-text" style="color: white;">#에어팟필수 #칼퇴 #딴생각장인 #지각러버</p>
						</div>
					</a>
				</div>
				
			</div>
			
		</div>
	</div>
	
</body>
</html>