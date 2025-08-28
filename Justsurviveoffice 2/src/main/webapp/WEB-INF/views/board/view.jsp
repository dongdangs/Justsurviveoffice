<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%
	String ctxPath = request.getContextPath();
    //     /myspring 
%>
<jsp:include page="../header/header1.jsp" /> 
<html>
<style>
    .board-container {
        width: 80%;
        margin: 20px auto;
        border-bottom: 1px solid #ddd;
        padding-bottom: 20px;
    }
    .board-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
    }
    .board-header h2 {
        margin: 0;
    }
    .board-meta {
        font-size: 0.9em;
        color: #666;
    }
    .board-content {
        margin: 15px 0;
    }
    .board-file img {
        max-width: 300px;
        margin-top: 10px;
    }
    .board-actions {
        margin-top: 10px;
    }
    .comment-section {
        margin-top: 30px;
    }
    .comment {
        border-top: 1px solid #eee;
        padding: 10px 0;
    }
    .comment .meta {
        font-size: 0.8em;
        color: #555;
    }
    .btn {
        padding: 5px 10px;
        border: 1px solid #ccc;
        background: #f9f9f9;
        cursor: pointer;
    }
    .btn:hover {
        background: #eee;
    }
/* .content {  /* 내용: 줄바꿈 보존하기!! */
    white-space: pre-wrap; */   
    
    
    
     
}
</style>
<script type="text/javascript">
	$(function() {
		
		 // 댓글작성
	    $('button#addComment').click(function(){
	        
	        // === 댓글내용 유효성 검사 === //
	        let contentVal = $('textarea[name="content"]').val().trim();
	        
	        if(contentVal.length == 0) {
	        	alert("댓글내용을 입력해주세요 !");
	        	return; 
	        }
	        
	        const form = document.commentform;
	        form.method = "post";
	        form.action = "<%= ctxPath%>/comment/writeComment";
	        form.submit();
	    });
		
		 

		 // 댓글 삭제 
	    $(document).on("click", ".delete-comment", function () {
	        if (!confirm("정말로 삭제하시겠습니까?")) {
	            alert("삭제가 취소되었습니다.");
	            return;
	        }

	        const commentNo = $(this).data("id");
	        const fkBoardNo = "${boardDto.boardNo}";
	        const fkId = "${sessionScope.loginUser.id}";

	        const form = $("<form>", {
	            method: "post",
	            action: "<%=ctxPath%>/comment/deleteComment"
	        });

	        form.append($("<input>", { type: "hidden", name: "commentNo", value: commentNo }));
	        form.append($("<input>", { type: "hidden", name: "fk_boardNo", value: fkBoardNo }));
	        form.append($("<input>", { type: "hidden", name: "fk_id", value: fkId }));

	        $(document.body).append(form);
	        form.submit();
	    });
		 

		 //댓글 수정
		 $(document).on("click", ".update-comment", function () {
	        const commentDiv = $(this).closest(".comment");
	        const contentDiv = commentDiv.find(".content");
	        const textarea = commentDiv.find(".edit-content");

	        contentDiv.hide();
	        textarea.show().focus();

	        commentDiv.find(".update-comment").hide();
	        commentDiv.find(".delete-comment").hide();
	        commentDiv.find(".save-edit").show();
	        commentDiv.find(".cancel-edit").show();
	    });

	    //  댓글 수정 취소 
	    $(document).on("click", ".cancel-edit", function () {
	        const commentDiv = $(this).closest(".comment");
	        const contentDiv = commentDiv.find(".content");
	        const textarea = commentDiv.find(".edit-content");

	        // textarea 숨기고 원래 내용 보이기
	        textarea.hide();
	        contentDiv.show();

	        commentDiv.find(".update-comment").show();
	        commentDiv.find(".delete-comment").show();
	        commentDiv.find(".save-edit").hide();
	        commentDiv.find(".cancel-edit").hide();
	    });

	    // 댓글 수정 저장 
	    $(document).on("click", ".save-edit", function () {
	        const commentDiv = $(this).closest(".comment");
	        const commentNo = $(this).data("id");
	        const newContent = commentDiv.find(".edit-content").val().trim();

	        if (newContent.length === 0) {
	            alert("댓글 내용을 입력해주세요!");
	            return;
	        }

	        const form = $("<form>", {
	            method: "post",
	            action: "<%=ctxPath%>/comment/updateComment"
	        });

	        form.append($("<input>", { type: "hidden", name: "commentNo", value: commentNo }));
	        form.append($("<input>", { type: "hidden", name: "content", value: newContent }));
	        form.append($("<input>", { type: "hidden", name: "fk_boardNo", value: "${boardDto.boardNo}" }));
	        
	        $(document.body).append(form);
	        form.submit();
	    });
		 
		 
	}); 
	
	
	
	// 글 삭제
	function del() {
		if(!confirm("정말로 삭제하시겠습니까?")) {
			return alert("삭제가 취소되었습니다.");
		}
		const form = document.deleteForm;
		form.method = "post";
		form.action = "<%=ctxPath%>/board/delete";
		form.submit();
	}
	
	
</script>


<div style="display: flex; background-image: url('<%= ctxPath %>/images/background.png');">
  <div class="col-md-3 d-flex flex-column align-items-center justify-content-start" style="">
	<div>
		<img src="<%=ctxPath%>/images/mz.png" alt="프로필" class="mb-3">
             <div class="text-muted small mb-3">${sessionScope.loginUser.email}</div>
             <div class="mb-3">
             	<span style="size:20pt; color:blue;">${sessionScope.loginUser.name} 님 </span>
                 포인트 : <b><fmt:formatNumber value="${sessionScope.loginUser.point}" pattern="#,###"/> point</b>
             </div>
	</div>
	<div style="width: 70%; margin-top:30%; border: solid 1px green;">
		<h6 style="font-weight: bolder;">대사살 Hot! 게시글</h6>
		<table class="table table-sm table-borderless">
			<tbody style="font-size: 10pt;">
				<tr>
					<td style="width: 5%; font-weight: bold;">01</td>
					<td style="width: 95%;">hot 게시글 1등 제목입니다.~~~~~~~<span class="text-right text-danger">(4)</span></td>
				</tr>
				<tr>
					<td style="width: 5%; font-weight: bold;">02</td>
					<td style="width: 95%;">hot 게시글 2등 제목입니다.!!!!!!!!!!!!!!!!!!!!<span class="text-right text-danger">(9)</span></td>
				</tr>
				<tr>
					<td style="width: 5%; font-weight: bold;">03</td>
					<td style="width: 95%;">hot 게시글 3등 제목입니다.#######<span class="text-right text-danger">(9)</span></td>
				</tr>
			</tbody>
		</table>
	</div>
				
	<div class="mt-5" style="width: 70%; border: solid 1px green;">
		<h6 style="font-weight: bolder;">대사살 댓글많은 게시글</h6>
			<table class="table table-sm table-borderless">
				<tbody style="font-size: 10pt;">
					<tr>
						<td style="width: 5%; font-weight: bold;">01</td>
						<td style="width: 95%;">댓글많은 게시글 1등 제목입니다.~~~<span class="text-right text-danger">(100)</span></td>
					</tr>
					<tr>
						<td style="width: 5%; font-weight: bold;">02</td>
						<td style="width: 95%;">댓글많은 게시글 2등 제목입니다.!!!!<span class="text-right text-danger">(55)</span></td>
					</tr>
					<tr>
						<td style="width: 5%; font-weight: bold;">03</td>
						<td style="width: 95%;">댓글많은 게시글 3등 제목입니다.@@@@<span class="text-right text-danger">(55)</span></td>
					</tr>
					<tr>
						<td style="width: 5%; font-weight: bold;">04</td>
						<td style="width: 95%;">댓글많은 게시글 4등 제목입니다.####<span class="text-right text-danger">(55)</span></td>
					</tr>
					<tr>
						<td style="width: 5%; font-weight: bold;">05</td>
						<td style="width: 95%;">댓글많은 게시글 5등 제목입니다.$$$$$<span class="text-right text-danger">(55)</span></td>
					</tr>	
					<tr>
						<td style="width: 5%; font-weight: bold;">06</td>
						<td style="width: 95%;">댓글많은 게시글 6등 제목입니다.~~~<span class="text-right text-danger">(100)</span></td>
					</tr>
				</tbody>
			</table>
		</div>
	</div>
 <div class="col-md-9" style="flex-grow: 1; padding: 20px; background: white; border-radius: 10px; margin-left:20px;">
	<div name="categoryDiv" style="font-size: 20px; font-weight: bold; color: gray">
		<input name="fk_categoryNo" style="display: none;"
				    value="${boardDto.fk_categoryNo}"/>
		<c:if test="${boardDto.fk_categoryNo eq 1}">
			<span>MZ들의&nbsp;</span></c:if>
		<c:if test="${boardDto.fk_categoryNo eq 2}">
			<span>꼰대들의&nbsp;</span></c:if>
		<c:if test="${boardDto.fk_categoryNo eq 3}">
			<span>노예들의&nbsp;</span></c:if>		
		<c:if test="${boardDto.fk_categoryNo eq 4}">
			<span>MyWay들의&nbsp;</span></c:if>
		<c:if test="${boardDto.fk_categoryNo eq 5}">
			<span>금쪽이들의&nbsp;</span></c:if>
		<span>생존 게시판</span>
		<br><br><br>
	</div>
	
	 <!-- 글 제목  -->
    <div class="title" style="display: flex; font-size: 30px; font-weight: bold;">
   		 ${boardDto.boardName} 
    </div><br>
    <!-- 작성자 -->
    <div class="board-meta" style="font-weight: bold;">
        작성자: <span>${boardDto.fk_id}</span></div><br>
     <!-- 날짜 / 조회수 -->
    <div class="board-meta">
        <span>${boardDto.formattedDate}</span> |
        <span>조회수: ${boardDto.readCount}</span>
    </div>
    <!-- 첨부 파일 -->
    <c:if test="${boardDto.boardFileName ne null}">
        <div class="board-file" style="margin: 10% 0 5% 0">
            <img src="<%=ctxPath %>/files/${boardDto.boardFileName}" alt="첨부 이미지">
        </div>
    </c:if>
    <!-- 본문 내용 -->
    <div class="board-content" style="white-space: pre-wrap;"
    	>${boardDto.boardContent}</div>


    <!-- 좋아요 , 공유/신고/북마크 --> 
	<div class="board-actions d-flex justify-content-between align-items-center">
	    <!-- 좋아요 -->
	    <div class="d-flex">
	        <button class="btn btn-sm mr-2" style="border:none; background:none;">
	            <i class="fas fa-thumbs-up"></i>
	        </button>
	    </div>
	    
	    <!-- 오른쪽 공유/신고/북마크 + 글 삭제 -->
	    <div class="d-flex ml-auto">
	        <button class="btn btn-sm mr-2" style="border:none; background:none;">
	            <i class="fas fa-share"></i>
	            <span></span>
	        </button>
	        <button class="btn btn-sm mr-2" style="border:none; background:none;">
	            <i class="fas fa-flag"></i>
	        </button>
	        <a href="<%=ctxPath%>/mypage/bookmarks" class="btn btn-sm" style="border:none; background:none;">
	            <i class="fas fa-bookmark"></i>
	        </a>
	        <form name="deleteForm" method="post" style="display:inline;margin: auto; ">
		        <c:if test="${loginUser.id eq boardDto.fk_id}">
		        	<input name="fk_categoryNo" style="display: none;" value="${boardDto.fk_categoryNo}"/>
		        	<input type="hidden" name="boardNo" value="${boardDto.boardNo}">
	           		<input type="hidden" name="fk_id" value="${boardDto.fk_id}">
		            <button class="btn" onclick="del()" style="background-color: white;"
		              >글 삭제</button>
		        </c:if>
	         </form>
	    </div>
	</div>
	
	<!-- 댓글 영역 -->
    <div class="comment-section">
	  <h3 style="font-weight: bold;">댓글<span>${fn:length(commentList)}</span></h3>
        <c:forEach var="comment" items="${commentList}">
    <div class="comment">
        <div class="meta">
            <span>${comment.fk_id}</span> | 
            	<span class="comment-date">
		    	<c:choose>
		        <c:when test="${not empty comment.updatedAtComment}">
		            ${fn:replace(comment.updatedAtComment, "T", " ")} <span style="color:gray;">(수정됨)</span>
		        </c:when>
		        <c:otherwise>
		            ${fn:replace(comment.createdAtComment, "T", " ")}
		        </c:otherwise>
		    </c:choose>
			</span>
        </div>

        <!-- 댓글 내용 -->
        <div class="content">${comment.content}</div>

        <!-- 수정 입력창 (숨김) -->
        <textarea class="form-control edit-content" style="display:none;">${comment.content}</textarea>

        <!-- 버튼 영역 -->
        <div class="comment-buttons mt-2">
            <c:if test="${not empty loginUser and loginUser.id == comment.fk_id}">
                <button type="button" class="btn update-comment" data-id="${comment.commentNo}">수정</button>
                <button type="button" class="btn delete-comment" data-id="${comment.commentNo}">삭제</button>
                <button type="button" class="btn btn-sm  save-edit" data-id="${comment.commentNo}" style="display:none;">저장</button>
                <button type="button" class="btn btn-sm  cancel-edit" data-id="${comment.commentNo}" style="display:none;">취소</button>
            </c:if>
        </div>
    </div>
</c:forEach>

        <!-- 댓글 작성 -->
        <form name="commentform" action="${ctxPath}/comment/writeComment" method="post" style="margin-top: 15px;">
            <input type="hidden" name="fk_boardNo" value="${boardDto.boardNo}">
            <input type="hidden" name="fk_id" value="${sessionScope.loginUser.id}">
            <textarea name="content" rows="3" style="width:100%;" placeholder="댓글을 입력하세요"></textarea>
            <button type="submit" class="btn" id="addComment">댓글 등록</button>
        </form>
    </div>

    <!-- 목록 버튼 -->
    <div style="margin-top:20px;">
        <a href="<%=ctxPath %>/board/list?category=${boardDto.fk_categoryNo}" class="btn">목록</a>
    </div>

</div>
</div>
</html>
