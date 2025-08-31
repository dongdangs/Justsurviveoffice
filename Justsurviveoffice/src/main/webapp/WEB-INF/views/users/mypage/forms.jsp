<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
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
a { color: black; }
.loading { text-align:center; margin:20px 0; display:none; }
</style>
</head>

<script type="text/javascript">
$(function(){

    // 회원탈퇴
    $("#btnQuit").on("click", function(e) {
        e.preventDefault();
        if(confirm("정말로 탈퇴하시겠습니까?")) {
            $.ajax({
                url:"<%= ctxPath%>/mypage/quit",
                type:"post",
                data:{id:"${sessionScope.loginUser.id}"},
                dataType:"json",
                success:function(json){
                    if(json.n == 1) {
                        alert("탈퇴되었습니다.");
                        location.href="<%= ctxPath%>/index";
                    } else {
                        alert("탈퇴 실패");
                    }
                },
                error: function(request, status, error){
                    alert("code: "+request.status+"\nmessage: "+request.responseText+"\nerror: "+error);
                }
            });
        }
    });

    // 스크롤 페이징 변수
    let start = 0;
    let len = 10;  // 첫 로딩은 10개
    let isLoading = false;
    let endOfData = false;

    // 날짜 포맷
    function formatDate(dateTimeStr) {
        if (!dateTimeStr) return '-';
        return dateTimeStr.split("T")[0]; // yyyy-MM-dd
    }

    // 데이터 불러오기
    function loadMore() {
        if (isLoading || endOfData) return;
        isLoading = true;
        $(".loading").show();

        $.ajax({
            url: "<%=ctxPath%>/mypage/myBoardsMore",
            type: "GET",
            data: {
                id: "${sessionScope.loginUser.id}",
                start: start,
                len: len
            },
            success: function(data) {
                if (data.length > 0) {
                    let rowNumber = start + 1;
                    data.forEach(function(board) {
                        $("#boardList").append(
                            "<tr>"
                          + "<td>" + (rowNumber++) + "</td>"
                          + "<td><a href='<%=ctxPath%>/board/view?boardNo=" + board.boardNo + "'>"
                          + (board.boardName || '-') + "</a></td>"
                          + "<td>" + (board.createdAtBoard ? formatDate(board.createdAtBoard) : '-') + "</td>"
                          + "<td>" + (board.readCount || 0) + "</td>"
                          + "<td>"
                          + (board.boardDeleted == 1
                                ? "<button type='button' class='btn btn-sm btn-outline-danger' data-fk_boardno='" + board.boardNo + "'>복구하기</button>"
                                : "")
                          + "</td>"
                          + "</tr>"
                        );
                    });
                    start += len;
                    len = 5; // 이후부터는 5개씩
                } else {
                    $("#boardList").append(
                        "<tr><td colspan='5' class='text-center text-muted'>더 이상 글이 없습니다.</td></tr>"
                    );
                    endOfData = true;
                }
                $(".loading").hide();
                isLoading = false;
            },
            error: function() {
                $(".loading").hide();
                isLoading = false;
                alert("데이터 로딩 실패");
            }
        });
    }

    // 첫 화면 로딩 시 데이터 불러오기
    loadMore();

    // 스크롤 이벤트
    $(window).scroll(function() {
        if ($(window).scrollTop() + $(window).height() >= $(document).height() - 50) {
            loadMore();
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
                    포인트 : <b><fmt:formatNumber value="${sessionScope.loginUser.point}" pattern="#,###"/>p</b>
                </div>
                <hr>
                <div class="sidebar-menu text-left">
                    <a href="<%=ctxPath%>/users/logout">로그아웃</a>
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
                    <li class="nav-item"><a class="nav-link" href="<%= ctxPath%>/mypage/chart">통계</a></li>
                </ul>

                <h5>내가 쓴 글 목록</h5>
                <hr>

                <table class="table table-hover">
                    <thead class="thead-light">
                        <tr>
                            <th>번호</th>
                            <th>제목</th>
                            <th>작성일</th>
                            <th>조회수</th>
                            <th>비고</th>
                        </tr>
                    </thead>
                    <tbody id="boardList">
                        <!-- AJAX로 데이터 추가 -->
                    </tbody>
                </table>
                <div class="loading">불러오는 중...</div>
            </div>
        </div>
    </div>
</div>
</body>
</html>
