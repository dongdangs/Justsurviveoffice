<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%
	String ctxPath = request.getContextPath();
    //     /myspring
%>
<jsp:include page="../header/header1.jsp" /> 

<style type="text/css">
    th {background-color: #ddd}
    .boardNameStyle {font-weight: bold;
                   color: navy;
                   cursor: pointer;}
    a {text-decoration: none !important;} /* 페이지바의 a 태그에 밑줄 없애기 */
.board-list {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.board-card {
  border: 1px solid #ddd;
  border-radius: 8px;
  padding: 12px;
  margin-right: 10%;
  background: #fff;
  cursor: pointer;
  transition: box-shadow 0.2s;
}

.board-card:hover {
  box-shadow: 0 2px 8px rgba(0,0,0,0.15);
}

.board-card .title {
  font-size: 1.1rem;
  font-weight: bold;
  margin-bottom: 8px;
}

.board-card .preview {
  font-size: 0.9rem;
  color: #555;
  margin-bottom: 8px;
}

.board-card .thumbnail {
  width: 80px;
  height: 80px;
  object-fit: cover;
  margin-bottom: 8px;
}

.board-card .meta {
  font-size: 0.8rem;
  color: #888;
  display: flex;
  gap: 10px;
}

.title,content { /* 제목과 내용의 라인을 한줄로 제한하고, 이상이되면 안보이게! */
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
}
</style> 

<script type="text/javascript">
   $(function(){
	   
	   $('span.boardName').hover(function(e){
		   $(e.target).addClass("boardNameStyle");
	   }, function(e){
		   $(e.target).removeClass("boardNameStyle");
	   });
	   
	   // 글검색시 글검색어 입력후 엔터를 했을 경우 이벤트 작성하기
	   $('input:text[name="searchWord"]').bind("keyup", function(e){
		   if(e.keyCode == 13) { // 엔터를 했을 경우
			   searchBoard();
		   }
	   });
	   
	   // 글목록 검색시 검색조건 및 검색어 값 유지시키기
	   if(${not empty requestScope.searchType}) {
		   $('select[name="searchType"]').val("${requestScope.searchType}");
	   }
	   if(${not empty requestScope.searchWord}) {
		   $('input[name="searchWord"]').val("${requestScope.searchWord}");
	   }
	   
	   
	   
	   <%-- === 검색어 입력시 자동글 완성하기 2 === --%>
	   $('div#displayList').hide();
	   
	   $('input[name="searchWord"]').keyup(function(){
		   
		   const wordLength = $(this).val().trim().length;
		   // 검색어에서 공백을 제거한 길이를 알아온다.
		   
		   if(wordLength == 0) {
			   $('div#displayList').hide();
			   // 검색어가 공백이거나 검색어 입력후 백스페이스키를 눌러서 검색어를 모두 지우면 검색된 내용이 안 나오도록 해야 한다. 
		   }
		   
		   else {
			   if( $('select[name="searchType"]').val() == "boardName" || 
				   $('select[name="searchType"]').val() == "fk_id" ) {
				   
				   $.ajax({
					   url:"<%= ctxPath%>/board/wordSearchShow",
					   type:"get",
					   data:{"searchType":$('select[name="searchType"]').val()
						    ,"searchWord":$('input[name="searchWord"]').val()},
					   dataType:"json",
					   success:function(json){
						   <%-- === 검색어 입력시 자동글 완성하기 7 === --%>
						   if(json.length > 0) {
							   // 검색된 데이터가 있는 경우임.
							   let v_html = ``;
							   
							   $.each(json, function(index, item){
								   const word = item.word;
								   
								   const idx = word.toLowerCase().indexOf($('input[name="searchWord"]').val().toLowerCase());
								   const len = $('input[name="searchWord"]').val().length;
							       const result = word.substring(0, idx) + "<span style='color:red;'>"+word.substring(idx, idx+len)+"</span>" + word.substring(idx+len);
							       v_html += `<span style='cursor:pointer;' class='result'>\${result}</span><br>`;
							   });// end of $.each(json, function(index, item){})-------------------
							   
							   const input_width = $('input[name="searchWord"]').css("width"); // 검색어 input 태그 width 값 알아오기 
							   
							   $('div#displayList').css({"width":input_width}); // 검색결과 div 의 width 크기를 검색어 입력 input 태그의 width 와 일치시키기 
							   
							   $('div#displayList').html(v_html).show();
						   }
					   },
					   error: function(request, status, error){
						   console.log("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
					   } 
				   });
			   }
		   }
	   });// end of $('input[name="searchWord"]').keyup(function(){})-----------------
	   
	   <%-- === 검색어 입력시 자동글 완성하기 8 === --%>
	   $(document).on('click', 'span.result', function(e){
		    const word = $(e.target).text();
		    $('input[name="searchWord"]').val(word); // 텍스트박스에 검색된 결과의 문자열을 입력해준다.
		    $('div#displayList').hide();
		    searchBoard(); // 글목록 검색하기 요청
	   });
	   
	   $(".btn-bookmark").on("click", function(e) {
	        e.preventDefault();
	        e.stopPropagation(); // 게시글 클릭과 이벤트 충돌 방지
	
	        const icon = $(this);
	        const boardNo = icon.data("boardno");

	        $.ajax({
	            type: "POST",
	            url: "<%=ctxPath%>/bookmark/toggle",
	            data: { boardNo: boardNo },
	            success: function(json) {
	                if(json === "notLogin") {
	                    alert("로그인이 필요합니다!");
	                    location.href = "<%=ctxPath%>/login";
	                    return;
	                }
	                if (json === "bookmarked") {
	                    icon.removeClass("fa-regular")
	                        .addClass("fa-solid text-warning")
	                        .attr("title","북마크 해제");
	                } else if (json === "removed") {
	                    icon.removeClass("fa-solid text-warning")
	                        .addClass("fa-regular")
	                        .attr("title","북마크");
	                } else {
	                    alert("알 수 없는 응답: " + json);
	                }
	            },
	            error: function(request, status, error) {
	                alert("code: "+request.status+"\nmessage: "+request.responseText+"\nerror: "+error);
	            }
	        });
	    });
	   
	   
	   
   }); // end of $(function(){})--------------------------
   
   
   // Function Declaration
   function view(boardNo, fk_id){

	 // 글 1개만 보기( POST 방식 )
	 const form = document.viewForm;
	 form.boardNo.value = boardNo;
	 form.fk_id,value = fk_id	
	 if(${not empty requestScope.searchType
		 || not empty requestScope.searchWord}) {
		// 글목록보기시 검색조건이 있을 때 글 1개 보기를 하면, 
		// 글 1개를 보여주면서 이전글보기 다음글보기를 하면 검색조건내에서 이전 과 다음글이 나와야 하므로 
		// 글목록보기시 검색조건을 /board/view 을 담당하는 메소드로 넘겨주어야 한다.
		form.searchType.value = "${requestScope.searchType}"; 
		form.searchWord.value = "${requestScope.searchWord}"; 
	 }
	 form.method = "post";
	 form.action = "<%= ctxPath%>/board/view";
     form.submit();
	
   }// end of function view(boardNo,fk_id)----------------------

   
   
   
   // === 글목록 검색하기 요청 === //
   function searchBoard() {
	   const form = document.searchForm;
   <%--  
	   form.method = "get";
	   form.action = "<%= ctxPath%>/board/list?category=?&...";
   --%>	   
	   form.submit();
   }
   
</script>

<div class="col-md-9" style="background-image: url('<%= ctxPath %>/images/background.png'); border: solid 2px blue;">
	<h2 style="margin-bottom: 30px; font-size: 25pt; font-weight: bold;">${category}글목록</h2>
	<%-- === 글검색 폼 추가하기 : 글제목, 글내용, 글제목+글내용, 글쓴이로 검색을 하도록 한다. === --%>
	<form name="searchForm" style="margin-top: 20px;">
		<select name="searchType" style="height: 26px;">
			<option value="boardName">글제목</option>
			<option value="boardContent">글내용</option>
			<option value="boardName_boardContent">글제목+글내용</option>
			<option value="fk_id">글쓴이</option>
		</select>
		<input type="text" name="searchWord" size="50" autocomplete="off" /> 
	       <input type="text" style="display: none;"/> <%-- form 태그내에 input 태그가 오로지 1개 뿐일경우에는 엔터를 했을 경우 검색이 되어지므로 이것을 방지하고자 만든것이다. --%>  
		<button type="button" class="btn btn-secondary btn-sm" onclick="searchBoard()">검색</button> 
		
		<span><a href="<%=ctxPath %>/board/write?category=${category}" class="btn btn-secondary btn-sm" 
				style="background-color: navy;">글쓰기</a></span>
		<span><input name="category" style="display: none" value="${category}"/></span>
	</form> 
	
	
	<%-- === 검색어 입력시 자동글 완성하기 1 === --%>
	<div id="displayList" style="border:solid 1px gray; border-top:0px; height:100px; margin-left:8.7%; margin-top:-1px; margin-bottom:30px; overflow:auto;">
    </div>
	
	<%--  특정 글제목을 클릭했을때, 특정 글1개를 보여줄때 POST 방식으로 넘기기 위해 form 태그를 만들겠다. --%>
	<form name="viewForm">
	   <input type="hidden" name="boardNo"/>
	   <input type="hidden" name="fk_id" /> 
	   <input type="hidden" name="searchType" />
	   <input type="hidden" name="searchWord" />
	   <input type="hidden" name="category" value="${category}" />
	</form>
	
	<br><br>
		
    <c:if test="${not empty requestScope.boardList}">
		<div class="board-list">
		  <c:forEach var="boardDto" items="${boardList}" varStatus="status">
		    <div class="board-card">
		      <div style="display: flex;" onclick="view('${boardDto.boardNo}', '${boardDto.fk_id}')">
		        <div>
		       		 <!-- 제목 -->
		        	<h3 class="title" style="margin-right: 10%">${boardDto.boardName}</h3>
					<!-- 내용 -->
		    	 	<div class="content" style="color: grey">${boardDto.boardContent}</div>
		        </div>
		        
		        <!-- 첨부 이미지 썸네일 -->
		        <c:if test="${boardDto.boardFileName ne null}">
		          <img src="<%=ctxPath %>/files/${boardDto.boardFileName}" class="thumbnail" style="margin-left: auto;"/>
		        </c:if>
		        <c:if test="${boardDto.boardFileName eq null}"><br><br><br></c:if>
		      </div>
		       
		      <!-- 작성자/날짜/조회수 -->
		      <div class="meta" >
		        <span>${boardDto.fk_id}</span>
		        <span>${boardDto.formattedDate}</span>
		        <span class="fa-regular fa-eye" style="font-size: 8pt">&nbsp;${boardDto.readCount}</span>
			    <i class="btn-bookmark ${boardDto.bookmarked ? 'fa-solid text-warning' : 'fa-regular'}
			    	fa-bookmark fa-regular" style="margin: auto; cursor: pointer;"
			     	></i> 
		      </div>
		    </div>
		  </c:forEach>
		</div>
	</c:if>
    <c:if test="${empty requestScope.boardList}">
      <tr>
        <td colspan="6">첫 번째 게시물을 올려보세요!</td> 
      </tr>
    </c:if>
	
	
	<%-- === 페이지바 보여주기 === --%>
	<div align="center" style="border: solid 0px gray; width: 80%; margin: 30px auto;">
	     ${requestScope.pageBar} page
	</div>
	
  </div>	




   
    