<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%
	String ctxPath = request.getContextPath();
%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>문의 게시판 (임시)</title>

<!-- Required meta tags -->
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<title>SPRING BOOT 1</title>

<!-- Bootstrap CSS -->
<link rel="stylesheet" href="<%= ctxPath%>/bootstrap-4.6.2-dist/css/bootstrap.min.css" type="text/css">

<%-- Font Awesome 6 Icons --%>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">

<%-- 직접 만든 CSS 1 --%>
<link rel="stylesheet" type="text/css" href="<%=ctxPath%>/css/style1.css" />

<%-- Optional JavaScript --%>
<script type="text/javascript" src="<%=ctxPath%>/js/jquery-3.7.1.min.js"></script>
<script type="text/javascript" src="<%=ctxPath%>/bootstrap-4.6.2-dist/js/bootstrap.bundle.min.js" ></script>
<script type="text/javascript" src="<%=ctxPath%>/smarteditor/js/HuskyEZCreator.js" charset="utf-8"></script>

<%-- 스피너 및 datepicker 를 사용하기 위해 jQueryUI CSS 및 JS --%>
<link rel="stylesheet" type="text/css" href="<%=ctxPath%>/jquery-ui-1.13.1.custom/jquery-ui.min.css" />
<script type="text/javascript" src="<%=ctxPath%>/jquery-ui-1.13.1.custom/jquery-ui.min.js"></script>

<style type="text/css">
    
    th {background-color: #ddd}
    
    .subjectStyle {font-weight: bold;
                   color: navy;
                   cursor: pointer; }
                   
    a {text-decoration: none !important;} /* 페이지바의 a 태그에 밑줄 없애기 */
    
</style>

<script type="text/javascript">
	
	$(function(){
		
		$('span.subject').hover(function(e){
			$(e.target).addClass("subjectStyle");
		}, function(e){
			$(e.target).removeClass("subjectStyle");
		});
		
		
		// 글검색시 글검색어 입력후 엔터를 했을 경우 이벤트 작성하기
		$('input:text[name="searchWord"]').bind("keyup", function(e){
			if(e.keyCode == 13) {	// 엔터를 했을 경우
				goSearch();
			}
		});
		
		
		// 글목록 검색시 검색조건 및 검색어 값 유지시키기
		if(${not empty requestScope.paraMap}) {
			$('select[name="searchType"]').val("${requestScope.paraMap.searchType}");
			$('input[name="searchWord"]').val("${requestScope.paraMap.searchWord}");
		}
		
	});// end of $(function(){})-----------------------
	
	
	// Function Declaration
	function goView(seq){
		
		//GET 방식
	<%--
		location.href = `<%= ctxPath%>/board/view?seq=\${seq}`;
	--%>
	<%--	
	//	또는
		location.href = `<%= ctxPath%>/board/view\${seq}`;
	//	또는
		location.href = `<%= ctxPath%>/board/\${seq}`;
	--%>
		
		// 우리는 POST 방식으로 글1개 보기를 하겠습니다.
		const frm = document.goViewFrm;
		frm.seq.value=seq;
		
		if(${not empty requestScope.paraMap}) {
			// 글목록보기시 검색조건이 있을 때 글 1개 보기를 하면, 
			// 글 1개를 보여주면서 이전글보기 다음글보기를 하면 검색조건내에서 이전 과 다음글이 나와야 하므로 
			// 글목록보기시 검색조건을 /board/view 을 담당하는 메소드로 넘겨주어야 한다.
			frm.searchType.value = "${requestScope.paraMap.searchType}";
			frm.searchWord.value = "${requestScope.paraMap.searchWord}";
		}
		
		frm.method="post";
		frm.action = "<%= ctxPath%>/board/view";
	//	frm.submit();
		
	}// end of function goView(seq){}-----------------
	
	
	// === 글목록 검색하기 요청 === //
	function goSearch() {
		const frm = document.searchFrm;
	<%--	
		frm.method = "get";
		frm.actiom = "<%= ctxPath%>/board/list"
	--%>	
	//	frm.submit();
	}// end of function goSearch()---------------------------
	
</script>

</head>
<body>
	
	<div style="display: flex;">
	<div style="width: 80%; margin: auto; padding-left: 3%;">
		
		<h2 style="margin-bottom: 30px;">문의글목록 예시</h2>
		
		<table style="width: 100%;" class="table table-bordered">
			<thead>
				<tr>
					<th style="width: 10%;  text-align: center;">순번</th>
					<th style="width: 10%;  text-align: center;">글번호</th>
					<th style="width: 45%; text-align: center;">제목</th>
					<th style="width: 10%;  text-align: center;">성명</th>
					<th style="width: 15%; text-align: center;">날짜</th>
				</tr>
			</thead>
			
			<tbody>
				<c:if test="${not empty requestScope.boardList}">
					<c:forEach var="boardDto" items="${requestScope.boardList}" varStatus="status">
						<tr>
							<td align="center">
								${ (requestScope.totalCount) - (requestScope.currentShowPageNo - 1) * (requestScope.sizePerPage) - (status.index) }
							</td>
							<td align="center">${boardDto.seq}</td>
							<td>
								<%-- 파일첨부가 원글인 경우 시작 --%>
								<c:if test="${empty boardDto.fileName && boardDto.fk_seq == 0}">
									<c:if test="${boardDto.commentCount > 0}">
										<span class="subject" onclick="goView('${boardDto.seq}')">${boardDto.subject} <span style="vertical-align: super;">[<span style="color: red; font-style: italic; font-size: 9pt; font-weight: bold;">${boardDto.commentCount}</span>]</span></span>
									</c:if>
									
									<c:if test="${empty boardDto.fileName && boardDto.commentCount == 0}">
										<span class="subject" onclick="goView('${boardDto.seq}')">${boardDto.subject}</span>
									</c:if>
								</c:if>
								<%-- 파일첨부가 없는 원글인 경우 끝 --%>
								
								<%-- 파일첨부가 없는 답변글인 경우 시작 --%>
								<c:if test="${empty boardDto.fileName && boardDto.fk_seq > 0}">
									<c:if test="${boardDto.commentCount > 0}">
										<span class="subject" onclick="goView('${boardDto.seq}')"><span style="padding-left: ${boardDto.depthno*20}px;">↪️</span>${boardDto.subject} <span style="vertical-align: super;">[<span style="color: red; font-style: italic; font-size: 9pt; font-weight: bold;">${boardDto.commentCount}</span>]</span></span>
									</c:if>
									
									<c:if test="${boardDto.commentCount == 0}">
										<span class="subject" onclick="goView('${boardDto.seq}')"><span style="padding-left: ${boardDto.depthno*20}px;">↪️</span>${boardDto.subject}</span>
									</c:if>
								</c:if>
								<%-- 파일첨부가 없는 답변글인 경우 끝 --%>
								
								<%-- 파일첨부가 있는 원글인 경우 시작 --%>
								<c:if test="${not empty boardDto.fileName && boardDto.fk_seq == 0}">
									<c:if test="${boardDto.commentCount > 0}">
										<span class="subject" onclick="goView('${boardDto.seq}')">${boardDto.subject} <span style="vertical-align: super;">[<span style="color: red; font-style: italic; font-size: 9pt; font-weight: bold;">${boardDto.commentCount}</span>]</span>🗃️</span>
									</c:if>
									
									<c:if test="${boardDto.commentCount == 0}">
										<span class="subject" onclick="goView('${boardDto.seq}')">${boardDto.subject}🗃️</span>
									</c:if>
								</c:if>
								<%-- 파일첨부가 있는 원글인 경우 끝 --%>
								
								<%-- 파일첨부가 있는 답변글인 경우 시작 --%>
								<c:if test="${not empty boardDto.fileName && boardDto.fk_seq > 0}">
									<c:if test="${boardDto.commentCount > 0}">
										<span class="subject" onclick="goView('${boardDto.seq}')"><span style="padding-left: ${boardDto.depthno*20}px;">↪️</span>${boardDto.subject} <span style="vertical-align: super;">[<span style="color: red; font-style: italic; font-size: 9pt; font-weight: bold;">${boardDto.commentCount}</span>]</span>🗃️</span>
									</c:if>
									
									<c:if test="${boardDto.commentCount == 0}">
										<span class="subject" onclick="goView('${boardDto.seq}')"><span style="padding-left: ${boardDto.depthno*20}px;">↪️</span>${boardDto.subject}🗃️</span>
									</c:if>
								</c:if>
								<%-- 파일첨부가 있는 답변글인 경우 끝 --%>
								
							</td>
							<td align="center">${boardDto.name}</td>
							<td align="center">${boardDto.regDate}</td>
							<td align="center">${boardDto.readCount}</td>
						</tr>
					</c:forEach>
				</c:if>
				
				<c:if test="${empty requestScope.boardList}">
					<tr>
						<td colspan="5">데이터가 없습니다</td>
					</tr>
				</c:if>
			</tbody>
		</table>
		
		<button type="button" class="btn btn-primary" onclick="location.href='<%= ctxPath%>/rdgAPI/add'">문의 등록</button>
		
		<%-- === 페이지바 보여주기 === --%>
		<div align="center" style="border: solid 0px gray; width: 80%; margin: 30px auto;">
			${requestScope.pageBar}
		</div>
		
		<%-- === 글검색 폼 추가하기 : 글제목, 글내용, 글제목+글내용, 글쓴이로 검색을 하도록 한다. === --%>
		<form name="searchFrm" style="margin-top: 20px;">
			<select name="searchType" style="height: 26px;">
				<option value="subject">글제목</option>
				<option value="content">글내용</option>
				<option value="subject_content">글제목+글내용</option>
				<option value="name">글쓴이</option>
			</select>
			<input type="text" name="searchWord" size="50" autocomplete="off" /> 
			<input type="text" style="display: none;"/>	<%-- form 태그내에 input 태그가 오로지 1개 뿐일경우에는 엔터를 했을 경우 검색이 되어지므로 이것을 방지하고자 만든것이다. --%>  
			<button type="button" class="btn btn-secondary btn-sm" onclick="goSearch()">검색</button> 
		</form>
		
	</div>
</div>	


<%-- 특정 글제목을 클릭했을때, 특정 글1개를 보여줄때 POST 방식으로 넘기기 위해 form 태그를 만들겠다. --%>
<form name="goViewFrm">
	<input type="hidden" name="seq" />
	<input type="hidden" name="searchType" />
	<input type="hidden" name="searchWord" />
</form>
	
</body>
</html>