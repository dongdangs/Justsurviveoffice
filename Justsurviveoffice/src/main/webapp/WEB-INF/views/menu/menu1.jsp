<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<<<<<<< HEAD

<%-- ===== header 페이지 만들기 ===== --%>
<%
	String ctxPath = request.getContextPath();
    //     /myspring
%>    

    <%-- 상단 네비게이션 시작 --%>
	<nav class="navbar navbar-expand-lg navbar-light bg-light fixed-top py-3 navbarTop">
		<!-- Brand/logo --> 
		<a class="navbar-brand" href="<%=ctxPath%>/index" style="margin-right: 5%;"><img src="<%=ctxPath%>/images/sist_logo.png" /></a>
		
		<!-- 아코디언 같은 Navigation Bar 만들기 -->
	    <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#collapsibleNavbar">
	      <span class="navbar-toggler-icon"></span>
	    </button>
		
		<div class="collapse navbar-collapse" id="collapsibleNavbar">
		  <ul class="navbar-nav h6"> <%-- .h6 는 글자크기임 --%>  
		     <%--<li class="nav-item dropdown">
		        <a class="nav-link text-info" href="#" id="navbarDropdown" data-toggle="dropdown">Home</a> 
		     </li>		     
		     <li class="nav-item dropdown">
		        <a class="nav-link  text-info" href="#" id="navbarDropdown" data-toggle="dropdown">게시판</a>  
		     </li>	  --%> 
		     <li>
				<div class="input-group">
					<form name="searchFrm" id="searchFrm" onsubmit="return SearchItems();" style="display:flex;">
						<input type="text" name="searchID" id="searchID" placeholder="검색어를 입력하세요" />
						<i class="fas fa-search"></i>
						<button type="submit" class="btnSubmit"></button>
					</form>
				</div>
			</li>
			<c:if test="${empty sessionScope.loginUser}">
				<li class="logins">로그인</li>
			</c:if>		
			<c:if test="${not empty sessionScope.loginUser && sessionScope.loginUser.id == 'admin'}">
				<%-- header아이디에 따라 관리자 창 보이는곳 수정시작 --%>
				<%-- <jsp:include page="headerAdmin.jsp" />--%>
				<%-- header아이디에 따라 관리자 창 보이는곳 수정 끝 --%>
			</c:if>
			<c:if test="${not empty sessionScope.loginUser && sessionScope.loginUser.id != 'admin'}">
				<%-- header아이디에 따라 관리자 창 보이는곳 수정시작 --%>
				<li class="carts"><a href="<%= ctxPath%>/item/cartList.do"><img src="/SemiProject/images/header/cart.png" ></a></li>						
				<li class="logins" id="loginUser"style="font-size:19pt;cursor:pointer;"><i class="fas fa-user-circle mr-2"></i></li>
				<li class="userFunc" style="font-size:19pt;cursor:pointer;"><i class="fa-solid fa-bars"></i></li>
				<%-- header아이디에 따라 관리자 창 보이는곳 수정 끝 --%>	 	
			 </c:if>
     	 </ul>
       </div>
	  <%-- === 로그인이 성공되어지면 로그인되어진 사용자의 이메일 주소를 출력하기 === --%>
	   <c:if test="${not empty sessionScope.loginuser}">
		  <div style="float: right; font-size: 9pt;">
			 <span style="color: navy; font-weight: bold;">${sessionScope.loginuser.email}</span> 님<br>로그인중.. 
		  </div>
	   </c:if>
	  
	</nav>
	<%-- 상단 네비게이션 끝 --%>	       
    
<style>
  .navBookmk {background-image:url("<%= ctxPath%>/images/bookmark.png"); background-size:contain;background-repeat:no-repeat;background-position:center;}
</style>

<script>
  const menuToggle = document.getElementById('menuToggle');
  const mainNav = document.getElementById('mainNav');

  menuToggle.addEventListener('click', () => {
    const isShown = mainNav.classList.toggle('show');
    menuToggle.setAttribute('aria-expanded', isShown);
  });
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
        <li><a href="<%=ctxPath%>/login/loginForm">로그인</a></li>
      </c:if>
      <c:if test="${not empty sessionScope.loginUser && sessionScope.loginUser.id == 'admin'}">
        <li><a href="<%=ctxPath%>/admin">관리자 페이지</a></li>
        <li><a href="<%=ctxPath%>/login/logout">로그아웃</a></li>
      </c:if>
      <c:if test="${not empty sessionScope.loginUser && sessionScope.loginUser.id != 'admin'}">
        <li><a href="<%=ctxPath%>/mypage/info">내정보보기</a></li>
        <li><a href="<%=ctxPath%>/login/logout">로그아웃</a></li>
        <li><a class="navBookmk" href="<%=ctxPath%>/mypage/bookmarks"" id="bookmarks">북마크</a></li>
      </c:if>
      <c:if test="${not empty sessionScope.loginUser}">
        	<p style="background: #fff;padding: 4px 13px;border-radius: 13px;">${sessionScope.loginUser.name}</p>
      </c:if>
      
    </ul>
  </nav>
</header>
>>>>>>> branch 'main' of https://github.com/dongdangs/Justsurviveoffice.git
