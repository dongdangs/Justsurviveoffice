<%@ page contentType="text/html; charset=UTF-8" 
		 pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%
    String ctxPath = request.getContextPath();
%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>마이페이지</title>

<link rel="stylesheet" href="<%=ctxPath%>/bootstrap-4.6.2-dist/css/bootstrap.min.css">

<script src="<%=ctxPath%>/js/jquery-3.7.1.min.js"></script>
<script src="<%=ctxPath%>/bootstrap-4.6.2-dist/js/bootstrap.bundle.min.js"></script>

<!-- Highcharts -->
<script src="<%= ctxPath%>/Highcharts-10.3.1/code/highcharts.js"></script>
<script src="<%= ctxPath%>/Highcharts-10.3.1/code/modules/exporting.js"></script>
<script src="<%= ctxPath%>/Highcharts-10.3.1/code/modules/export-data.js"></script>
<script src="<%= ctxPath%>/Highcharts-10.3.1/code/modules/accessibility.js"></script>
<script src="<%= ctxPath%>/Highcharts-10.3.1/code/modules/series-label.js"></script>
<script src="<%= ctxPath%>/Highcharts-10.3.1/code/modules/data.js"></script>
<script src="<%= ctxPath%>/Highcharts-10.3.1/code/modules/drilldown.js"></script>


<style>
    body {
        background: #f7f7fb;
    }
    .sidebar {
        background: #fff;
        border-radius: 12px;
        padding: 20px;
        box-shadow: 0 8px 24px rgba(0,0,0,.06);
    }
    .sidebar img {
        max-width: 100%;
        border-radius: 10px;
    }
    .sidebar-menu a {
        display: block;
        padding: 8px 0;
        color: #333;
        text-decoration: none;
    }
    .sidebar-menu a:hover {
        color: #6c63ff;
    }
    .content {
        background: #fff;
        border-radius: 12px;
        padding: 24px;
        box-shadow: 0 8px 24px rgba(0,0,0,.06);
    }
    
    .row{
    	display:flex;
    	align-items: stretch;
   	}
   	.sidebar,
   	.content {
   		height : 100% ;
   	}
   	
   	.highcharts-figure,
   .highcharts-data-table table { min-width:320px; max-width:800px; margin:1em auto; }
   div#chart_container { height: 400px; }
   .highcharts-data-table table {
       font-family: Verdana, sans-serif; border-collapse: collapse; border: 1px solid #ebebeb;
       margin: 10px auto; text-align: center; width: 100%; max-width: 500px;
   }
   .highcharts-data-table caption { padding: 1em 0; font-size: 1.2em; color: #555; }
   .highcharts-data-table th { font-weight: 600; padding: 0.5em; }
   .highcharts-data-table td, .highcharts-data-table th, .highcharts-data-table caption { padding: 0.5em; }
   .highcharts-data-table thead tr, .highcharts-data-table tr:nth-child(even) { background: #f8f8f8; }
   .highcharts-data-table tr:hover { background: #f1f7ff; }
   input[type="number"] { min-width: 50px; }

   div#table_container table { width:100% }
   div#table_container th, div#table_container td { border: 1px solid gray; text-align:center; }
   div#table_container th { background-color:#595959; color: white; }
</style>

<script type="text/javascript">
	
	$(function(){
		
		$('#searchType').change(function(e){
      		func_choice($(e.target).val());
	    });

	    // 최초 로딩 시 월별 선택 후 실행
	    $('#searchType').val("category").trigger("change");
		
	});
	
	
	function func_choice(searchTypeVal){
		
		switch (searchTypeVal) {
			case "category":
				
				$.ajax({
	                url: "<%= ctxPath%>/mypage/chart/categoryByBoard",
	                type: "post",
	                dataType: "json",
	                success: function (json) {
	                    $("div#chart_container").empty();
	                    $("div#table_container").empty();
	
	              let resultArr = [];
	              
	              for(let i=0; i<json.length; i++) {
	                 
	                 let obj;
	                 
	                 if(i==0) {
	                    obj = {name: json[i].categoryName,
	                            y: Number(json[i].percentage),
	                            sliced: true,
	                            selected: true,
	                            };
	                 }
	                 else {
	                    obj = {name: json[i].categoryName,
	                            y: Number(json[i].percentage)};
	                 }
	                 
	                 resultArr.push(obj); // 배열속에 객체를 넣기
	                 
	              } // end of for
	              
	              // ====================================================== //
	              Highcharts.chart('chart_container', {
	                  chart: {
	                      plotBackgroundColor: null,
	                      plotBorderWidth: null,
	                      plotShadow: false,
	                      type: 'pie'
	                  },
	                  title: {
	                      text: '카테고리별 게시글 통계'
	                  },
	                  tooltip: {
	                      pointFormat: '{series.name}: <b>{point.percentage:.2f}%</b>'
	                  },
	                  accessibility: {
	                      point: {
	                          valueSuffix: '%'
	                      }
	                  },
	                  plotOptions: {
	                      pie: {
	                          allowPointSelect: true,
	                          cursor: 'pointer',
	                          dataLabels: {
	                              enabled: true,
	                              format: '<b>{point.name}</b>: {point.percentage:.2f} %'
	                          }
	                      }
	                  },
	                  series: [{
	                      name: '게시글 수',
	                      colorByPoint: true,
	                      data: resultArr
	                  }]
	              });                  
	              // ====================================================== //
	              
	              let v_html = `<table>
	                           <tr>
	                              <th>카테고리</th>
	                              <th>게시글 수</th>
	                              <th>퍼센티지</th>
	                           </tr>`;
	                           
	              $.each(json, function(index, item){
	                 v_html += `<tr>
	                            <td>\${item.categoryName}</td>
	                            <td>\${item.cnt}</td>
	                            <td>\${item.percentage}</td>
	                          </tr>`;
	              });             
	                           
	              v_html += `</table>`;
	              
	              $('div#table_container').html(v_html);         
	              
	           },
	           error: function(request, status, error){
	                    alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
	                 }
	        });
				
			break;
		}
	}
	
</script>


</head>
<body>
	<div class="container mt-4">
    	<div class="row">

        	<!-- 사이드바 -->
        	<div class="col-lg-3 mb-3">
            	<h3 class="mb-1">MYPAGE</h3>
            	<div class="sidebar text-center">
                	<img src="<%=ctxPath%>/images/mz.png" alt="프로필" class="mb-3">
                	<div class="text-muted small mb-3">${sessionScope.loginUser.email}</div>
                	<div class="mb-3">
                		<span style="size:20pt; color:blue;">${sessionScope.loginUser.name} 님 </span>
                    	포인트 : <b><fmt:formatNumber value="${sessionScope.loginUser.point}" pattern="#,###"/>p</b>
                	</div>
                	<hr>
                	<div class="sidebar-menu text-left">
                    	<a href="<%=ctxPath%>/login/logout">로그아웃</a>
                    	<a href="#" id="btnQuit">탈퇴하기</a>
                    	<a href="javascript:history.back()">이전 페이지</a>
                	</div>
            	</div>
        	</div>

        	<!-- 메인 내용 -->
        	<div class="col-lg-9">
            	<div class="content">

                	<!-- 탭 메뉴 -->
                	<ul class="nav nav-tabs mb-3">
                    	<li class="nav-item">
                        	<a class="nav-link" href="<%= ctxPath%>/mypage/info">내 정보</a>
                    	</li>
                    	<li class="nav-item">
                        	<a class="nav-link" href="<%= ctxPath%>/mypage/forms">내가 쓴 글</a>
                    	</li>
	                    <li class="nav-item">
	                        <a class="nav-link" href="<%= ctxPath%>/mypage/bookmarks">내 북마크</a>
	                    </li>
	                    <li class="nav-item">
	                        <a class="nav-link active" href="<%= ctxPath%>/mypage/chart">통계</a>
	                    </li>
                	</ul>
                	
                	<h2>대사살 통계정보(차트)</h2>
                	
                	<form name="searchFrm" style="margin: 20px 0 50px 0;">
				      	<select name="searchType" id="searchType" style="height:30px;">
				        	<option value=""></option>
					        <option value="category">카테고리별 게시물 통계</option>
				      	</select>
				    </form>
					
					<div id="chart_container"></div>
					<div id="table_container" style="margin-top:40px;"></div>
                	
              	</div>
           	</div>
           
        </div>
         
   	</div>
         
</body>
</html>