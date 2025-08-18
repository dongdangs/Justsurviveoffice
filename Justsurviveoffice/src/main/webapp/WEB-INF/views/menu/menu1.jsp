<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
    String ctxPath = request.getContextPath();
%>

<style>
  .navBookmk {background-image:url("<%= ctxPath%>/images/bookmark.png"); background-size:contain;background-repeat:no-repeat;background-position:center;}
</style>

<script>
  /* const menuToggle = document.getElementById('menuToggle');
  const mainNav = document.getElementById('mainNav');

  menuToggle.addEventListener('click', () => {
    const isShown = mainNav.classList.toggle('show');
    menuToggle.setAttribute('aria-expanded', isShown);
  }); */
</script>

<header>
  <h1><a href="<%=ctxPath%>/index" style="color: white; text-decoration:none;">사이트명</a></h1>

  <button id="menuToggle" aria-label="메뉴 토글" aria-expanded="false">&#9776;</button>

  <nav id="mainNav" class="hidden">
    <ul class="mainUl">
      <li><a href="<%=ctxPath%>/menu1">게시판 1</a></li>
      <li>
		 <div class="input-group">
			<form name="searchFrm" id="searchFrm" onsubmit="return SearchBoard();" style="display:flex;">
				<input type="text" name="searchID" id="searchID" placeholder="검색어를 입력하세요" />
				<i class="fas fa-search" id="searchIco"></i>
					<button type="submit" class="btnSubmit"></button>
				</form>
		 </div>
	  </li>
      <c:if test="${empty sessionScope.loginUser}">
        <li><a href="<%=ctxPath%>/users/loginForm">로그인</a></li>
      </c:if>
      <c:if test="${not empty sessionScope.loginUser && sessionScope.loginUser.id == 'admin'}">
        <li><a href="<%=ctxPath%>/admin/usersList">관리자 페이지</a></li>
        <li><a href="<%=ctxPath%>/users/logout">로그아웃</a></li>
      </c:if>
      <c:if test="${not empty sessionScope.loginUser && sessionScope.loginUser.id != 'admin'}">
        <li><a href="<%=ctxPath%>/mypage/info">내정보보기</a></li>
        <li><a href="<%=ctxPath%>/users/logout">로그아웃</a></li>
        <li><a class="navBookmk" href="<%=ctxPath%>/mypage/bookmarks"" id="bookmarks">북마크</a></li>
      </c:if>
      <c:if test="${not empty sessionScope.loginUser}">
        	<p style="background: #fff;padding: 4px 13px;border-radius: 13px;">${sessionScope.loginUser.name}</p>
      </c:if>
      
    </ul>
  </nav>
</header>