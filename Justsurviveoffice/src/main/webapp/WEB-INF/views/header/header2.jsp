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
    <link rel="stylesheet" type="text/css" href="<%=ctxPath%>/jquery-ui-1.13.1.custom/jquery-ui.min.css" />
    <script type="text/javascript" src="<%=ctxPath%>/jquery-ui-1.13.1.custom/jquery-ui.min.js"></script>
	
	<style>
		body{overflow-x:hidden;}
		.col-md-2 ul {height:100%;background-color:green;display:flex;}
		.admTab {width:calc(100% / 7);background-color:#d5d5d5; display:block;color:#000;border-bottom:1px solid #5f0f0f;padding:1.5% 0; text-align:center;}
		.admTab:hover {background-color:#fff;}
		#clock {font-size:0.8rem;}
		@media screen and (max-width:1000px){
			
		}
	</style>
</head>
<script type="text/javascript">
	$(function(){
		
		updateClock();
		setInterval(updateClock, 1000);
		
	}) // end of function(){}
	
	function admOut(){
	   if(confirm('로그아웃 하시겠어요?')) {
	     location.href = '<%= ctxPath %>/users/logout';
	   }
	 }
	 
	 function updateClock() {
	   const now = new Date();
	   const daysOfWeek = ["일","월","화","수","목","금","토"];
	   const dayOfWeek = daysOfWeek[now.getDay()];
	   const year = now.getFullYear();
	   const month = String(now.getMonth() + 1).padStart(2, '0');
	   const day = String(now.getDate()).padStart(2, '0');
	   const minutes = String(now.getMinutes()).padStart(2, '0');
	   const seconds = String(now.getSeconds()).padStart(2, '0');

	   const hours24 = now.getHours();
	   const ampm = hours24 >= 12 ? 'PM' : 'AM';
	   const displayHours = (hours24 % 12) || 12;

	   var timeString =
	       year + '-' + month + '-' + day +
	       ' (' + dayOfWeek + ') ' +
	       displayHours + ':' + minutes + ':' + seconds + ' ' + ampm;

	   var el = document.getElementById('clock');
	   if (el) el.textContent = timeString;
	 }


</script>
<body>
	<div id="mycontainer" style="padding:0;">
		<div class="row justify-content-center">
			<div class="col-md-12">
				
				<ul style="border-right:1px solid #000;display:flex;flex-wrap:wrap;justify-content:space-between;">
				  <li class="admTab" style="background-image: url(/justsurviveoffice/images/logo2.png);display: block;background-size: contain;background-repeat: no-repeat;background-position: center;"></li>
				  <%-- <li class="admTab">${sessionScope.loginUser.name}</li> --%>
				  <li class="admTab"><i class="fa-solid fa-chart-simple"></i>&nbsp;<a href="chart">회원 통계보기</a></li>
				  <li class="admTab"><i class="fa-solid fa-user"></i>&nbsp;<a href="usersList">사용자 관리</a></li>
				  <li class="admTab"><i class="fa-solid fa-user"></i>&nbsp;<a href="userExcelList">회원목록 엑셀</a></li>
				  <li class="admTab admOut"  onclick="admOut()"><i class="fa-solid fa-house">&nbsp;</i>로그아웃</li>
				  <li class="admTab"><i class="fa-solid fa-rotate-left"></i><a href="javascript:history.back();">&nbsp;뒤로가기</a></li>
				  <li class="admTab"><div id="clock"></div></li>
				</ul>
			</div>
			
			<nav class="gnb">
			<h3 class="blind">Global Navi</h3>
			<ul>
				<li><a href="javascript:void(0);" class=""><b>SAMSUNG SDI</b></a>
					<button class="depth_open">Open</button>
					<ul style="display: none;">
						<li><a href="/about-sdi/index.html" title="회사소개로 이동하기">회사소개</a></li>
						<li><a href="/about-sdi/history.html" title="연혁으로 이동하기">연혁</a></li>
						<li><a href="/about-sdi/ci.html" title="CI로 이동하기">CI</a></li>
						<li><a href="/about-sdi/research-development.html" title="연구개발로 이동하기">연구개발</a></li>
						<li><a href="/about-sdi/global-network.html" title="글로벌 네트워크로 이동하기">글로벌 네트워크</a></li>
					</ul>
				</li>
				<li><a href="javascript:void(0);"><b>BUSINESS</b></a>
					<button class="depth_open">Open</button>
					<ul>
						<li><a href="/business/index.html" title="배터리로 이동하기">배터리</a></li>
						<li><a href="/business/electronic-materials.html" title="전자재료로 이동하기">전자재료</a></li>
					</ul>
				</li>
				<li><a href="javascript:void(0);"><b>IR</b></a>
					<button class="depth_open">Open</button>
					<ul>
						<li><a href="javascript:void(0);">주식정보</a><button class="depth_detail_open">Open</button>
							<ul>
								<li><a href="/ir/stock/index.html" title="주가정보로 이동하기"><span>주가정보</span></a></li>
								<li><a href="/ir/stock/stock-listing-info.html" title="주식 상장 현황으로 이동하기"><span>주식 상장 현황</span></a></li>
								<li><a href="/ir/stock/dividend-details.html" title="배당 현황으로 이동하기"><span>배당 현황</span></a></li>
								<li><a href="/ir/stock/shareholders.html" title="주주 구성으로 이동하기"><span>주주 구성</span></a></li>
							</ul>
						</li>
						<li><a href="javascript:void(0);">재무정보</a><button class="depth_detail_open">Open</button>
							<ul>
								<li><a href="/ir/financial/index.html" title="주요 재무지표로 이동하기"><span>주요 재무지표</span></a></li>
								<li><a href="/ir/financial/credit-rating.html" title="신용등급으로 이동하기"><span>신용등급</span></a></li>
								<li><a href="/ir/financial/audit-report.html" title="감사 보고서로 이동하기"><span>감사 보고서</span></a></li>
								<li><a href="/ir/financial/business-report.html" title="사업 보고서로 이동하기"><span>사업 보고서</span></a></li>
							</ul>
						</li>
						<li><a href="#">주주총회</a><button class="depth_detail_open">Open</button>
							<ul>
								<li><a href="/ir/corporate/index.html" title="주주총회 소집/결과로 이동하기"><span>주주총회 소집/결과</span></a></li>
								<li><a class="outline" href="https://dividend.samsungsdi.com/" title="배당금 조회 새 창 열기" target="_blank"><span>배당금 조회</span></a></li>
							</ul>
						</li>
						<li><a href="#">공시</a><button class="depth_detail_open">Open</button>
							<ul>
								<li><a href="/ir/disclosure/index.html" title="공시 자료로 이동하기">공시 자료</a></li>
								<li><a href="/ir/disclosure/notice.html" title="전자공고로 이동하기">전자공고</a></li>
							</ul>
						</li>
						<li><a href="#">IR활동</a><button class="depth_detail_open">Open</button>
							<ul>
								<li><a href="/ir/ir-activity/index.html" title="IR활동내역으로 이동하기"><span>IR활동내역</span></a></li>
								<li><a href="/ir/ir-activity/earning-releases.html" title="실적발표회로 이동하기"><span>실적발표회</span></a></li>
							</ul>
						</li>
					</ul>
				</li>
				<li><a href="javascript:void(0);" class=""><b>CAREER</b></a>
					<button class="depth_open">Open</button>
					<ul>
						<li><a href="/career/index.html" title="인재상으로 이동하기">인재상</a></li>
						<li><a href="javascript:void(0);">지원하기</a><button class="depth_detail_open">Open</button>
							<ul>
								<li><a href="/career/employment-procedure.html" title="채용전형으로 이동하기"><span>채용전형</span></a></li>
								<li><a href="/career/job-description.html" title="직무소개로 이동하기"><span>직무소개</span></a></li>
								<li><a href="/career/benefit.html" title="복리후생으로 이동하기"><span>복리후생</span></a></li>
								<li><a class="outline" href="https://www.samsungcareers.com/subsid/detail/C31" title="채용공고 새 창 열기" target="_blank"><span>채용공고</span></a></li>
							</ul>
						</li>
						<li><a href="/career/sdi-life/all/list.html" title="삼성SDI Life로 이동하기">삼성SDI Life</a></li>
					</ul>
				</li>
				<li><a href="javascript:void(0);"><b>ESG</b></a>
					<button class="depth_open">Open</button>
					<ul>
						<li><a href="javascript:void(0);">ESG 전략</a><button class="depth_detail_open">Open</button>
							<ul>
								<li><a href="/esg/sustainability/index.html" title="지속가능경영 전략 체계로 이동하기"><span>지속가능경영 전략 체계</span></a></li>
								<li><a href="/esg/sustainability/important-issue.html" title="이중 중대성 평가로 이동하기"><span>이중 중대성 평가</span></a></li>
								<li><a href="/esg/sustainability/risk-management.html" title="리스크 관리로 이동하기"><span>리스크 관리</span></a></li>
								<li><a href="/esg/sustainability/sustainable-policy.html" title="지속가능경영 정책으로 이동하기"><span>지속가능경영 정책</span></a></li>
								<li><a href="/esg/sustainability/initiative.html" title="글로벌 이니셔티브로 이동하기"><span>글로벌 이니셔티브</span></a></li>
							</ul>
						</li>
						<li><a href="javascript:void(0);">환경</a><button class="depth_detail_open">Open</button>
							<ul>
								<li><a href="/esg/environment/index.html" title="환경경영으로 이동하기"><span>환경경영</span></a></li>
								<li><a href="/esg/environment/net-zero.html" title="기후 위기 대응"><span>기후 위기 대응</span></a></li>
								<li><a href="/esg/environment/circulation.html" title="자원 순환"><span>자원 순환</span></a></li>
							</ul>
						</li>
						<li><a href="javascript:void(0);">사회</a><button class="depth_detail_open">Open</button>
							<ul>
								<li><a href="/esg/social/index.html" title="안전보건으로 이동하기"><span>안전보건</span></a></li>
								<li><a href="/esg/social/winwin-partnership.html" title="상생협력으로 이동하기"><span>상생협력</span></a></li>
								<li><a href="/esg/social/social-responsibility.html" title="공급망 관리로 이동하기"><span>공급망 관리</span></a></li>
								<li><a href="/esg/social/social-contribution.html" title="사회공헌으로 이동하기"><span>사회공헌</span></a></li>
								<li><a href="/esg/social/news.html" title="사회공헌 소식으로 이동하기"><span>사회공헌 소식</span></a></li>
								<li><a href="/esg/social/social-diversity.html" title="다양성 및 포용성으로 이동하기"><span>다양성 및 포용성</span></a></li>
							</ul>
						</li>
						<li><a href="javascript:void(0);">지배구조</a><button class="depth_detail_open">Open</button>
							<ul>
								<li><a href="/esg/governance/index.html" title="이사회로 이동하기"><span>이사회</span></a></li>
								<li><a href="/esg/governance/operation-of-bod.html" title="위원회로 이동하기"><span>위원회</span></a></li>
								<li><a href="/esg/governance/articles-of-incorporation.html" title="정관으로 이동하기"><span>정관</span></a></li>
								<li><a href="/esg/governance/directorate.html" title="이해관계자로 이동하기"><span>이해관계자</span></a></li>
								<li><a href="/esg/governance/compliance.html" title="준법경영으로 이동하기"><span>준법경영</span></a></li>
								<li><a href="/esg/governance/ethics.html" title="윤리경영으로 이동하기"><span>윤리경영</span></a></li>
								<li><a href="/esg/governance/protection.html" title="정보보호로 이동하기"><span>정보보호</span></a></li>
							</ul>
						</li>
						<li><a href="/esg/report/index.html" title="지속가능경영보고서로 이동하기">지속가능경영보고서</a></li>
					</ul>
				</li>
				<li><a href="javascript:void(0);"><b>PR Center</b></a>
					<button class="depth_open">Open</button>
					<ul>
						<li><a href="/sdi-now/sdi-news/list.html" title="뉴스로 이동하기"><span>뉴스</span></a></li>
						
						<li><a href="/sdi-now/sdi-media/list.html" title="유튜브로 이동하기"><span>유튜브</span></a></li>
					</ul>
				</li>
				<!-- <li><a href="javascript:void(0);"><b>고객센터</b></a>
					<button class="depth_open">Open</button>
					<ul>
						<li><a href="/etc/information.html" title="문의하기로 이동하기">문의하기</a></li>
					</ul>
				</li> -->
			</ul>
			<div class="sns_wrap">
				<ul class="sns">
					<li><a href="https://www.facebook.com/samsungsdi" title="삼성SDI 페이스북 새 창 열기" target="_blank"><img src="/resources/images/layout/ico_sns_facebook_w.svg" alt="Facebook"></a></li>
					<li><a href="https://www.youtube.com/user/SDISamsung" title="삼성SDI 유투브 새 창 열기" target="_blank"><img src="/resources/images/layout/ico_sns_utube_w.svg" alt="YouTube"></a></li>
					<li><a href="https://news.samsungsdi.com/ko" title="삼성SDI NEWS 새 창 열기" target="_blank"><img src="/resources/images/layout/ico_sns_news_w.png" alt="NEWS"></a></li>
				</ul>
			</div>
		</nav>