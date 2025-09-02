<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
    
<%
    String ctxPath = request.getContextPath();
    //     /myspring
%>    
    
<!DOCTYPE html>
<html>

<head>
   <%-- Required meta tags --%>
   <meta charset="UTF-8">
   <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
   <title>대사살 (대충사무실에서살아남기)</title>

    <%-- Bootstrap CSS --%>
    <link rel="stylesheet" href="<%= ctxPath%>/bootstrap-4.6.2-dist/css/bootstrap.min.css" type="text/css">

    <%-- Font Awesome 6 Icons --%>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
  
    <%-- 직접 만든 CSS 1 --%>
    <link rel="stylesheet" type="text/css" href="<%=ctxPath%>/css/style1.css" />
    <link rel="stylesheet" type="text/css" href="<%=ctxPath%>/css/common.css" />
    
    <%-- Optional JavaScript --%>
    <script type="text/javascript" src="<%=ctxPath%>/js/jquery-3.7.1.min.js"></script>
    <script type="text/javascript" src="<%=ctxPath%>/bootstrap-4.6.2-dist/js/bootstrap.bundle.min.js" ></script>

   <%-- 스피너 및 datepicker 를 사용하기 위해 jQueryUI CSS 및 JS --%>
   
<style type="text/css">
.category-img {
    width: 100%;
    min-width: 30%; /* 최대 크기 지정, 필요시 조정 */
    height: auto;
    border-radius: 10px; /* 둥글게, 옵션 */
    object-fit: cover;   /* 비율 유지, 잘림 없이 */
    display: block;
}
@media (max-width: 600px) {
    .category-img {
        max-width: 80px;
    }
}

</style>
</head>

   <div id="mycontainer">
      <div id="myheader">
         <jsp:include page="../menu/menu1.jsp" />
      </div>
      
      <div id="mycontent" class="mt-5">
         <div class="row" style="margin:0 auto;"> 
            <div class="col-md-3 d-flex flex-column align-items-center justify-content-start" ">
            <c:if test="${not empty sessionScope.loginUser}">   
               <div>
               <c:if test="${sessionScope.loginUser.getCategory().getCategoryImagePath() eq null}">
               		<img src="<%=ctxPath%>/images/unassigned.png" alt="프로필" 
               			 class="category-img mb-3">
               </c:if>
               	<c:if test="${sessionScope.loginUser.getCategory().getCategoryImagePath() ne null}">
               		<img src="<%=ctxPath%>/images/${sessionScope.loginUser.getCategory().getCategoryImagePath()}" alt="프로필" 
               			 class="category-img mb-3">
               	</c:if>
                   <div class="text-muted small mb-3 ml-3">${sessionScope.loginUser.email}</div>
                   <div class="mb-3 ml-3">
                      <div style="size:20pt; color:blue;">${sessionScope.loginUser.name} 님 </div>
                      <div>포인트 : <b><fmt:formatNumber value="${sessionScope.loginUser.point}" pattern="#,###"/> point</b></div>
                   </div>
               </div>
            </c:if>   
              <div class="LBoardRank" style="width:80%;">
                <div class="d-flex justify-content-between align-items-center mb-2">
                    <h6 style="font-weight: bolder; margin: 0;">대사살 <span style="color: red;">Hot!</span> 게시글</h6>
                </div>
                <table class="table table-sm table-borderless">
                    <tbody style="font-size: 10pt;">
                        <c:forEach var="hotRead" items="${hotReadList}">
                            <form id="viewForm${hotRead.boardNo}" 
		                           action="<%= ctxPath %>/board/view" 
		                           method="get" 
		                           style="display:none;">
                         <input type="hidden" name="category" value="${hotRead.fk_categoryNo}">
                         <input type="hidden" name="boardNo" value="${hotRead.boardNo}">
                     </form>
                     <tr>
                         <td style="width: 5%; font-weight: bold;">
                             ${hotRead.rank}.
                         </td>
                         <td style="width: 95%;">
                             <a href="javascript:void(0);" 
                                onclick="document.getElementById('viewForm${hotRead.boardNo}').submit();" 
                                style="color: #000;">
                                 ${hotRead.boardName}
                             </a>
                             <span class="fa-regular fa-eye text-muted" style="font-size: 8pt; color:#fff !important">
                                 (${hotRead.readCount})
                             </span>
                         </td>
                     </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
            <div class="LBoardRank" style="width: 80%;">
                <div class="d-flex justify-content-between align-items-center mb-2">
                    <h6 style="font-weight: bolder; margin: 0;">대사살 <span style="color:blue;">시끌벅적!</span> 게시글</h6>
                </div>
                <table class="table table-sm table-borderless">
                    <tbody style="font-size: 10pt;">
                        <c:forEach var="hotComment" items="${hotCommentList}">
                           <form id="viewForm${hotComment.boardNo}" 
		                           action="<%= ctxPath %>/board/view" 
		                           method="get" 
		                           style="display:none;">
                         <input type="hidden" name="category" value="${hotComment.fk_categoryNo}">
                         <input type="hidden" name="boardNo" value="${hotComment.boardNo}">
                     </form>
                     
                     <tr>
                         <td style="width: 5%; font-weight: bold;">
                             ${hotComment.rank}.
                         </td>
                         <td style="width: 95%;">
                             <a href="javascript:void(0);" 
                                onclick="document.getElementById('viewForm${hotComment.boardNo}').submit();" 
                                style="color: #000;">
                                 ${hotComment.boardName}
                             </a>
                         </td>
                     </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
            
            </div>
         
         