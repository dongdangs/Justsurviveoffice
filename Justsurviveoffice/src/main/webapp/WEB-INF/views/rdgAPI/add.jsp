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
<title>rdg 글쓰기 (임시)</title>

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
    
    
    
</style>

<script type="text/javascript">
	
	$(function(){
		
		<%-- === 스마트 에디터 구현 시작 === --%>
		//전역변수
		var obj = [];
		
		//스마트에디터 프레임생성
		nhn.husky.EZCreator.createInIFrame({
			oAppRef: obj,
			elPlaceHolder: "content",
			sSkinURI: "<%= ctxPath%>/smarteditor/SmartEditor2Skin.html",
			htParams : {
				// 툴바 사용 여부 (true:사용/ false:사용하지 않음)
				bUseToolbar : true,            
				// 입력창 크기 조절바 사용 여부 (true:사용/ false:사용하지 않음)
				bUseVerticalResizer : true,    
				// 모드 탭(Editor | HTML | TEXT) 사용 여부 (true:사용/ false:사용하지 않음)
				bUseModeChanger : true,
			}
		});
		<%-- === 스마트 에디터 구현 끝 === --%>
		
		
		// 글쓰기 버튼
		$('button#btnWrite').click(function(){
			
			<%-- === 스마트 에디터 구현 시작 === --%>
			// id가 content인 textarea에 에디터에서 대입
			obj.getById["content"].exec("UPDATE_CONTENTS_FIELD", []);
			<%-- === 스마트 에디터 구현 끝 === --%>
			
			// === 글제목 유효성 검사 === //
			const subject = $('input:text[name="boardName"]').val().trim();
			if(subject == "") {
				alert("글제목을 입력하세요!!");
				$('input:text[name="boardName"]').val("");
				return;	// 종료
			}
			
			// === 글내용 유효성 검사(스마트 에디터를 사용하는 경우) === //
			let content_val = $('textarea[name="boardContent"]').val().trim();
			
		//	alert(content_val);	// content 에 공백만 여러개를 입력하여 쓰기할 경우 알아보는 것.
		//	<p>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp;</p> 이라고 나온다.
			
			content_val = content_val.replace(/&nbsp;/gi, "");	// 공백(&nbsp;) 을 "" 으로 변환
			/*
				대상문자열.replace(/찾을 문자열/gi, "변경할 문자열");
				==> 여기서 꼭 알아야 될 점은 나누기(/)표시안에 넣는 찾을 문자열의 따옴표는 없어야 한다는 점입니다. 
				그리고 뒤의 gi는 다음을 의미합니다.
				
				g : 전체 모든 문자열을 변경 global
				i : 영문 대소문자를 무시, 모두 일치하는 패턴 검색 ignore
			*/
		//	alert(content_val);
		//	<p>         </p>
			
			content_val = content_val.substring(content_val.indexOf("<p>") + 3);
		//	alert(content_val);
		//	         </p>
			
			content_val = content_val.substring(0, content_val.indexOf("</p>"));
		//	alert(content_val);
			
			if(content_val.trim().length == 0) {
				alert("글내용을 입력하세요!!");
				return;	// 종료 
			}
			
			
			// 폼(form)을 전송 (submit)
			const frm = document.addFrm;
			frm.method = "post";
			frm.action = "<%= ctxPath%>/rdgAPI/add";
			frm.submit();
		});
		
	});// end of $(function(){})-----------------------
	
</script>

</head>
<body>
	
	<div style="display: flex;">
		<div style="margin: auto; padding-left: 3%;">
			
				<h2 style="margin-bottom: 30px;">글쓰기</h2>
			
			<%-- !!! 파일을 첨부하기 위해서는 먼저 form 태그의 enctype 을 enctype="multipart/form-data" 으로 해주어야 한다. 
					 또한 파일을 첨부하기 위해서는 전송방식이 post 이어야 한다. !!! --%>
			<form name="addFrm" enctype="multipart/form-data">
				<table style="width: 1024px" class="table table-bordered">
					<tr>
						<th style="width: 15%; background-color: #DDDDDD;">성명</th>
						<td>
							<input type="hidden" name="fk_id" value="${sessionScope.loginUser.id}" />
							<input type="hidden" name="fk_categoryNo" value="${sessionScope.loginUser.category.categoryNo}" />
							<input type="text" name="name" value="${sessionScope.loginUser.name}" readonly>
						</td>   
					</tr>
					
					<tr>
						<th style="width: 15%; background-color: #DDDDDD;">제목</th>
						<td>
								<input type="text" name="boardName" size="100" maxlength="200" />
						</td>
					</tr>
					
					<tr>
						<th style="width: 15%; background-color: #DDDDDD;">내용</th> 
						<td>
							<textarea style="width: 100%; height: 612px;" name="boardContent" id="content"></textarea>
						</td>
					</tr>
					
					<tr>
						<th style="width: 15%; background-color: #DDDDDD;">파일첨부</th> 
						<td>
							<input type="file" name="attach" />
						</td>
					</tr>
				</table>
				
				<div style="margin: 20px;">
					<button type="button" class="btn btn-secondary btn-sm mr-3" id="btnWrite">글쓰기</button>
					<button type="button" class="btn btn-secondary btn-sm" onclick="location.href='<%= ctxPath%>/rdgAPI/rdglist'">취소</button>  
				</div>
				
			</form>
			
		</div>
	</div>
	
</body>
</html>



