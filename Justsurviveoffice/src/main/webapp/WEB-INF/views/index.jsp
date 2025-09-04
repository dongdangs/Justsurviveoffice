<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
    String ctxPath = request.getContextPath();
    //     /justsurviveoffice
%>

<jsp:include page="header/header1.jsp" />

<style>
.col-md-9 {
    border-radius: 10pt;
    background-size: cover;       /* 화면 전체에 꽉 차게 */
    background-position: center;  /* 중앙 기준으로 배치 */
    background-repeat: no-repeat; /* 이미지 반복 안 함 */
    background-attachment: fixed;       /* 스크롤 시 고정 */
    background-blend-mode: overlay;     /* 색상 오버레이 효과 동일 */
}

.card {
    display: flex;
    flex-direction: column;
    justify-content: flex-start;  /* 상단부터 정렬 */
    height: 400px;                /* 카드 전체 높이 고정 */
    border-radius: 15px;
    overflow: hidden;
    background-color: #3C396B;
    padding: 9px;
}

.card-img-top {
    width: 100%;
    height: 220px;                /* 이미지 고정 높이 */
    object-fit: cover;
    border-radius: 10px;
    margin-bottom: 4px;           /* 이미지와 텍스트 간격 최소화 */
}

.card-body {
    display: flex;
    flex-direction: column;
    justify-content: flex-start;  /* 텍스트를 위로 정렬 */
    flex-grow: 1;
    padding: 0;
}

.card-title {
    font-weight: bold;
    color: #39FF14;
    margin-bottom: 5px;          /* 제목 아래 간격 최소화 */
    font-size: 1.3rem;
    margin : 2px;
}

.card-text {
    color: white;
    font-size: 0.9rem;
    margin: 2px 0;               /* 태그·설명 간격 최소화 */
    line-height: 1.3;
    overflow: hidden;
/* 카드 기본 스타일 */
.card {
    background-color: #3C396B;
    border-radius: 15px;
    transition: transform 0.3s ease-in-out, box-shadow 0.3s ease-in-out;
    overflow: hidden;
}

/* 이미지 반응형 */
.card img {
    width: 80%;
	min-height: 200px;
    object-fit: cover;
    border-radius: 10px;
}

/* 카드 hover 효과 */
.card:hover {
    box-shadow: 0 10px 20px rgba(0, 0, 0, 0.3);
    animation: shake 0.4s ease-in-out;
}

/* 흔들림 애니메이션 */
@keyframes shake {
    0% { transform: translateX(0); }
    25% { transform: translateX(-5px) rotate(-1deg); }
    50% { transform: translateX(5px) rotate(1deg); }
    75% { transform: translateX(-3px) rotate(-1deg); }
    100% { transform: translateX(0); }
}

/* 카드 제목 */
.card-title {
    font-weight: bold;
    color: #39FF14;
}

/* 카드 설명 텍스트 */
.card-text {
    color: white;
    margin-bottom: 0.5rem;
}

/* 반응형 대응 */
@media (max-width: 992px) { /* 태블릿 이하 */
    .card img {
        max-height: 180px;
    }
}

@media (max-width: 768px) { /* 모바일 */
    .card img {
        max-height: 150px;
    }
    .card-title {
        font-size: 1.1rem;
    }
    .card-text {
        font-size: 0.9rem;
    }
}

@media (max-width: 480px) { /* 초소형 모바일 */
    .card {
        border-radius: 10px;
    }
    .card img {
        max-height: 120px;
    }
    .card-title {
        font-size: 1rem;
    }
    .card-text {
        font-size: 0.8rem;
    }
}

</style>
	

<div class="col-md-9" style="background-image: url('<%= ctxPath %>/images/background.png');display:flex;justify-content:center; border-radius: 10px;background-position:center;background-size:cover;">
				
				<div class="row" style="width: 90%; margin: 4%; max-width:1000px;">
				<!-- 테스트 카드 (고정) --> 
				    <div class="col-sm-6 col-md-6 col-lg-4 mb-4">
						<a href="<%= ctxPath%>/categoryTest/survey" class="card text-decoration-none" style="background-color: #3C396B; border-radius: 15px">
							<div style="margin: 5% 5%; height:60%;">
								<img src="<%= ctxPath%>/images/unassigned.png" class="card-img-top" alt="테스트">
							</div>
							<div class="card-body" style="text-align: center; margin-top: 5%;">
								<h4 class="card-title" style="padding:15px;">테스트</h4>
								<p class="card-text">당신의 성향을 알아보세요!</p>
							</div>
						</a>
					</div>
					<%-- begin과 end로 1번부터 5번 카테고리 1 증감식으로 수정함 0825 --%>
					<c:forEach var="indexList" items="${IndexList}" begin="0" end="4" step="1">
					  <div class="col-sm-6 col-md-6 col-lg-4 mb-4">
						<a href="<%= ctxPath%>/board/list/${indexList.categoryNo}" class="card text-decoration-none" style="background-color: #3C396B; border-radius: 15px">
						  	<div style= "margin: 5% 5%;height: 60%;">
						  		<img src="${pageContext.request.contextPath}/images/${indexList.categoryImagePath}" alt="${indexList.categoryDTO.categoryName}" 
						  					   class="card-img-top">
						  	</div>
						  	<div class="card-body">
						      <h4 class="card-title" style="font-weight: bold; color: #39FF14;">${indexList.categoryName}</h4>
   						      <p class="card-text" style="color: white;"> ${indexList.tags}</p>
						      <p class="card-text" style="color: white;margin-bottom:10px;">설명: ${indexList.categoryDescribe}</p>
						    </div>
						 </a>
					  </div>
				</c:forEach>
			</div>
		</div>
	</div>
</body>
</html> 