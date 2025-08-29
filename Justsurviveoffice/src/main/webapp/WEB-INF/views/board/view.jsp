<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%
    String ctxPath = request.getContextPath();
%>
<jsp:include page="../header/header1.jsp" /> 
<html><style>
  .board-container {
    width: 80%;
    margin: 20px auto;
    border-bottom: 1px solid #ddd;
    padding-bottom: 20px;
  }
  .board-header { display:flex; justify-content:space-between; align-items:center; }
  .board-header h2 { margin:0; }
  .board-meta { font-size:0.9em; color:#666; }
  .board-content { margin:15px 0; white-space: pre-wrap; word-break: break-word; }
  .board-file img { max-width:300px; margin-top:10px; }
  .board-actions { margin-top:10px; }
  .comment-section { margin-top:30px; }
  .comment { border-top:1px solid #eee; padding:10px 0; }
  .comment .meta { font-size:0.8em; color:#555; }
  .btn { padding:5px 10px; border:1px solid #ccc; background:#f9f9f9; cursor:pointer; }
  .btn:hover { background:#eee; }

  /* << 핵심: 본문 내 삽입 미디어 크기 제한 >> */
  .board-content img,
  .board-content video,
  .board-content iframe {
    max-width: 100% !important;  /* 컨테이너 너비를 넘지 않도록 */
    height: auto !important;     /* 비율 유지 */
    display: block;
    margin: 0 auto;              /* 가운데 정렬(옵션) */
  }
.comment img,
.comment video,
.comment iframe {
  max-width: 100% !important;
  height: auto !important;
}

</style>

<script type="text/javascript">

	$(function() {
		const nextVals = ${boardDto.nextNo};
		if(nextVals == 0) {
			$('div#nextBtn').hide();
		}
		const preVals = ${boardDto.preNo};
		if(preVals == 0) {
			$('div#prevBtn').hide();
		}
		 // 댓글작성
	    $('button#addComment').click(function(){
	        // === 댓글내용 유효성 검사 === //
	        let contentVal = $('textarea[name="content"]').val().trim();
	        if(contentVal.length == 0) {
	        	alert("댓글내용을 입력해주세요.");
	        	return;
	        }
	        const form = document.commentform;
	        form.method = "post";
	        form.action = "<%= ctxPath%>/comment/writeComment";
	        form.submit();
	    });
		 
			//대댓글 입력
		    $(document).on("click", ".reply-btn", function() {
			 const parentNo = $(this).data("id"); //data-id="${comment.commentNo}"라고 아래에 button 속성 지정해놨음
			 console.log("reply-btn 클릭됨, parentNo=", parentNo); 

		        const form = $('#reply-form-'+parentNo);
		        	$(".reply-form").hide();
		        	form.show();
		            $(`#reply-content-${parentNo}`).focus();
		   });  
			 
			// 대댓글 작성
   			 $(document).on("click", ".add-reply", function() {
		        const parentNo = $(this).data("parent"); //data-parent로 "${comment.commentNo}" 지정해놨음
		        const content = $('#reply-content-'+parentNo).val().trim();  
		        
		        console.log("parentNo 뭔데 : "+parentNo);
		        
			        if(content.length == 0) {
			        	alert("댓글내용을 입력해주세요 !");
			        	return; 
			        }
			        
			        $.ajax({
			            url: "<%= ctxPath%>/comment/writeReply",
			            type: "POST",
			            dataType:"json",
			            data: { 
			            	fk_boardNo: "${boardDto.boardNo}",
			                content: content,
			                parentNo: parentNo
						},
			            success: function(json) {
			            	  
			                if (json.success) {
			                	// 대댓글 리스트에 새로 추가
			                	const reply = json.reply;
			                	const html = `
			                        <div class="reply" id="reply-${reply.commentNo}">
			                            <div class="meta">
		                                <span>${reply.fk_id}</span> |
		                                <span>${reply.fk_name}</span> |
			                                <span>${reply.createdAtComment}</span>
			                            </div>
			                            <div class="content">${reply.content||''}</div>
			                            <button class="btn delete-reply" data-id="${reply.commentNo}">삭제</button>
			                        </div>`;
			                       // $('#replies-' + parentNo).append(html);
									 location.reload(); 
			                       
			                    // 입력창 초기화 및 숨김
			                    $('#reply-content-'+parentNo).val("");
			                    $('#reply-form-'+parentNo).hide();
			                } else {
			                    alert(json.message);
			                }
			            },
			            error: function(request, status, error) {
			                alert("code:" + request.status + "\nmessage:" + request.responseText);
			            }
			        });
			        
			}); // end of $('button#replybtn').click(function(){});
		       
			 // 대댓글 작성 취소버튼
		    $(document).on("click", ".cancel-reply", function() {
		        const parentNo = $(this).data("parent");
		    	
		        $('#reply-content-'+parentNo).val("");
		        $('#reply-form-'+parentNo).hide();
		        
		    });

		    // 대댓글 삭제
		    $(document).on("click", ".delete-reply", function() {
		        if (!confirm("정말 삭제하시겠습니까?")) return;

		        const commentNo = $(this).data("id");

		        $.ajax({
		            url: "<%= ctxPath %>/comment/deleteReply",
		            type: "POST",
		            dataType:"json",
		            data: {commentNo:commentNo,
		            },
		            success: function(json) {
		                if (json.success) {
		                    $('#reply-'+commentNo).remove();
		                } else {
		                    alert(json.message);
		                }
		            },
		            error: function(request, status, error) {
		                alert("code:" + request.status + "\nmessage:" + request.responseText);
		            }
		        });
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
		 
		 

		 $('#download').click(function(){
	        const form = document.downloadForm;
	        form.method = "post";
	        form.action =  "<%= ctxPath%>/board/download";
	        form.submit();
	    });
		 
	}); 
	
	// 글 삭제
	function del() {
		if(!confirm("정말로 삭제하시겠습니까?")) {
			return alert("삭제가 취소되었습니다.");
		}
		const form = document.delnEditForm;
		form.method = "post";
		form.action = "<%=ctxPath%>/board/delete";
		form.submit();
	}
	
	// 글 수정하기 >> restAPI
	function edit() {
		if(!confirm("수정하시겠습니까?")) {
			return alert("취소되었습니다.");
		}
		const form = document.delnEditForm;
		form.method = "get";
		form.action = "<%=ctxPath%>/board/edit";
		form.submit();
	}
	
	// 게시글 좋아요
function boardLike(boardNo, fk_id) {
    const icon = $('#boardLike-icon-'+boardNo);
    const likeCountSpan = $("#likeCount");

    $.ajax({
        url: "<%= ctxPath%>/board/boardlike",
        type: "POST",
        data: { fk_boardNo: boardNo },
        success: function(json) {
            if (!json.success) {
                alert(json.message);
                return;
            }

            // 현재 좋아요 상태 변경
            const isLiked = json.status === "liked";

            // 클래스 완전히 초기화 후 상태 적용
            icon.removeClass("fa-solid fa-regular text-warning");
            if (isLiked) {
                icon.addClass("fa-solid fa-thumbs-up text-warning");
            } else {
                icon.addClass("fa-regular fa-thumbs-up");
            }

            // data-liked 속성 갱신
            icon.attr("data-liked", isLiked);

            // 좋아요 개수 즉시 갱신
            likeCountSpan.text(json.likeCount);
        },
        error: function(request, status, error) {
            alert("code:" + request.status + "\nmessage:" + request.responseText);
        }
    });
}
	function boardLike(boardNo, fk_id) {
	    const icon = $('#boardLike-icon-'+boardNo);
	    const likeCountSpan = $("#likeCount");
	    $.ajax({
	        url: "<%=ctxPath%>/board/boardlike",
	        type: "POST",
	        data: { fk_boardNo: boardNo },
	        success: function(json) {
	            if (json.success) {
	            	// 현재 좋아요 상태 변경
		            const isLiked = json.status === "liked";
		            // 클래스 완전히 초기화 후 상태 적용
		            icon.removeClass("fa-solid fa-regular text-warning");
		            if (isLiked) {
		                icon.addClass("fa-solid fa-thumbs-up text-warning");
		            } 
		            else {
		                icon.addClass("fa-regular fa-thumbs-up");
		            }
		            // data-liked 속성 갱신
		            icon.attr("data-liked", isLiked);
		            // 좋아요 개수 즉시 갱신
		            likeCountSpan.text(json.likeCount);
	            }
	            else {
	            	alert(json.message);
	            	window.location.href = "<%=ctxPath%>/users/loginForm";
	            }
	        },
	        error: function(request, status, error) {
	            alert("code:" + request.status + "\nmessage:" + request.responseText);
	        }
	    });
	}
	
	<!-- 북마크기능 -->
    function bookmark(boardNo, fk_id, isBookmarked) {
	    const url = isBookmarked
			        ? "<%= ctxPath%>/bookmark/remove"
			        : "<%= ctxPath%>/bookmark/add";
	    $.ajax({
	        url: url,
	        type: "POST",
	        data: { fk_boardNo: boardNo },
	        success: function(json) {
	            const icon = $('#bookmark-icon-'+boardNo); // 북마크 아이콘 지정
	            if (json.success) {
	            	icon.removeClass("fa-solid fa-bookmark text-warning fa-regular");
	            	if (isBookmarked) {
	            	    // 해제된 상태로 변경
	            	    icon.addClass("fa-regular fa-bookmark");
	            	    icon.attr("onclick", "bookmark(" + boardNo + ", '" + fk_id + "', false)");
	            		$('input[name="bookmarked"]').value = false;
	            	} else {
	            	    // 추가된 상태로 변경
	            	    icon.addClass("fa-solid fa-bookmark text-warning");
	            	    icon.attr("onclick", "bookmark(" + boardNo + ", '" + fk_id + "', true)");
	            		$('input[name="bookmarked"]').value = true;
	            	}
	            } else {
	                alert(json.message);
	                window.location.href = "<%=ctxPath%>/users/loginForm";
	            }
	        },
	        error: function(request, status, error) {
	            alert("code:" + request.status + "\nmessage:" + request.responseText);
	            alert("뒤로가기 오류입니다.");
	            window.location.href = "<%=ctxPath%>/index";
	            // 일단 임시로 오류시 main으로 전환시키기
	        }
	    });
	 }// end of function Bookmark(boardNo,fk_id)———————————
	
	function goViewA(){
		 const frm = document.goViewFrm;
		 frm.boardNo.value = ${boardDto.preNo};
		 
		 frm.method = "post";
		 frm.action = "<%= ctxPath%>/board/view";
		 frm.submit();
	}

	function goViewB(){
		 const frm = document.goViewFrm;
		 frm.boardNo.value = ${boardDto.nextNo};
		 
		 frm.method = "post";
		 frm.action = "<%= ctxPath%>/board/view";
		 frm.submit();
	}
	
	
</script>
<body style="background-image: url('<%= ctxPath %>/images/background.png'); "></body>
 <div class="col-md-9" style="flex-grow: 1; padding: 20px; background: white; border-radius: 10px; ">
	<div name="categoryDiv" style="font-size: 20px; font-weight: bold; color: gray;">
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
     <!-- 첨부파일 다운 -->
     <c:if test="${boardDto.boardFileOriginName ne null}">
      <div class="d-flex justify-content-end">
        <div class="file-box border rounded d-flex align-items-center" style="font-size: 9pt;">
          <form name="downloadForm">
            <div id="download" class="text-dark" style="cursor:pointer;">${boardDto.boardFileOriginName} 다운로드</div>
          	<input type="hidden" name="boardFileName" value="${boardDto.boardFileName}"/>
          	<input type="hidden" name="boardFileOriginName" value="${boardDto.boardFileOriginName}"/>
          </form>
        </div>
      </div>
<%--  <div style="min-height: 20%; max-width: 100%; overflow: hidden;">
        <img src="<%=ctxPath %>/resources/files/${boardDto.boardFileName}" 
	             class="thumbnail" 
	             style="max-width: 100%; height: auto; display: block; margin: 0 auto;" />
	  </div> --%>
    </c:if>
    
    <!-- 본문 내용 -->
    <div class="board-content" style="white-space: pre-wrap;"
    	>${boardDto.boardContent}</div>

    <!-- 좋아요 , 공유/신고/북마크 --> 
	<div class="board-actions d-flex justify-content-between align-items-center">
	    <!-- 좋아요 -->
	    <div class="d-flex">
	        
	       <!-- 좋아요 아이콘 + 개수 표시 -->
			<form id="boardLikeForm-${boardDto.boardNo}">
			    <input type="hidden" name="fk_boardNo" value="${boardDto.boardNo}">
			    <input type="hidden" name="fk_id" value="${sessionScope.loginUser.id}">
			
			    <i id="boardLike-icon-${boardDto.boardNo}"
				   class="fa-thumbs-up ${boardDto.boardLiked ? 'fa-solid text-warning' : 'fa-regular'}"
				   style="cursor: pointer; font-size: 20px;"
				   data-liked="${boardDto.boardLiked}"
				   onclick="boardLike(${boardDto.boardNo}, '${sessionScope.loginUser.id}')">
				</i>
				<span id="likeCount">${likeCount}</span>
			</form>
	    </div>
	    
	    <!-- 오른쪽 공유/신고/북마크 + 글 삭제 -->
		<div class="d-flex ml-auto" style="align-items:center; gap:12px;">
	        <span class="fa-regular fa-eye" style="font-size: 8pt">&nbsp;${boardDto.readCount}</span>
	        
		    <form id="bookmarkForm-${boardDto.boardNo}">
			    <input type="hidden" name="fk_boardNo" value="${boardDto.boardNo}">
			    <input type="hidden" name="fk_id" value="${sessionScope.loginUser.id}">
			    <i id="bookmark-icon-${boardDto.boardNo}"
			       class="fa-bookmark ${boardDto.bookmarked ? 'fa-solid text-warning' : 'fa-regular'}"
			       style="cursor: pointer;"
			       onclick="bookmark(${boardDto.boardNo}, '${sessionScope.loginUser.id}', ${boardDto.bookmarked ? true : false})">
			    </i>
			</form> 
			
	        <form name="delnEditForm" method="post" style="display:inline;margin: auto; ">
		        <c:if test="${loginUser.id eq boardDto.fk_id}">
		        	<input name="fk_categoryNo" style="display: none;" value="${boardDto.fk_categoryNo}"/>
		        	<input type="hidden" name="boardNo" value="${boardDto.boardNo}">
	           		<input type="hidden" name="fk_id" value="${boardDto.fk_id}">
	           		<input type="hidden" name="bookmarked" value="${boardDto.bookmarked}"/>
		            <button class="btn" onclick="del()" style="background-color: white;"
		              >글 삭제</button>
		            <button class="btn" onclick="edit()" style="background-color: white;"
		              >수정하기</button>
		        </c:if>
	         </form>
	    </div>
	</div>
	
	<!-- ======== 댓글 목록 ======== -->
<!-- ======== 댓글 목록 ======== -->
<div class="comment-section">
    <h3 style="font-weight: bold;">댓글 <span>${fn:length(commentList)}</span></h3>
    <c:forEach var="comment" items="${commentList}">
        <div class="comment" id="comment-${comment.commentNo}">
            <div class="meta">
                <span>${comment.fk_id}</span> |
                <span>${fn:replace(comment.createdAtComment, "T", " ")}</span>
            </div>
            <div class="content">${comment.content}</div>

            <!-- 버튼 영역 -->
            <div class="actions">
                <c:if test="${not empty loginUser}">
                    <button class="btn reply-btn" data-id="${comment.commentNo}">답글</button>
                </c:if>
                <c:if test="${loginUser.id == comment.fk_id}">
                    <button type="button" class="btn update-comment" data-id="${comment.commentNo}">수정</button>
                    <button type="button" class="btn delete-comment" data-id="${comment.commentNo}">삭제</button>
                    <button type="button" class="btn btn-sm save-edit" data-id="${comment.commentNo}" style="display:none;">저장</button>
                    <button type="button" class="btn btn-sm cancel-edit" data-id="${comment.commentNo}" style="display:none;">취소</button>
                </c:if>
            </div>

            <!-- 수정 textarea -->
            <textarea class="form-control edit-content" style="display:none;">${comment.content}</textarea>

            <!-- 대댓글 입력폼 + 리스트 -->
            <div class="reply-form" id="reply-form-${comment.commentNo}" style="display:none; margin-top:5px;">
                <textarea id="reply-content-${comment.commentNo}" rows="2" style="width:80%;" placeholder="대댓글을 입력하세요"></textarea>
                <button type="button" class="btn add-reply" data-parent="${comment.commentNo}">등록</button>
                <button type="button" class="btn cancel-reply" data-parent="${comment.commentNo}">취소</button>
            </div>
            <div class="replies" id="replies-${comment.commentNo}" style="margin-left:20px; margin-top:10px;">
                <c:forEach var="reply" items="${comment.replyList}">
                    <div class="reply" id="reply-${reply.commentNo}">
                        <div class="meta">
                            <span>${reply.fk_id}</span> |
                            <span>${fn:replace(reply.createdAtComment, "T", " ")}</span>
                        </div>
                        <div class="content">${reply.content}</div>
                        <c:if test="${loginUser.id == reply.fk_id}">
                            <button class="btn delete-reply" data-id="${reply.commentNo}" data-parent="${comment.commentNo}">삭제</button>
                        </c:if>
                    </div>
                </c:forEach>
            </div>
        </div>
    </c:forEach>

    <!-- 댓글 작성 -->
    <form name="commentform" action="${ctxPath}/comment/writeComment" method="post" style="margin-top: 15px;">
        <input type="hidden" name="fk_boardNo" value="${boardDto.boardNo}">
        <input type="hidden" name="fk_id" value="${sessionScope.loginUser.id}">
        <textarea name="content" rows="3" style="width:100%;" placeholder="댓글을 입력하세요"></textarea>
        <button type="button" class="btn" id="addComment">댓글 등록</button>
    </form>
</div>

 
       
    <!-- 목록 버튼, 이전글 다음글 -->
    <div style="display:flex; margin-top:3px;"> 
    <div class="mr-3">
        <a href="<%=ctxPath %>/board/list/${boardDto.fk_categoryNo}" class="btn">목록</a>
    </div>
    <div class="Boardpagination mt-1">
		<div id="nextBtn" class="" onclick="goViewB('${boardDto.nextNo}')" style="cursor:pointer;">
	  	 다음글: ${fn:substring(boardDto.nextName, 0, 20)}</div>
		<div id="prevBtn" class="" onclick="goViewA('${boardDto.preNo}')" style="cursor:pointer;">
	 	 이전글: ${fn:substring(boardDto.preName, 0, 20)}</div>
	</div>
	<form name="goViewFrm">
   	 	<input type="hidden" name="boardNo" />
		<input type="hidden" name="boardWritt" />
	</form>
	<input type="hidden" id="preNo" name="preNo"  value="${boardDto.preNo}" />
	<input type="hidden" id="NextNo" name="nextNo" value="${boardDto.nextNo}" />
	</div>
</div>

</html>
