<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
	String ctxPath = request.getContextPath();
%>

<jsp:include page="../header/header1.jsp"></jsp:include>

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
	
			<!-- 오른쪽 게시글 부분 -->
			<div class="col-md-9" style="background-image: url('<%= ctxPath %>/images/background.png'); border: solid 2px blue; background-size: cover; background-repeat: no-repeat;">
		
		    	<div class="row justify-content-center" style="width: 90%; margin: 5% auto;">
    
        			<c:forEach var="board" items="${boardList}">
            			<div class="col-12 py-3 border-bottom" style="cursor:pointer; background-color: rgba(255,255,255,0.85);">
                
			                <!-- 제목 -->
			                <div class="font-weight-bold mb-1" style="font-size:1.1rem;">
			                    ${board.boardName}
			                </div>
                
			                <!-- 내용 요약 -->
			                <div class="text-muted mb-2" style="font-size:0.95rem; white-space:nowrap; overflow:hidden; text-overflow:ellipsis;">
			                    ${board.boardContent}
			                </div>
                
			                <!-- 작성자 & 기타 정보 -->
			                <div class="d-flex justify-content-between text-muted small">
			                    <span>${board.name}</span>
			                    <div>
			                        <i class="far fa-comment-dots mr-1"></i> 댓글 0
			                        <i class="far fa-heart ml-3 mr-1"></i> 좋아요 0
			                    </div>
		                	</div>
            			</div>
       				</c:forEach>
    			</div>

			</div>
	</div>
</div>	

<%-- <jsp:include page="../footer/footer1.jsp"></jsp:include> --%>