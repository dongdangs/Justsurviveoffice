<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
    String ctxPath = request.getContextPath();
	// /justsurviveoffice
%>

<style>
 
.navBookmk {
    display: inline-block; /* 또는 block */
    width: 20px;  /* 이미지 크기에 맞게 조정 */
    height: 20px; /* 이미지 크기에 맞게 조정 */
    background-image: url("<%= ctxPath%>/images/bookmark.png");
    background-size: contain;
    background-repeat: no-repeat;
    background-position: center;
}
</style>

<script>
  /* const menuToggle = document.getElementById('menuToggle');
  const mainNav = document.getElementById('mainNav');

  menuToggle.addEventListener('click', () => {
    const isShown = mainNav.classList.toggle('show');
    menuToggle.setAttribute('aria-expanded', isShown);
  }); */
  
  // === 전체 글목록 검색하기 요청 === //
  function searchBoardAll() {
	   const form = document.searchAllForm;
	   alert(form.action)
	   <%-- 
	   form.method = "get";
	   form.action = "<%=originPath%>/board/list?searchType=boardName_boardContent&searchWord="
			   		 + $('#searchWord').val; --%>
	   form.submit();
  }
</script>

<header style="opacity: 0.7; display: flex;">
  <h1><a href="<%=ctxPath%>/index" style="color: white;text-decoration: none;background-image: url(/justsurviveoffice/images/logo2.png);width: 173px;height: 50px;display: block;background-size: cover;background-repeat: no-repeat;background-position: center;"></a></h1>

  <button id="menuToggle" aria-label="메뉴 토글" aria-expanded="false">&#9776;</button>

  <nav id="mainNav" class="hidden">
    <ul class="mainUl">
      <li><a href="<%=ctxPath%>/menu1">전체게시판</a></li>
      <li>
	<%-- 	 <div class="input-group">
			<form name="searchAllForm" id="searchAllForm" method="get" action="<%=ctxPath%>/board/list" style="display:flex;">
			    <input name="searchType" type="hidden" value="boardName_boardContent"/>
			    <input type="text" name="searchWord" id="searchWord" placeholder="검색어를 입력하세요" />
			    <i class="btn fas fa-search" onclick="document.searchAllForm.submit()" id="searchIco"></i>
			</form>
		 </div> --%>
	  </li>
      <c:if test="${empty sessionScope.loginUser}">
        <li><a href="<%=ctxPath%>/users/loginForm">로그인</a></li>
      </c:if>
      <c:if test="${not empty sessionScope.loginUser && sessionScope.loginUser.id == 'admin'}">
        <p style="background: #fff;padding: 4px 13px;border-radius: 13px;">${sessionScope.loginUser.name} 님</p>
        <li><a href="<%=ctxPath%>/admin/usersList">관리자 페이지</a></li>
        <li><a href="<%=ctxPath%>/users/logout">로그아웃</a></li>
      </c:if>
      <c:if test="${not empty sessionScope.loginUser && sessionScope.loginUser.id != 'admin'}">
        <li><a href="<%=ctxPath%>/mypage/info">내정보보기</a></li>
        <li><p style="background: #fff;padding: 4px 13px;border-radius: 13px;">${sessionScope.loginUser.id}</p></li>
		<li><a class="navBookmk" href="<%=ctxPath%>/mypage/bookmarks"" id="bookmarks"></a></li>
		<li><a href="<%=ctxPath%>/users/logout">로그아웃</a></li>     
      </c:if>
      
    </ul>
  </nav>
</header>