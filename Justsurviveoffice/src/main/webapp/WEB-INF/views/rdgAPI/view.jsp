<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%
	String ctxPath = request.getContextPath();
%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시판 글 상세보기(임시)</title>

<!-- Bootstrap CSS -->
<link rel="stylesheet" href="<%= ctxPath%>/bootstrap-4.6.2-dist/css/bootstrap.min.css" type="text/css">

<%-- Font Awesome 6 Icons --%>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">

<%-- Optional JavaScript --%>
<script type="text/javascript" src="<%=ctxPath%>/js/jquery-3.7.1.min.js"></script>
<script type="text/javascript" src="<%=ctxPath%>/bootstrap-4.6.2-dist/js/bootstrap.bundle.min.js" ></script>

<style type="text/css">
	
	:root{
	  --border:#e5e7eb; --muted:#6b7280; --soft:#f8fafc; --pad:16px;
	}
	body{ background:#fff; }
	.wrap{ max-width:920px; margin:28px auto; padding:0 12px; }
	
	/* 상단 */
	.badge-cat{ color:#10b981; font-weight:700; font-size:13px; }
	.title{ font-size:26px; font-weight:800; line-height:1.3; margin:6px 0 10px; }
	.post-head{ border-bottom:1px solid var(--border); padding-bottom:12px; }
	.meta{ color:var(--muted); font-size:13px; }
	.action-right i{ font-size:14px; }
	.avatar{ width:42px; height:42px; border-radius:50%; background:#eef2f7; border:1px solid var(--border); flex:0 0 42px; }
	
	/* 본문 */
	.post-card{ padding:22px; border:1px solid var(--border); border-radius:14px; background:#fff; }
	.post-body{ min-height:220px; padding:10px 0 0; }
	
	/* 피드백 바 */
	.feedback-bar{
		display:flex; align-items:center; gap:14px; padding:14px 0;
		justify-content:space-between; /* 좌우로 벌리기 */
	}
	.feedback-left{ display:flex; align-items:center; gap:14px; }
	.feedback-btn{ border:1px solid var(--border); background:#fff; border-radius:12px; padding:6px 12px; font-weight:600; }
	.feedback-btn i{ margin-right:6px; }
	
	/* 댓글 */
	.comment-wrap{ margin-top:16px; }
	.comment-item{ display:flex; gap:12px; padding:14px; border:1px solid var(--border); border-radius:12px; background:#fff; }
	.comment-item + .comment-item{ margin-top:10px; }
	.comment-nick{ font-weight:700; }
	.comment-meta-row{ color:var(--muted); font-size:12px; display:flex; align-items:center; gap:10px; margin-top:6px; }
	.vote-btn{ border:1px solid var(--border); background:#fff; border-radius:8px; padding:2px 8px; font-size:12px; }
	.vote-btn i{ margin-right:4px; }
	.comment-actions{ font-size:13px; color:var(--muted); }
	.comment-actions .btn-link{ padding:0; }
	.comment-content{ white-space:pre-line; }
	
	.replies{ margin-top:10px; margin-left:54px; border-left:3px solid var(--border); padding-left:12px; }
	.reply-item{ display:flex; gap:10px; padding:10px 12px; border:1px solid var(--border); border-radius:10px; background:#fff; }
	.reply-item + .reply-item{ margin-top:8px; }
	
	/* 입력 폼 */
	.comment-form .form-control{ border-radius:12px; }
	.reply-form{ display:none; margin-top:8px; }
	.reply-form .form-control{ border-radius:10px; }
	
	/* 하단 */
	.bottom-bar{ display:flex; justify-content:flex-end; gap:8px; margin-top:18px; }
	.btn-round{ border-radius:10px; }
	.link-muted{ color:var(--muted); }
	
	.divider{ height:1px; background:var(--border); margin:16px 0; }
	
	/* 이전글 다음글 관련  */
	.prev-next-list {
	  border-top:1px solid var(--border);
	  border-bottom:1px solid var(--border);
	  padding:10px 0;
	  font-size:14px;
	}
	.prev-next-list a {
	  text-decoration:none;
	}
	.prev-next-list a:hover {
	  text-decoration:underline;
	}
	
</style>

<script type="text/javascript">
	
	$(function(){
		
		//답글 폼 토글
		$(document).on('click', '.btn-reply', function(){
		  $(this).closest('.comment-item').find('.reply-form').first().slideToggle(120);
		});
		$(document).on('click', '.btn-cancel-reply', function(){
		  $(this).closest('.reply-form').slideUp(120);
		});
		
		// TOP 버튼
		$('#btnTop').on('click', function(e){ e.preventDefault(); window.scrollTo({top:0, behavior:'smooth'}); });
		
		// 더미 액션
		$(document).on('click', '.vote-btn.like', function(){ alert('댓글 좋아요(더미)'); });
		$(document).on('click', '.vote-btn.dislike', function(){ alert('댓글 싫어요(더미)'); });
		
	});	
	
	
</script>

</head>
<body>
	
	<div class="wrap">

  <!-- 카테고리/빵부스러기 -->
  <div class="mb-2">
    <span class="badge-cat">꼰대존 자유게시판</span>
  </div>

  <!-- 제목 + 우측 액션 -->
  <div class="post-head d-flex align-items-start">
    <div class="flex-grow-1">
      <h1 class="title">${requestScope.bdto.boardName}</h1>
      <div class="d-flex align-items-center">
        <span class="avatar mr-2"></span>
        <div class="meta">
          <strong>${requestScope.bdto.name}</strong>
          <span class="mx-2">|</span>
          <span>${requestScope.bdto.createdAtBoardFormatted}</span>
          <span class="mx-2">조회 <b>${requestScope.bdto.readCount}</b></span>
        </div>
      </div>
    </div>

  </div>

  <!-- 본문 -->
  <div class="post-card mt-3">
  	
  	<!-- // 첨부파일 박스 -->
  	<c:if test="${not empty requestScope.bdto.boardFileName && sessionScope.loginUser != null}">
      <div class="d-flex justify-content-end">
        <div class="file-box border rounded d-flex align-items-center" style="font-size: 9pt;">
          <a href="<%= ctxPath%>/rdgAPI/download?boardNo=${requestScope.bdto.boardNo}" class="text-dark">
            ${requestScope.bdto.boardFileName} 다운로드
          </a>
        </div>
      </div>
    </c:if>
  
    <div class="post-body">
      <p>${requestScope.bdto.boardContent}</p>
    </div>

    <!-- 좋아요/댓글 수 -->
    <div class="feedback-bar">
    	<div class="feedback-left">
	      <button class="feedback-btn"><i class="fa-regular fa-thumbs-up"></i>좋아요 <span>0</span></button>
	      <div class="link-muted"><i class="fa-regular fa-comment-dots"></i>   댓글 <b>2</b></div>
      	</div>
      	
      <div class="action-right">
        <a class="btn btn-sm btn-outline-secondary mr-2 btn-round" href="#" title="북마크"><i class="fa-regular fa-bookmark"></i></a>
        <a class="link-muted" href="#" title="신고">신고</a>
      </div>
      
    </div>
	
    <!-- 정렬 -->
    <div class="d-flex align-items-center mt-1" style="gap:10px;">
      <a href="#" class="link-muted" style="font-size:13px;">등록순</a>
      <a href="#" class="link-muted" style="font-size:13px;">최신순</a>
    </div>

    <!-- 댓글 리스트 -->
    <div class="comment-wrap">

      <!-- 댓글 1 -->
      <div class="comment-item">
        <span class="avatar"></span>
        <div class="w-100">
          <div class="d-flex justify-content-between">
            <div>
              <span class="comment-nick">클로저 closer</span>
              <span class="badge badge-success ml-1">V</span>
            </div>
          </div>
          <div class="comment-content mt-1">오늘 방문예정이라 신청합니다 👍👍</div>
          
          <div class="comment-meta-row">
            <span class="comment-date">2025.08.24 14:25</span>
            <button type="button" class="vote-btn like"><i class="fa-regular fa-thumbs-up"></i> 좋아요</button>
            <button type="button" class="vote-btn dislike"><i class="fa-regular fa-thumbs-down"></i> 싫어요</button>
          </div>
          
          <div class="comment-actions mt-1">
            <button class="btn btn-link btn-sm text-secondary btn-reply">답글</button>
          </div>

          <!-- 대댓글 목록 -->
          <div class="replies">
            <div class="reply-item">
              <span class="avatar" style="width:34px;height:34px;"></span>
              <div class="w-100">
                <div class="d-flex justify-content-between">
                  <span class="comment-nick">최야옹 vov1623 <span class="badge badge-primary ml-1">작성자</span></span>
                </div>
                <div class="mt-1">쳇 드릴게요~~ 1 👍👎</div>
                
                <div class="comment-meta-row">
                  <span class="comment-date">2025.08.24 14:30</span>
                  <button type="button" class="vote-btn like"><i class="fa-regular fa-thumbs-up"></i> 좋아요</button>
                  <button type="button" class="vote-btn dislike"><i class="fa-regular fa-thumbs-down"></i> 싫어요</button>
                </div>
                
              </div>
            </div>
          </div>

          <!-- 대댓글 입력폼 (토글) -->
          <form class="reply-form">
            <div class="form-group mb-2">
              <textarea class="form-control" rows="2" placeholder="답글을 입력하세요"></textarea>
            </div>
            <div class="text-right">
              <button type="button" class="btn btn-sm btn-secondary btn-round btn-cancel-reply">취소</button>
              <button type="button" class="btn btn-sm btn-primary btn-round">등록</button>
            </div>
          </form>
        </div>
      </div>

      <!-- 댓글 2 -->
      <div class="comment-item">
        <span class="avatar"></span>
        <div class="w-100">
          <div class="d-flex justify-content-between">
            <span class="comment-nick">guest01</span>
          </div>
          <div class="comment-content mt-1">저는 비빔면 + 만두 한 표요 ㅎㅎ</div>
          
          <div class="comment-meta-row">
            <span class="comment-date">2025.08.24 14:40</span>
            <button type="button" class="vote-btn like"><i class="fa-regular fa-thumbs-up"></i> 좋아요</button>
            <button type="button" class="vote-btn dislike"><i class="fa-regular fa-thumbs-down"></i> 싫어요</button>
          </div>
          
          <div class="comment-actions mt-1">
            <button class="btn btn-link btn-sm text-secondary btn-reply">답글</button>
          </div>

          <!-- 대댓글 입력폼 (토글) -->
          <form class="reply-form">
            <div class="form-group mb-2">
              <textarea class="form-control" rows="2" placeholder="답글을 입력하세요"></textarea>
            </div>
            <div class="text-right">
              <button type="button" class="btn btn-sm btn-secondary btn-round btn-cancel-reply">취소</button>
              <button type="button" class="btn btn-sm btn-primary btn-round">등록</button>
            </div>
          </form>
        </div>
      </div>

    </div>

    <div class="divider"></div>

    <!-- 새 댓글 입력 -->
    <form class="comment-form">
      <div class="form-group">
        <textarea class="form-control" rows="3" placeholder="지금 가입하고 댓글에 참여해보세요!"></textarea>
      </div>
      <div class="text-right">
        <button type="button" class="btn btn-primary btn-round">댓글 등록</button>
      </div>
    </form>
  </div>
	
	<!-- // 이전글/다음글 표시 -->
	<div class="prev-next-list mt-3">
    <div class="d-flex">
      <span class="text-muted mr-2">이전글</span>
      <a href="#" class="link-primary">짱구는못말려 콜라보 기원 21일차</a>
    </div>
    <div class="d-flex mt-1">
      <span class="text-muted mr-2">다음글</span>
      <a href="#" class="link-primary">짱구는못말려 콜라보 기원 19일차</a>
    </div>
  </div>
	
  <!-- 하단 버튼 -->
  <div class="bottom-bar">
    <a href="<%= ctxPath%>/rdgAPI/rdglist" class="btn btn-light btn-round">목록</a>
    <a href="#" class="btn btn-light btn-round" id="btnTop">▲ TOP</a>
  </div>
</div>
	
</body>
</html>