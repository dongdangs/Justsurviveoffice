<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
String ctxPath = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>마이페이지 - 내 북마크</title>

<link rel="stylesheet" href="<%=ctxPath%>/bootstrap-4.6.2-dist/css/bootstrap.min.css">
<script src="<%=ctxPath%>/js/jquery-3.7.1.min.js"></script>
<script src="<%=ctxPath%>/bootstrap-4.6.2-dist/js/bootstrap.bundle.min.js"></script>

<style>
body { background: #f7f7fb; }
.sidebar {
    background: #fff; border-radius: 12px; padding: 20px;
    box-shadow: 0 8px 24px rgba(0,0,0,.06);
}
.sidebar img { max-width: 100%; border-radius: 10px; }
.sidebar-menu a {
    display: block; padding: 8px 0; color: #333; text-decoration: none;
}
.sidebar-menu a:hover { color: #6c63ff; }
.content {
    background: #fff; border-radius: 12px; padding: 24px;
    box-shadow: 0 8px 24px rgba(0,0,0,.06);
}
.table th, .table td { vertical-align: middle; }
</style>
</head>

<script>
$(function(){
    $("#btnLogout").click(function(e){
        e.preventDefault();
        if(confirm("정말 로그아웃 하시겠습니까?")) {
            location.href = "<%= ctxPath %>/logout";
        }
    });
    $("#btnQuit").click(function(e){
        e.preventDefault();
        if(confirm("정말 탈퇴하시겠습니까? (복구 불가)")) {
            location.href = "<%= ctxPath %>/quit";
        }
    });
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
                    포인트 : <b>${sessionScope.loginUser.point}  point </b>
                </div>
                <hr>
                <div class="sidebar-menu text-left">
                    <a href="#" id="btnLogout">로그아웃</a>
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
                    <li class="nav-item"><a class="nav-link" href="<%= ctxPath%>/mypage/forms">작성한 폼</a></li>
                    <li class="nav-item"><a class="nav-link active" href="<%= ctxPath%>/mypage/bookmarks">내 북마크</a></li>
                </ul>

                <h5>내 북마크 목록</h5>
                <hr>

                <c:choose>
                    <c:when test="${empty myBookmarks}">
                        <div class="alert alert-secondary text-center">북마크한 글이 없습니다.</div>
                    </c:when>
                    <c:otherwise>
                        <table class="table table-hover">
                            <thead class="thead-light">
                                <tr>
                                    <th>번호</th>
                                    <th>제목</th>
                                    <th>작성일</th>
                                    <th>이동</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="bm" items="${myBookmarks}" varStatus="st">
                                    <tr>
                                        <td>${st.index + 1}</td>
                                        <td>${bm.boardName}</td>
                                        <td>
                                            <fmt:formatDate value="${bm.createdAtBoard}" pattern="yyyy-MM-dd HH:mm" />
                                        </td>
                                        <td>
                                            <a href="<%=ctxPath%>/board/view/${bm.boardNo}" class="btn btn-sm btn-outline-primary">바로가기</a>
                                        </td>
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
</body>
</html>
