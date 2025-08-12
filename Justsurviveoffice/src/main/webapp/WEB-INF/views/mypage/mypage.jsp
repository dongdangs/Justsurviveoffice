<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
    String ctxPath = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>마이페이지</title>

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
</style>

<script>
$(function () {
    // 로그아웃
    $("#btnLogout").on("click", function(e) {
        e.preventDefault();
        if (confirm("정말 로그아웃 하시겠습니까?")) {
            $("#logoutForm").submit();
        }
    });

    // 회원탈퇴
    $("#btnQuit").on("click", function(e) {
        e.preventDefault();
        if (confirm("정말 탈퇴를 진행하시겠습니까? (복구 불가)")) {
            $("#quitForm").submit();
        }
    });
});
</script>
</head>
<body>
<div class="container mt-4">
    <div class="row">

        <!-- 사이드바 -->
        <div class="col-lg-3 mb-4">
            <h3 class="mb-1">MYPAGE</h3>
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

                <!-- 탭 메뉴 -->
                <ul class="nav nav-tabs mb-3">
                    <li class="nav-item">
                        <a class="nav-link active" href="<%= ctxPath%>/mypage/info">내 정보</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%= ctxPath%>/mypage/forms">작성한 폼</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%= ctxPath%>/mypage/bookmarks">내 북마크</a>
                    </li>
                </ul>

                <!-- 내정보 수정 폼 -->
                <form action="<%= ctxPath%>/mypage/update" method="post" id="editForm">
                    <input type="hidden" name="id" value="${sessionScope.loginUser.id}">

                    <div class="form-group">
                        <label>성명 <span class="text-danger">*</span></label>
                        <input type="text" name="name" class="form-control"
                               value="${sessionScope.loginUser.name}" required>
                    </div>

                    <div class="form-group">
                        <label>이메일 <span class="text-danger">*</span></label>
                        <div class="input-group">
                            <input type="email" name="email" id="email" class="form-control"
                                   value="${sessionScope.loginUser.email}" required>
                            <div class="input-group-append">
                                <button class="btn btn-outline-primary" type="button" id="btnEmailDup">중복확인</button>
                            </div>
                        </div>
                    </div>

                    <div class="form-group">
                        <label>연락처 <span class="text-danger">*</span></label>
                        <input type="text" name="mobile" class="form-control"
                               value="${sessionScope.loginUser.mobile}" placeholder="010-1234-5678" required>
                    </div>

                    <div class="form-group">
                        <label>비밀번호</label>
                        <input type="password" name="password" id="password" class="form-control"
                               minlength="8" maxlength="15">
                    </div>

                    <div class="form-group">
                        <label>비밀번호 확인</label>
                        <input type="password" id="passwordCheck" class="form-control"
                               minlength="8" maxlength="15">
                        <small id="pwMatchMsg" class="form-text"></small>
                    </div>

                    <div class="text-center mt-4">
                        <button type="submit" class="btn btn-primary px-4">수정하기</button>
                    </div>
                </form>

                <!-- 숨은 폼: 로그아웃 & 탈퇴 POST 요청 -->
                <form id="logoutForm" action="<%= ctxPath%>/logout" method="post" style="display:none;"></form>
                <form id="quitForm" action="<%= ctxPath%>/quit" method="post" style="display:none;"></form>

            </div>
        </div>
    </div>
</div>
</body>
</html>
