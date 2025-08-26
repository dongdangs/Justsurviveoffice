<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% String ctxPath = request.getContextPath(); %>
<html>
<meta charset="UTF-8">
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
</html>