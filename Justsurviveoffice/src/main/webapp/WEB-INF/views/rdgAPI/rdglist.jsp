<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%
	String ctxPath = request.getContextPath();
%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>임시 게시판(꼰대존)</title>

<!-- Bootstrap CSS -->
<link rel="stylesheet" href="<%= ctxPath%>/bootstrap-4.6.2-dist/css/bootstrap.min.css" type="text/css">

<%-- Font Awesome 6 Icons --%>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">

<%-- Optional JavaScript --%>
<script type="text/javascript" src="<%=ctxPath%>/js/jquery-3.7.1.min.js"></script>
<script type="text/javascript" src="<%=ctxPath%>/bootstrap-4.6.2-dist/js/bootstrap.bundle.min.js" ></script>
<script type="text/javascript" src="<%=ctxPath%>/smarteditor/js/HuskyEZCreator.js" charset="utf-8"></script>

<style type="text/css">
	
	:root{
	  --row-h:200px;
	  --gap:16px;
	  --border:#e5e7eb; --hover:#f9fafb;
	  
	  --pad:16px;             /* 행 상/하/우 패딩 */
	  --meta-h:24px;          /* meta(아이콘 한 줄) 높이 */
	  --thumb: calc(var(--row-h) - (var(--pad) * 2) - var(--meta-h) - 8px); /* meta 제외한 나머지 높이만큼 */
	}
	
	/* 래퍼 */
	.post-list-wrap{ padding:20px 16px; }
	
	/* ===== 한 행 ===== */
	.post-row{
	  position:relative;             /* ★ 절대배치 기준 */
	  display:flex; align-items:stretch;
	  gap:0;                         /* ★ 기본 0: 썸네일 없으면 여백 없음 */
	  padding: var(--pad) 0; 
	  border-bottom:1px solid var(--border);
	  color:#111827; min-height:var(--row-h);
	}
	.post-row:hover{ background:var(--hover); text-decoration:none }
	
	/* 썸네일 있는 행만 오른쪽 패딩 확보(본문이 썸네일 영역을 침범하지 않도록) */
	.post-row.has-thumb{
	  padding-right: calc(var(--pad) + var(--thumb) + var(--gap));  /* ← 변수로 통일 */
	}
	
	/* ===== 본문 ===== */
	.post-main {
	  flex: 1 1 auto;
	  min-width: 0;
	  display: flex;
	  flex-direction: column;
	  padding-right: 0;
	  justify-content: flex-start; 
	}
	.post-title {
	  font-size: 16px;
	  font-weight: 800;
	  line-height: 1.35;
	  margin-bottom: 6px;
	  padding-left: var(--pad);   /* ✅ 글자만 왼쪽에 16px 들여쓰기 */
	}
	.post-excerpt{
	  font-size:13px; color:#6b7280; margin:0;
	
	  /* 2줄 고정 */
	  display:-webkit-box;
	  -webkit-line-clamp:2;
	  -webkit-box-orient:vertical;
	  overflow:hidden;
	
	  /* 폴백 (비 WebKit에서도 2줄 한정) */
	  line-height:1.5;
	  max-height:calc(1.5em * 2);
	  word-break:break-word;
	  
	  margin-top:auto;
	  margin-bottom:auto;
	  
	  padding-left: var(--pad);   /* ✅ 글자만 왼쪽에 16px 들여쓰기 */
	}
	
	/* ===== 메타/지표 - 우하단 고정 ===== */
	.meta{
	  position:absolute;
	  left: var(--pad);
	  right: var(--pad);
	  bottom: var(--pad);
	  display:flex;
	  justify-content:space-between;  /* ← 좌/우 나눔 */
	  align-items:center;
	  font-size:12px; color:#6b7280;
	  min-height: var(--meta-h);
	}
	
	.meta-left {
	  display:flex;
	  align-items:center;
	  gap:.25rem;  /* 작성자 · 시간 사이 간격 */
	}
	
	.stats{ display:flex; align-items:center; gap:16px }  /* ml-auto 불필요 */
	.stat i{ margin-right:6px }
	.meta .dot{ margin:0 .25rem }
	
	/* ===== 썸네일 - 우측 고정, 정사각형 꽉 채움 ===== */
	.post-thumb{
	  position:absolute;
	  right: var(--pad);
	  top:   var(--pad);                      /* 상단 고정 */
	  width: var(--thumb);
	  height: var(--thumb);                   /* ← 계산된 높이: meta 제외 만큼 꽉 */
	  object-fit:cover; border-radius:12px;
	  border:1px solid var(--border); background:#eef2f7;
	}
	
	@media (max-width:576px){
	  .post-thumb{ display:none; }
	  .post-row.has-thumb{ padding-right: var(--pad); } /* 썸네일 공간 제거 */
	}
	
	/* 페이지바는 그대로 OK */
	.pagination1{ margin:22px auto 0; display:flex; justify-content:center; gap:6px; flex-wrap:wrap; }
	.page-btn{
	  min-width:36px; height:36px; padding:0 10px;
	  border:1px solid var(--border); background:#fff; border-radius:10px;
	  font-size:14px; color:#111827; display:flex; align-items:center; justify-content:center;
	}
	.page-btn:hover{ background:var(--hover) }
	.page-btn.active{ background:rgba(79,70,229,.10); color:#4338ca; border-color:rgba(79,70,229,.35); font-weight:700; }
	.page-btn.disabled{ pointer-events:none; opacity:.45 }
	
</style>

<script type="text/javascript">
	
	//=== 글목록 검색하기 요청 === //
	function goSearch() {
		const frm = document.searchFrm;
		frm.action = "<%= ctxPath%>/rdgAPI/rdglist"	
		frm.method = "Get";
		frm.submit();
	}// end of function goSearch()---------------------------
	
</script>

</head>
<body>
	
<div class="container mt-4">
	<div class="row">
		<div class="col-md-3" style="border: solid 1px red;">
		</div>
		<div class="col-md-9 mx-auto">
			
			<!-- 제목 + 키워드 영역 -->
			<div class="d-flex align-items-center justify-content-between mb-3">
				<h2 class="mb-0">꼰대존(나중에 requestScope 사용)</h2>
				
				<!-- 키워드 테이블 -->
				<table class="table table-sm table-bordered text-center mb-0" style="width:200px;">
					<thead class="thead-light">
					    <tr>
					    	<th colspan="2">🔥🔥TOP 키워드🔥🔥</th>
					    </tr>
				    </thead>
					<tbody>
						<c:if test="${not empty requestScope.keyword_top}">
							<c:forEach var="keyword" items="${requestScope.keyword_top}" varStatus="status">
								<tr>
									<td>${status.count}</td>
									<td>${keyword.key}</td>
								</tr>
							</c:forEach>
						</c:if>
						<c:if test="${empty requestScope.keyword_top}">
							<tr>
								<td colspan="2">데이터가 없습니다.</td>
							</tr>
						</c:if>
					</tbody>
				</table>
			</div>
			
			<div class="post-list-wrap">
			
				<c:if test="${not empty requestScope.boardDtoList}">
					<c:forEach var="dto" items="${requestScope.boardDtoList}">
						<c:choose>
							<c:when test="${fn:contains(dto.boardContent, '<img')}">
								
								<a href="#" class="post-row has-thumb">
									<div class="post-main">
										<div class="post-title">${dto.boardName}</div>
										<div class="post-excerpt">
											<!-- 서비스에서 구현방식 생각중 -->
										</div>
										<div class="meta">
											<div class="meta-left">
												<span>${dto.fk_id}</span>
												<span class="dot">·</span>
												<span>${dto.createdAtBoard}</span>
											</div>
											
											<div class="stats">
												<span class="stat"><i class="fa-regular fa-eye"></i>${dto.readCount}</span>
												<span class="stat"><i class="fa-regular fa-comment"></i>0</span>
												<span class="stat"><i class="fa-regular fa-heart"></i>0</span>
											</div>
										</div>
									</div>
									<!-- 썸네일이 있을 때만 넣기 -->	<!-- 서비스에서 구현방식 생각중 -->
									<img class="post-thumb" src="" alt="thumb">
								</a>
								
							</c:when>
							<c:otherwise>
								
								<a href="#" class="post-row has-thumb">
									<div class="post-main">
										<div class="post-title">${dto.boardName}</div>
										<div class="post-excerpt">
											${dto.boardContent}
										</div>
										<div class="meta">
											<div class="meta-left">
												<span>${dto.fk_id}</span>
												<span class="dot">·</span>
												<span>${dto.createdAtBoard}</span>
											</div>
											
											<div class="stats">
												<span class="stat"><i class="fa-regular fa-eye"></i>${dto.readCount}</span>
												<span class="stat"><i class="fa-regular fa-comment"></i>0</span>
												<span class="stat"><i class="fa-regular fa-heart"></i>0</span>
											</div>
										</div>
									</div>
								</a>
								
							</c:otherwise>
						</c:choose>
					</c:forEach>
				</c:if>
				
				<!-- === 글검색 폼 === -->
				<form name="searchFrm" class="form-inline mb-3" style="margin-top: 1%;">
					<label for="searchType" class="mr-2 font-weight-bold">검색:</label>
					
					<select name="searchType" id="searchType" class="form-control form-control-sm mr-2">
						<option value="boardName">글제목</option>
						<option value="boardContent">글내용</option>
						<option value="boardName_boardContent">글제목+글내용</option>
						<option value="name">글쓴이</option>
					</select>
					
					<input type="text" name="searchWord" class="form-control form-control-sm mr-2" style="width:280px;" placeholder="검색어를 입력하세요" autocomplete="off"/>
					<input type="text" style="display: none;"/>	<%-- form 태그내에 input 태그가 오로지 1개 뿐일경우에는 엔터를 했을 경우 검색이 되어지므로 이것을 방지하고자 만든것이다. --%>
					<button type="button" class="btn btn-secondary btn-sm" onclick="goSearch()">검색</button>
				</form>
				
				<!-- === 자동완성 영역 === -->
				<div id="displayList" class="border rounded bg-white shadow-sm" style="max-height:150px; overflow:auto; width:400px; display:none;">
					<!-- 자동완성 결과 들어갈 자리 -->
				</div>
				
				<button type="button" class="btn btn-primary btn-sm mt-2 mt-md-0 float-right" onclick="location.href='<%= ctxPath%>/rdgAPI/addStart'">글쓰기</button>
				
				<!-- 페이징 (임시 링크) -->
				<div class="pagination1">
					
					<c:set var="cur"  value="${currentShowPageNo}" />
<c:set var="last" value="${totalPage}" />

<div class="pagination1">
  <!-- 맨처음 -->
  <c:choose>
    <c:when test="${cur > 1}">
      <c:url var="firstUrl" value="/rdgAPI/rdglist">
        <c:param name="currentShowPageNo" value="1"/>
        <c:param name="searchType" value="${searchType}"/>
        <c:param name="searchWord" value="${searchWord}"/>
      </c:url>
      <a class="page-btn" href="${firstUrl}">[맨처음]</a>
    </c:when>
    <c:otherwise>
      <span class="page-btn disabled">[맨처음]</span>
    </c:otherwise>
  </c:choose>

  <!-- 이전 -->
  <c:choose>
    <c:when test="${cur > 1}">
      <c:url var="prevUrl" value="/rdgAPI/rdglist">
        <c:param name="currentShowPageNo" value="${cur - 1}"/>
        <c:param name="searchType" value="${searchType}"/>
        <c:param name="searchWord" value="${searchWord}"/>
      </c:url>
      <a class="page-btn" href="${prevUrl}">&laquo;</a>
    </c:when>
    <c:otherwise>
      <span class="page-btn disabled">&laquo;</span>
    </c:otherwise>
  </c:choose>

  <!-- 페이지 번호 -->
  <c:forEach var="i" begin="1" end="${last}">
    <c:choose>
      <c:when test="${i == cur}">
        <a class="page-btn active" href="#">${i}</a>
      </c:when>
      <c:otherwise>
        <c:url var="pageUrl" value="/rdgAPI/rdglist">
          <c:param name="currentShowPageNo" value="${i}"/>
          <c:param name="searchType" value="${searchType}"/>
          <c:param name="searchWord" value="${searchWord}"/>
        </c:url>
        <a class="page-btn" href="${pageUrl}">${i}</a>
      </c:otherwise>
    </c:choose>
  </c:forEach>

  <!-- 다음 -->
  <c:choose>
    <c:when test="${cur < last}">
      <c:url var="nextUrl" value="/rdgAPI/rdglist">
        <c:param name="currentShowPageNo" value="${cur + 1}"/>
        <c:param name="searchType" value="${searchType}"/>
        <c:param name="searchWord" value="${searchWord}"/>
      </c:url>
      <a class="page-btn" href="${nextUrl}">&raquo;</a>
    </c:when>
    <c:otherwise>
      <span class="page-btn disabled">&raquo;</span>
    </c:otherwise>
  </c:choose>

  <!-- 마지막 -->
  <c:choose>
    <c:when test="${cur < last}">
      <c:url var="lastUrl" value="/rdgAPI/rdglist">
        <c:param name="currentShowPageNo" value="${last}"/>
        <c:param name="searchType" value="${searchType}"/>
        <c:param name="searchWord" value="${searchWord}"/>
      </c:url>
      <a class="page-btn" href="${lastUrl}">[마지막]</a>
    </c:when>
    <c:otherwise>
      <span class="page-btn disabled">[마지막]</span>
    </c:otherwise>
  </c:choose>
</div>
					
					<!-- <span class="page-btn disabled">&laquo;</span>
					<a class="page-btn active" href="#">1</a>
					<a class="page-btn" href="#">2</a>
					<a class="page-btn" href="#">3</a>
					<a class="page-btn" href="#">4</a>
					<a class="page-btn" href="#">&raquo;</a> -->
				</div>
				
			</div>
		</div>
	</div>
</div>
	
</body>
</html>