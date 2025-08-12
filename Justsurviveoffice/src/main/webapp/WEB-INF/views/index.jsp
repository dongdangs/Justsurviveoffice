<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
    String ctxPath = request.getContextPath();
    //     /justsurviveoffice
%>

<jsp:include page="header/header1.jsp" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>메인 페이지 임시 작업 공간</title>

<!-- Bootstrap CSS -->
<link rel="stylesheet" href="<%= ctxPath%>/bootstrap-4.6.2-dist/css/bootstrap.min.css" type="text/css">

<%-- Font Awesome 6 Icons --%>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">

<%-- Optional JavaScript --%>
<script type="text/javascript" src="<%=ctxPath%>/js/jquery-3.7.1.min.js"></script>
<script type="text/javascript" src="<%=ctxPath%>/bootstrap-4.6.2-dist/js/bootstrap.bundle.min.js" ></script>
<script type="text/javascript" src="<%=ctxPath%>/smarteditor/js/HuskyEZCreator.js" charset="utf-8"></script>

<%-- 스피너 및 datepicker 를 사용하기 위해 jQueryUI CSS 및 JS --%>
<link rel="stylesheet" type="text/css" href="<%=ctxPath%>/jquery-ui-1.13.1.custom/jquery-ui.min.css" />
<script type="text/javascript" src="<%=ctxPath%>/jquery-ui-1.13.1.custom/jquery-ui.min.js"></script>

</head>
<body>
	
	<div class="mainContainer mt-4">
		<div class="row">
			
			<div class="col-md-3 d-flex flex-column align-items-center justify-content-start" style="border:solid 2px red;">
				
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
							<tr>
								<td style="width: 5%; font-weight: bold;">04</td>
								<td style="width: 95%;">hot 게시글 4등 제목입니다.<span class="text-right text-danger">(9)</span></td>
							</tr>
							<tr>
								<td style="width: 5%; font-weight: bold;">05</td>
								<td style="width: 95%;">hot 게시글 5등 제목입니다.<span class="text-right text-danger">(9)</span></td>
							</tr>
							<tr>
								<td style="width: 5%; font-weight: bold;">06</td>
								<td style="width: 95%;">hot 게시글 6등 제목입니다.~~~~~~~<span class="text-right text-danger">(4)</span></td>
							</tr>
							<tr>
								<td style="width: 5%; font-weight: bold;">07</td>
								<td style="width: 95%;">hot 게시글 7등 제목입니다.!!!!!!!!!!!!!!!!!!!!<span class="text-right text-danger">(9)</span></td>
							</tr>
							<tr>
								<td style="width: 5%; font-weight: bold;">08</td>
								<td style="width: 95%;">hot 게시글 8등 제목입니다.#######<span class="text-right text-danger">(9)</span></td>
							</tr>
							<tr>
								<td style="width: 5%; font-weight: bold;">09</td>
								<td style="width: 95%;">hot 게시글 9등 제목입니다.<span class="text-right text-danger">(9)</span></td>
							</tr>
							<tr>
								<td style="width: 5%; font-weight: bold;">10</td>
								<td style="width: 95%;">hot 게시글 10등 제목입니다.<span class="text-right text-danger">(9)</span></td>
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
							<tr>
								<td style="width: 5%; font-weight: bold;">07</td>
								<td style="width: 95%;">댓글많은 게시글 7등 제목입니다.!!!!<span class="text-right text-danger">(55)</span></td>
							</tr>
							<tr>
								<td style="width: 5%; font-weight: bold;">08</td>
								<td style="width: 95%;">댓글많은 게시글 8등 제목입니다.@@@@<span class="text-right text-danger">(55)</span></td>
							</tr>
							<tr>
								<td style="width: 5%; font-weight: bold;">09</td>
								<td style="width: 95%;">댓글많은 게시글 9등 제목입니다.####<span class="text-right text-danger">(55)</span></td>
							</tr>
							<tr>
								<td style="width: 5%; font-weight: bold;">10</td>
								<td style="width: 95%;">댓글많은 게시글 10등 제목입니다.$$$$$<span class="text-right text-danger">(55)</span></td>
							</tr>
						</tbody>
					</table>
				</div>
				
			</div>
			
			<div class="col-md-9" style="background-image: url('<%= ctxPath %>/images/background.png'); border: solid 2px blue;">
				
				<div class="row" style="width: 80%; margin: 5%">
				<!-- 테스트 카드 (고정) -->
				<div class="col-md-4 mt-4">
					<a href="<%= ctxPath%>/rdg7203Work/survey" class="card text-decoration-none h-75" style="height: 80%;">
						<div style="margin: auto 5%; border: solid 1px green;">
							<img src="<%= ctxPath%>/images/mz.png" class="card-img-top" alt="테스트">
						</div>
						<!-- <div class="card-body">
							<h5 class="card-title">테스트</h5>
							<p class="card-text">당신의 성향을 알아보세요!</p>
						</div> -->
					</a>
				</div>
				
				<!-- DB 카드 반복 -->
				<div class="col-md-4 mb-4">
					<a href="#" class="card text-decoration-none h-100" style="background-color: navy;">
						<div style="margin: 5% 5%; border: solid 1px red; height: 60%;">
							<img src="<%= ctxPath%>/images/adult.png" class="card-img-top" style="width:100%; height:100%; object-fit:cover;" alt="">
						</div>
						<div class="card-body">
							<h4 class="card-title" style="font-weight: bold; color: #39FF14;">꼰대존</h4>
							<p class="card-text" style="color: white;">#맞말필수 #유능 #야근 #완벽주의자 #위계질서 #30분전출근</p>
						</div>
					</a>
				</div>
				
				<div class="col-md-4 mb-4">
					<a href="#" class="card text-decoration-none h-100" style="background-color: navy;">
						<div style="margin: 5% 5%; border: solid 1px red; height: 60%;">
							<img src="<%= ctxPath%>/images/slave.png" class="card-img-top" style="width:100%; height:100%; object-fit:cover;" alt="">
						</div>
						<div class="card-body">
							<h4 class="card-title" style="font-weight: bold; color: #39FF14;">노예존</h4>
							<p class="card-text" style="color: white;">#말잘들음 #무욕인 #근성보유 #시키면다함 #묵묵 #수동적</p>
						</div>
					</a>
				</div>
				
				<div class="col-md-4 mb-4">
					<a href="#" class="card text-decoration-none h-100" style="background-color: navy;">
						<div style="margin: 5% 5%; border: solid 1px red; height: 60%;">
							<img src="<%= ctxPath%>/images/nointer.png" class="card-img-top" style="width:100%; height:100%; object-fit:cover;" alt="">
						</div>
						<div class="card-body">
							<h4 class="card-title" style="font-weight: bold; color: #39FF14;">금쪽이존</h4>
							<p class="card-text" style="color: white;">#사수소환술 #이유궁금 #궁금한거못참음 #카톡러버 #응애</p>
						</div>
					</a>
				</div>
				
				<div class="col-md-4 mb-4">
					<a href="#" class="card text-decoration-none h-100" style="background-color: navy;">
						<div style="margin: 5% 5%; border: solid 1px red; height: 60%;">
							<img src="<%= ctxPath%>/images/myway.png" class="card-img-top" style="width:100%; height:100%; object-fit:cover;" alt="">
						</div>
						<div class="card-body">
							<h4 class="card-title" style="font-weight: bold; color: #39FF14;">마이웨이존</h4>
							<p class="card-text" style="color: white;">#자유영혼 #타협불가 #독단적 #완벽주의자 #혁신 #열정</p>
						</div>
					</a>
				</div>
				
				<div class="col-md-4 mb-4">
					<a href="#" class="card text-decoration-none h-100" style="background-color: navy;">
						<div style="margin: 5% 5%; border: solid 1px red; height: 60%;">
							<img src="<%= ctxPath%>/images/mz.png" class="card-img-top" style="width:100%; height:100%; object-fit:cover;" alt="">
						</div>
						<div class="card-body">
							<h4 class="card-title" style="font-weight: bold; color: #39FF14;">MZ존</h4>
							<p class="card-text" style="color: white;">#에어팟필수 #칼퇴 #딴생각장인 #지각러버</p>
						</div>
					</a>
				</div>
				
			</div>
			
		</div>
	</div>
	
</body>
</html>
>>>>>>> branch 'main' of https://github.com/dongdangs/Justsurviveoffice.git
