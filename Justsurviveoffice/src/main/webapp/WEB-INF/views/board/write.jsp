<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
    String ctxPath = request.getContextPath();
%>

<jsp:include page="../header/header1.jsp"></jsp:include>

<style type="text/css">
    /* 전체 페이지 스타일 */

    .container {
        width: 60%;
        margin: 50px auto;
        background-color: #fff;
        padding: 20px;
        border-radius: 8px;
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
    }

    h1 {
        text-align: center;
        margin-bottom: 20px;
    }

    label {
        font-weight: bold;
        margin-top: 10px;
    }

    input, textarea {
        width: 100%;
        padding: 10px;
        margin: 5px 0 20px 0;
        border: 1px solid #ccc;
        border-radius: 5px;
    }

    textarea {
        height: 300px;
    }

    button {
        width: 100%;
        padding: 15px;
        background-color: #4CAF50;
        color: white;
        border: none;
        border-radius: 5px;
        font-size: 16px;
    }

    button:hover {
        background-color: #45a049;
    }

</style>

<script type="text/javascript">

	$(function(){
		
		$('button#btnWrite').click(function(){
			
			// 글제목 유효성 검사
			const boardName = $('input:text[name="boardName"]').val().trim();
			if(boardName == "") {
				alert("제목을 입력하세요");
				return;
			}
			
			// 글내용 유효성 검사
			const boardContent = $("textarea#content").val().trim();
			if(boardContent == "") {
				alert("내용을 입력하세요");
				return;
			}
			
			// form 전송
			const form = document.writeForm;
			form.method = "post";
			form.action = "<%= ctxPath%>/board/write";
			form.submit();
		});
		
	});
	
</script>

<div style="display: flex;" class="container">
	<div style="margin: auto; padding-left: 3%;">
	    <h1>게시글 작성</h1>
	    <form action="writeForm" name="writeForm" method="post" enctype="multipart/form-data">
	    	<label>작성자</label>
	        <input type="hidden" name="fk_id" value="${sessionScope.loginUser.id}" readonly />
	        <input type="text" name="name" value="${sessionScope.loginUser.name}" readonly /> 
	        
	        <label for="boardName">제목</label>
	        <input type="text" id="boardName" name="boardName" required placeholder="제목을 입력하세요">
	        
	        <label for="boardContent">내용</label>
	        <textarea id="content" name="boardContent" required placeholder="내용을 입력하세요"></textarea>
	        
	        <label for="file">파일첨부</label>
	        <input type="file" id="file" name="file">
	        
	        <button type="button" id="btnWrite">작성 완료</button>
	    </form>
	</div>
</div>
