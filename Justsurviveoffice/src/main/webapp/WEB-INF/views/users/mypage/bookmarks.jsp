<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>    

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
body {
    background: #f7f7fb;
    font-family: 'Noto Sans KR', sans-serif;
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
    margin-bottom: 10px;
}

.sidebar-menu a {
    display: block;
    padding: 8px 0;
    color: #333;
    text-decoration: none;
    font-weight: 500;
    transition: all 0.2s ease-in-out;
}

.sidebar-menu a:hover {
    color: #6c63ff;
    padding-left: 5px;
}

.content {
    background: #fff;
    border-radius: 12px;
    padding: 24px;
    box-shadow: 0 8px 24px rgba(0,0,0,.06);
}

/* 북마크 테이블 */
.table {
    border-collapse: separate;
    border-spacing: 0 8px;
}

.table thead {
    background-color: #f1f3f6;
    border-radius: 8px;
}

.table th {
    text-align: center;
    font-weight: 600;
    color: #444;
}

.table td {
    text-align: center;
    vertical-align: middle;
    background-color: #fff;
    box-shadow: 0 2px 6px rgba(0, 0, 0, .05);
    border-radius: 6px;
}

/* 링크 스타일 */
.table td a {
    display: inline-block;
    max-width: 200px;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
    color: #333;
    font-weight: 500;
}

.table td a:hover {
    color: #6c63ff;
    text-decoration: underline;
}

/* 삭제 버튼 */
.btnDelete {
    background-color: #ff6b6b;
    border: none;
    color: white;
    padding: 4px 12px;
    border-radius: 6px;
    font-size: 13px;
    transition: all 0.2s ease-in-out;
}

.btnDelete:hover {
    background-color: #ff4b4b;
    transform: scale(1.05);
}
</style>
</head>

<script>
$(function () {
 

  // 회원탈퇴
  $("#btnQuit").on("click", function (e) {
    e.preventDefault();
    if (!confirm("정말로 탈퇴하시겠습니까?")) return;


    $.ajax({
      url: "<%= ctxPath %>/mypage/quit",
      type: "post",
      data: { id: "${sessionScope.loginUser.id}" },
      dataType: "json",
      success: function (json) {
        if (json.n == 1) {
          alert("탈퇴되었습니다.");
          location.href = "<%= ctxPath %>/index";
        } else {
          alert("탈퇴 실패");
          $btn.prop("disabled", false);
        }
      },
      error: function (request, status, error) {
        alert("code: " + request.status + "\nmessage: " + request.responseText + "\nerror: " + error);
        $btn.prop("disabled", false);
      }
    });
  }); //end of $("#btnQuit").on("click", function (e) {})
  
  
	//북마크 삭제
  $(document).on("click", ".btnDelete", function(e) {
	    e.preventDefault();

	    const fk_boardNo = $(this).data("fk_boardno"); 
	    console.log("삭제 버튼 클릭, fk_boardNo =", fk_boardNo);

	    if (!fk_boardNo) {
	        alert("게시글 번호를 가져올 수 없습니다.");
	        return;
	    }

	    if (!confirm("해당 북마크를 삭제하시겠습니까?")) return;

	    const $row = $(this).closest("tr");

	    $.ajax({
	        url: "<%=ctxPath%>/bookmark/remove",
	        type: "post",
	        data: { fk_boardNo: fk_boardNo },
	        dataType: "json",
	        success: function(json) {
	            if (json.success) {
	                alert("북마크가 삭제되었습니다.");
	                $row.remove();
	            } else {
	                alert("삭제 실패: " + json.message);
	            }
	        },
	        error: function(request, status, error) {
	            alert("code: " + request.status + "\nmessage: " + request.responseText);
	        }
	    });
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
                    <li class="nav-item"><a class="nav-link" href="<%= ctxPath%>/mypage/forms">내가 쓴 글</a></li>
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
						        <th style="width: 10%; text-align:center;">번호</th>
						        <th style="width: 50%; text-align:center;">제목</th>
						        <th style="width: 25%; text-align:center;">추가일</th>
						        <th style="width: 15%; text-align:center;"></th>
						    </tr>
						</thead>
                            <tbody>
						    <c:forEach var="bm" items="${myBookmarks}" varStatus="st">
						    <tr>
						        <td>${st.index + 1}</td>
						        <td>
						            <a href="${pageContext.request.contextPath}/board/detail?boardNo=${bm.fk_boardNo}">
						                ${bm.boardName}
						            </a>
						        </td>
						        <td>${fn:replace(bm.createdAtMark, "T", " ")}</td>
						        <td>
						        	     <!--fk_boardNo값: ${bm.fk_boardNo} -->

						            <button type="button"
								        class="btn btn-sm btn-outline-danger btnDelete"
								        data-fk_boardno="${bm.fk_boardNo}">
								    삭제
								</button>
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

 	<!-- 숨은 폼: 로그아웃  -->
	<form id="logoutForm" action="<%=ctxPath%>/logout" method="post" style="display:none;"></form>

</body>
</html>
