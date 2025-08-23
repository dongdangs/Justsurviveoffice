<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%
   String ctxPath = request.getContextPath();
%>

<jsp:include page="../header/header1.jsp"></jsp:include>

<script type="text/javascript">
	
	$(function(){
		commentRead();
	});
	
	
	// 댓글 목록 보기
	function commentRead() {
		
		$.ajax({
			url:"<%= ctxPath%>/board/commentRead",
			data:{"boardNo":"${requestScope.boardDto.boardNo}"},
			dataType:"json",
			success:function(json) {
				let v_html = ``;
				
				if(json.length == 0) {
		            v_html = `<div class="text-muted">등록된 댓글이 없습니다.</div>`;
		        }
		        else {
		            json.forEach(function(comment) {
		            	console.log(comment);
		                v_html += `
		                    <div class="d-flex mb-3 border-bottom pb-2">
		                        <div>
		                            <div class="fw-semibold">
		                                ${comment.fk_id}
		                                <small class="text-muted">${comment.createdAtComment}</small>
		                            </div>
		                            <div class="text-muted">${comment.content}</div>
		                            <div class="small text-muted mt-1">
		                                <i class="far fa-thumbs-up"></i> 1
		                            </div>
		                        </div>
		                    </div>`;
		            });
		        }

		        // 만든 HTML을 댓글 영역에 삽입
		        $("#commentRead").html(v_html);
				
			},
			error: function(request, status, error){
            	alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
	        }
		});
		
	}
	
	
	// 댓글 쓰기
	function commentWrite() {
		
		const comment_content = $('textarea#content').val().trim();
		if(comment_content == "") {
			alert("댓글 내용을 입력하세요.");
			return;
		}
		
		const queryString = $('form[name="commentWriteForm"]').serialize();
		console.log(queryString);
		
		$.ajax({
			url:"<%= ctxPath%>/board/commentWrite",
			data:queryString,
			type:"post",
			dataType:"json",
			success:function(json) {
				console.log(JSON.stringify(json));
				
				commentRead();
				$('textarea#content').val("");				
			},
			error: function(request, status, error){
            	alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
	        }
		});
		
	}
	
</script>

<div class="container my-5">

	<c:if test="${not empty requestScope.boardDto}">

  		<!-- 게시글 카드 -->
  		<div class="card border-0 shadow-sm mb-4">
    		<div class="card-body">

	      		<!-- 제목 -->
	      		<h2 class="fw-bold mb-3" style="font-size: 15pt; font-weight: bold;">
	        		${requestScope.boardDto.boardName}
	      		</h2>

	      		<!-- 작성자 정보 -->
      			<div class="d-flex align-items-center mb-3">
	        		<div>
			          	<div class="fw-semibold">
			            	${requestScope.boardDto.fk_id}
			          	</div>
			          	<small class="text-muted">
			            	${requestScope.boardDto.createdAtBoard}&nbsp;&nbsp;조회 ${requestScope.boardDto.readCount}
			          	</small>
        			</div>
    			</div>

		      	<!-- 본문 -->
		      	<p class="lh-lg">
		        	${requestScope.boardDto.boardContent}
		      	</p>

		      	<!-- 액션 버튼 -->
		      	<div class="d-flex align-items-center pt-3 text-muted small">
		        	<div class="me-4"><i class="far fa-thumbs-up"></i> 좋아요&nbsp;&nbsp;</div>
		        	<div class="me-4"><i class="far fa-comment-dots"></i> 댓글</div>
		      	</div>

    		</div>
  		</div>

	</c:if>

	<c:if test="${empty requestScope.boardDto}">
	  	<div class="alert alert-secondary text-center">
	    	데이터가 없습니다.
	  	</div>
	</c:if>

	<!-- 댓글 영역 -->
  	<div class="card border-0 shadow-sm mb-4">
    	<div class="card-body">

      		<!-- 댓글 불러오기 -->
      		<div class="d-flex mb-3">
        		<div id="commentRead"></div>
      		</div>

      		<!-- 댓글 입력창 -->
      		<c:if test="${not empty sessionScope.loginUser}">
	      		<form name="commentWriteForm" id="commentWriteForm">
		      		<div class="d-flex align-items-start mt-4">
		        		<textarea id="content" name="content" class="form-control me-2" rows="2" placeholder="댓글을 입력하세요"></textarea>
		        		<button class="btn btn-primary" onclick="commentWrite()">등록</button>
		      		</div>
	      		</form>
      		</c:if>

    	</div>
  	</div>

  	<!-- 하단 버튼 -->
  	<div class="d-flex justify-content-end">
    	<a href="<%=ctxPath%>/board/boardList" class="btn btn-outline-secondary">목록</a>
  	</div>
  	
</div>

