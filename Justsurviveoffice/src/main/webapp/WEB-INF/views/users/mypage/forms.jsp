<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%
String ctxPath = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>마이페이지 - 내가 쓴 게시글</title>

<link rel="stylesheet" href="<%=ctxPath%>/bootstrap-4.6.2-dist/css/bootstrap.min.css">
<script src="<%=ctxPath%>/js/jquery-3.7.1.min.js"></script>
<script src="<%=ctxPath%>/bootstrap-4.6.2-dist/js/bootstrap.bundle.min.js"></script>

<style>
body {
    background: #f7f7fb;
}
.sidebar {
    background: #fff;
    border-radius: 12px;
    padding: 20px;
    box-shadow: 0 8px 24px rgba(0,0,0,.06);
}
.sidebar img {
    max-width: 100%;
    border-radius: 10px;
}
.sidebar-menu a {
    display: block;
    padding: 8px 0;
    color: #333;
    text-decoration: none;
}
.sidebar-menu a:hover {
    color: #6c63ff;
}
.content {
    background: #fff;
    border-radius: 12px;
    padding: 24px;
    box-shadow: 0 8px 24px rgba(0,0,0,.06);
}
.table th, .table td {
    vertical-align: middle;
}
</style>
</head>

<script type="text/javascript">
$(function(){
	

    // 회원탈퇴
    $("#btnQuit").on("click", function(e) {
        e.preventDefault();

    	if(confirm(`정말로 탈퇴하시겠습니까?`)) {
 		   
 		   $.ajax({
 			   url:"<%= ctxPath%>/mypage/quit",
 			   type:"post",
 			   data:{"id":"${sessionScope.loginUser.id}" },
 			   dataType:"json",
 			   success:function(json){
 				   console.log(JSON.stringify(json));
 				   // {"n":1}
 				   
 				   if(json.n == 1) {
 					   alert(`탈퇴되었습니다.`);
 					   location.href="<%= ctxPath%>/main";
 				   } else {
 					   alert(`탈퇴실패`);
 				   }
 			   },
 			   error: function(request, status, error){
 				   alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
 			   }
 		   });
 	   }
 	   
    }// end of 회원탈퇴 --------------------------
    
});
</script>

<body>
<div class="container mt-4">
    <div class="row">
        <!-- 사이드바 -->
        <div class="col-lg-3 mb-4">
            <div class="sidebar text-center">             
                <img src="<%=ctxPath%>/images/mz.png" alt="프로필" class="mb-3">
                <div class="text-muted small mb-3">${sessionScope.loginUser.email}</div>
                <div class="mb-3">
                    <span style="size:20pt; color:blue;">${sessionScope.loginUser.name} 님 </span>
                    포인트 : <b>${sessionScope.loginUser.point} </b>
                </div>
                <hr>
                <div class="sidebar-menu text-left">
                    <a href="<%=ctxPath%>/login/logout">로그아웃</a>
                    <a href="#" id="btnQuit">탈퇴하기</a>
                    <a href="javascript:history.back()">이전 페이지</a>
                </div>
            </div>
        </div>

        <!-- 메인 내용 -->
        <div class="col-lg-9">
            <div class="content">
                <ul class="nav nav-tabs mb-3">
                    <li class="nav-item"><a class="nav-link" href="<%= ctxPath%>/mypage/info">내 정보</a></li>
                    <li class="nav-item"><a class="nav-link active" href="<%= ctxPath%>/mypage/forms">내가 쓴 글</a></li>
                    <li class="nav-item"><a class="nav-link" href="<%= ctxPath%>/mypage/bookmarks">내 북마크</a></li>
                </ul>

                <!-- 작성한 글 목록 -->
                <h5>내가 쓴 글 목록</h5>
                <hr>

               <c:choose>
			  <c:when test="${empty myBoards}">
			    <div class="alert alert-secondary text-center">
			      작성한 글이 없습니다.
			    </div>
			  </c:when>
			  <c:otherwise>
			    <table class="table table-hover">
			      <thead class="thead-light">
			        <tr>
			          <th>번호</th>
			          <th>제목</th>
			          <th>작성일</th>
			          <th>조회수</th>
			        </tr>
			      </thead>
			      <tbody>
			        <c:forEach var="board" items="${myBoards}" varStatus="st">
			          <tr>
			            <td>${st.count}</td>
			            <td>${board.boardName}</td>
			            <td>${fn:substring(board.createdAtBoard, 0, 10)}</td>
			            <td>${board.readCount}</td>
			          </tr>
			        </c:forEach>
			      </tbody>
			    </table>
			  </c:otherwise>
			</c:choose>

            </div>
        </div>
    </div>
</div>
<form id="logoutForm" action="<%=ctxPath%>/logout" method="post" style="display:none;"></form>

</body>
</html>
