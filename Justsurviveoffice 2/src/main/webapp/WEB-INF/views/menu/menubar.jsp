<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% String ctxPath = request.getContextPath(); %>
<html>
<script type="text/javascript">
$(function() {
	$('')
	
	
});

</script>

<div class="col-md-3 d-flex flex-column align-items-center justify-content-start" ">
            <c:if test="${not empty sessionScope.loginUser}">   
               <div>
                  <img src="<%=ctxPath%>/images/mz.png" alt="프로필" class="mb-3">
                   <div class="text-muted small mb-3 ml-3">${sessionScope.loginUser.email}</div>
                   <div class="mb-3 ml-3">
                      <span style="size:20pt; color:blue;">${sessionScope.loginUser.name} 님 </span>
                      <div>포인트 : <b><fmt:formatNumber value="${sessionScope.loginUser.point}" pattern="#,###"/> point</b></div>
                   </div>
               </div>
            </c:if>   
               <div style="width: 70%; margin-top:30%; border: solid 1px green;">
                <div class="d-flex justify-content-between align-items-center mb-2">
                    <h6 style="font-weight: bolder; margin: 0;">대사살 <span style="color: red;">Hot!</span> 게시글</h6>
                </div>
                <table class="table table-sm table-borderless">
                    <tbody style="font-size: 10pt;">
                        <c:forEach var="hotRead" items="${hotReadList}">
                            <tr>
                                <td style="width: 5%; font-weight: bold;">
                                    ${hotRead.rank}
                                </td>
                                <td style="width: 95%;">
                                 <form name="">
                                	<a href="<%= ctxPath%>/board/view?categoryNo=${hotRead.fk_categoryNo}&boardNo=${hotRead.boardNo}"
                                       style="color: #000;">
                                        ${hotRead.boardName}</a>
                                    <input type="hidden" name="categoryNo" value="${hotRead.fk_categoryNo}"/>
                                    <input type="hidden" name="boardNo" value="${hotRead.boardNo}"/>
                                    <span class="fa-regular fa-eye text-muted" style="font-size: 8pt;">(${hotRead.readCount})</span>
                                 </form>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
            <div style="width: 70%; margin-top:30%; border: solid 1px green;">
                <div class="d-flex justify-content-between align-items-center mb-2">
                    <h6 style="font-weight: bolder; margin: 0;">대사살 댓글많은 게시글</h6>
                </div>
                <table class="table table-sm table-borderless">
                    <tbody style="font-size: 10pt;">
                        <c:forEach var="hotComment" items="${hotCommentList}">
                            <tr>
                                <td style="width: 5%; font-weight: bold;">
                                    ${hotComment.rank}
                                </td>
                                <td style="width: 95%;">
                                    <a href="<%= ctxPath%>/board/view?categoryNo=${hotComment.fk_categoryNo}&boardNo=${hotComment.boardNo}"
                                       style="color: #000;">
                                        ${hotComment.boardName}
                                    </a>
                                    <span class="fa-regular fa-comment text-muted" style="font-size: 8pt;">(${hotComment.commentCount})</span>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
           </div>
</html>