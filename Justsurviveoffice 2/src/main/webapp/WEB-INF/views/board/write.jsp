<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 

<%
    String ctxPath = request.getContextPath();
    //     /myspring
%>   

<jsp:include page="../header/header1.jsp" />

<script type="text/javascript">
   $(function(){
	   
	    // 글쓰기 버튼
	    $('button#btnWrite').click(function(){
	        // === 글제목 유효성 검사 === //
	        const boardName = $('input[name="boardName"]').val().trim();
	        if(boardName == "") {
	        	alert("글제목을 입력하세요!!");
	        	$('input[name="boardName"]').val("");
	        	return; // 종료
	        }
	        
	        // === 글내용 유효성 검사 === //
	        let contentVal = $('textarea[name="boardContent"]').val().trim();
	        
	        if(contentVal != "") {
	        	contentVal = $('textarea[name="boardContent"]').val().trim();
	        	//alert(">>"+ contentVal+ "<<");
	        }
	        if(contentVal.length == 0) {
	        	alert("글내용을 입력해주세요");
	        	return; // 종료
	        }
	        
	        // 폼(form)을 전송(submit)
	        const form = document.writeForm;
	        form.method = "post";
	        form.action = "<%= ctxPath%>/board/write";
	        form.submit();
	    });
	    

   });// end of $(function(){})-----------------
   
   // 이미지 업로드시에만 이미지 미리보기 함수!
   function previewImage(event) {
       const file = event.target.files[0];
       const preview = document.getElementById('preview');

       if (file.type.startsWith("image/")) {
    	   //이미지 업로드시에만 작동!
           const reader = new FileReader();
           reader.onload = function(e) {
               preview.src = e.target.result;
               preview.style.display = "block";
           }
           reader.readAsDataURL(file);
       } else { // 이미지 아닌 파일은 그대로 안보이게 만들기
           preview.style.display = "none";
           preview.src = "";
       }
   }

</script>
<head>
 <style type="text/css">
 .post-card { 
  max-width: 600px;
  margin: 20% auto;
  background: #fff;
  border-radius: 16px;
  box-shadow: 0 4px 12px rgba(0,0,0,0.1);
  padding: 20px;
}

.post-header {
  display: flex;
  align-items: center;
  margin-bottom: 16px;
  font-weight: bold;
  font-size: 25px;
}

.post-body textarea {
  width: 100%;
  border: none;
  resize: none;
  min-height: 200px;
  font-size: 14px;
  outline: none;
}

.post-footer {
  display: flex;
  justify-content: flex-end;
  margin-top: 16px;
}

.post-footer button {
  background: #5f5fff;
  border: none;
  color: white;
  border-radius: 8px;
  padding: 8px 16px;
  cursor: pointer;
}
.post-footer button.cancel {
  background: #ccc;
  margin-right: 8px;
}
.preview {
            margin-top: 10px;
            max-width: 300px;
            max-height: 300px;
            border: 1px solid #ccc;
            border-radius: 10px;
            object-fit: contain;
        }
 </style>
</head>
<div style="display: flex; background-image: url('<%= ctxPath %>/images/background.png');">
   <div style="margin: auto; padding-left: 3%;">
      
      <%-- !!! 파일을 첨부하기 위해서는 먼저 form 태그의 enctype 을 enctype="multipart/form-data" 으로 해주어야 한다. 
               또한 파일을 첨부하기 위해서는 전송방식은 post 이어야 한다. !!! --%>
      <form name="writeForm" enctype="multipart/form-data">
        <div class="post-card">
  
		  <div class="post-header">
		    <div class="">새 게시글</div>
		    <input class="fk_id" style="display: none"
		    	 name="fk_id" value="${sessionScope.loginUser.id}"/>
   		    <input class="fk_categoryNo" style="display: none"
		    	 name="fk_categoryNo" value="${requestScope.category}"/>
		  </div>
		  
		  <!-- 업로드한 이미지 미리보기 -->
		  <img id="preview" class="preview" style="display:none;">
		  <!-- 파일 업로드 -->
    	  <input name="attach" class="btn" type="file" 
    	  		onchange="previewImage(event)">
  		  <br><br>
  		  
		  <!-- 제목 -->
		  <input type="text" name="boardName" placeholder="제목을 입력하세요" 
     			  class="form-control mb-2" maxlength="100">	  
		  <!-- 내용 (스마트에디터 들어가는 textarea) -->
		  <div class="post-body">
		    <textarea name="boardContent" id="boardContent" 
		    		  placeholder="   무슨 생각을 하고 계신가요?"></textarea>
		  </div>
		  
		  <!-- 버튼 -->
		  <div class="post-footer">
		    <button type="button" class="cancel" onclick="history.back()">취소</button>
		    <button type="button" id="btnWrite">게시하기</button>
		  </div>
		</div>
      </form>
   
   </div>
</div>








    