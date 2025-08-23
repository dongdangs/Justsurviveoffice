<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%
    String ctxPath = request.getContextPath();
%>

<jsp:include page="../header/header1.jsp"></jsp:include>

<style>
    body {
        background-color: #f3f4f6;
    }

    .main-wrap {
        padding: 24px 16px;
    }

    .sidebar-card, .board-card {
        border-radius: 12px;
        overflow: hidden;
        -webkit-backdrop-filter: blur(5px);
        backdrop-filter: blur(5px);
    }

    .sidebar-card .card-body,
    .board-overlay {
        background-color: rgba(255,255,255,0.92);
    }

    .left-cards .card {
        margin-bottom: 1.25rem;
    }

    .board-item {
	    background-color: rgba(255, 255, 255, 0.6); /* ✅ 기존보다 더 투명하게 */
	    cursor: pointer;
	    transition: transform .18s ease, box-shadow .18s ease, background-color .18s ease;
	    border-radius: 8px;
	}
	
	.board-item:hover {
	    background-color: rgba(238, 249, 255, 0.65);
	}

    .board-card {
        background-position: center;
        background-size: cover;
        background-repeat: no-repeat;
        position: relative;
        min-height: 100%;
        height: 100%;
        display: flex;
        flex-direction: column;
        justify-content: flex-start;
    }

    .board-overlay {
    position: relative;
    z-index: 2;
    padding: 1.5rem;
    background-color: rgba(255, 255, 255, 0.65); /* ✅ 투명도 낮춤 */
    flex-grow: 1;
    border-radius: 12px;
    backdrop-filter: blur(4px); /* ✅ 배경 흐림 효과 */
    -webkit-backdrop-filter: blur(4px);
}

    .write-btn {
        position: absolute;
        top: 12px;
        right: 16px;
        z-index: 3;
    }

    @media (max-width: 767.98px) {
        .write-btn {
            position: static;
            display: block;
            margin-bottom: 0.5rem;
        }
    }

    .text-clamp-1 {
        display: block;
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
    }

    .text-clamp-2 {
        display: -webkit-box;
        -webkit-line-clamp: 2;
        -webkit-box-orient: vertical;
        overflow: hidden;
    }
</style>

<script type="text/javascript">
    function view(boardNo) {
        const form = document.boardDetailForm;
        form.boardNo.value = boardNo;
        form.method = "post";
        form.action = "<%= ctxPath %>/board/boardDetail";
        form.submit();
    }
</script>

<div class="container main-wrap">
    <div class="row g-4">
        <!-- 왼쪽 사이드바 -->
        <div class="col-12 col-md-3">
            <div class="left-cards">
                <!-- 프로필 카드 -->
                <div class="card sidebar-card shadow-sm">
                    <div class="card-body text-center">
                        <img src="<%= ctxPath %>/images/mz.png" alt="프로필" class="rounded-circle mb-3" style="width:110px; height:110px; object-fit:cover; border:4px solid rgba(204,229,255,0.9);">
                        <div class="text-muted small mb-1">${sessionScope.loginUser.email}</div>
                        <div>
                            <div class="fw-bold text-primary">${sessionScope.loginUser.name} 님</div>
                            <div class="mt-1">포인트 : <b><fmt:formatNumber value="${sessionScope.loginUser.point}" pattern="#,###"/></b> point</div>
                        </div>
                    </div>
                </div>

                <!-- Hot Posts -->
                <div class="card sidebar-card shadow-sm">
                    <div class="card-body">
                        <h6 class="fw-bold mb-3 text-danger"><i class="fas fa-fire me-2"></i>Hot! 게시글</h6>
                        <ul class="list-unstyled mb-0" style="font-size:0.95rem; line-height:1.6;">
                            <li><span class="fw-bold me-2">01</span> hot 게시글 1등 제목입니다.~~~~~~~ <span class="text-danger">(4)</span></li>
                            <li><span class="fw-bold me-2">02</span> hot 게시글 2등 제목입니다.!!!!!!!!!!!!!!!!!!!! <span class="text-danger">(9)</span></li>
                            <li><span class="fw-bold me-2">03</span> hot 게시글 3등 제목입니다.####### <span class="text-danger">(9)</span></li>
                            <li><span class="fw-bold me-2">04</span> hot 게시글 4등 제목입니다. <span class="text-danger">(9)</span></li>
                            <li><span class="fw-bold me-2">05</span> hot 게시글 5등 제목입니다. <span class="text-danger">(9)</span></li>
                        </ul>
                    </div>
                </div>

                <!-- 댓글많은 게시글 -->
                <div class="card sidebar-card shadow-sm">
                    <div class="card-body">
                        <h6 class="fw-bold mb-3 text-primary"><i class="fas fa-comments me-2"></i>댓글많은 게시글</h6>
                        <ul class="list-unstyled mb-0" style="font-size:0.95rem; line-height:1.6;">
                            <li><span class="fw-bold me-2">01</span> 댓글많은 게시글 1등 제목입니다.~~~ <span class="text-primary">(100)</span></li>
                            <li><span class="fw-bold me-2">02</span> 댓글많은 게시글 2등 제목입니다.!!!! <span class="text-primary">(55)</span></li>
                            <li><span class="fw-bold me-2">03</span> 댓글많은 게시글 3등 제목입니다.@@@@ <span class="text-primary">(55)</span></li>
                            <li><span class="fw-bold me-2">04</span> 댓글많은 게시글 4등 제목입니다.#### <span class="text-primary">(55)</span></li>
                            <li><span class="fw-bold me-2">05</span> 댓글많은 게시글 5등 제목입니다.$$$$$ <span class="text-primary">(55)</span></li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>

        <!-- 오른쪽 게시글 목록 -->
        <div class="col-12 col-md-9">
            <div class="card board-card shadow-sm" style="background-image: url('<%= ctxPath %>/images/background.png');">
                <a href="<%= ctxPath %>/board/writeForm" class="btn btn-primary btn-sm write-btn d-none d-md-inline-block">
                    <i class="fas fa-pen me-1"></i>글쓰기
                </a>

                <div class="board-overlay">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h5 class="mb-0">게시판</h5>
                        <a href="<%= ctxPath %>/board/writeForm" class="btn btn-primary btn-sm d-md-none">
                            <i class="fas fa-pen me-1"></i>글쓰기
                        </a>
                    </div>

                    <c:if test="${not empty boardList}">
                        <div class="row">
                            <c:forEach var="boardDto" items="${boardList}">
                                <div class="col-12">
                                    <div class="board-item p-3 mb-3" style="background-color: rgba(255,255,255,0.88); cursor:pointer;" onclick="view('${boardDto.boardNo}')">
                                        <div class="fw-bold mb-1">${boardDto.boardName}</div>
                                        <div class="text-muted mb-2 text-clamp-2">${boardDto.boardContent}</div>
                                        <div class="small text-muted d-flex justify-content-between align-items-center">
                                            <span>${boardDto.fk_id}</span>
                                            <div>
                                                <i class="far fa-eye me-2"></i>${boardDto.readCount}
                                                <i class="far fa-heart ms-3 me-2"></i>좋아요
                                                <i class="far fa-comment-dots me-2"></i>0
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:if>

                    <c:if test="${empty boardList}">
                        <div class="text-center text-muted py-5">
                            <i class="far fa-folder-open fa-2x mb-2"></i>
                            <p>데이터가 없습니다.</p>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
</div>



<!-- 글 상세보기 폼 -->
<form name="boardDetailForm">
    <input type="hidden" name="boardNo" />
</form>

<%-- <jsp:include page="../footer/footer1.jsp"></jsp:include> --%>
