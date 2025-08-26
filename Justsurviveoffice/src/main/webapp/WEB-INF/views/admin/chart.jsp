<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    String ctxPath = request.getContextPath();
    //     /myspring
%>

<jsp:include page="../header/header2.jsp" />

<style type="text/css">
   .highcharts-figure,
   .highcharts-data-table table {
       min-width: 320px;
       max-width: 800px;
       margin: 1em auto;
   }
   
   div#chart_container {
       height: 400px;
   }
   
   .highcharts-data-table table {
       font-family: Verdana, sans-serif;
       border-collapse: collapse;
       border: 1px solid #ebebeb;
       margin: 10px auto;
       text-align: center;
       width: 100%;
       max-width: 500px;
   }
   
   .highcharts-data-table caption {
       padding: 1em 0;
       font-size: 1.2em;
       color: #555;
   }
   
   .highcharts-data-table th {
       font-weight: 600;
       padding: 0.5em;
   }
   
   .highcharts-data-table td,
   .highcharts-data-table th,
   .highcharts-data-table caption {
       padding: 0.5em;
   }
   
   .highcharts-data-table thead tr,
   .highcharts-data-table tr:nth-child(even) {
       background: #f8f8f8;
   }
   
   .highcharts-data-table tr:hover {
       background: #f1f7ff;
   }
   
   input[type="number"] {
       min-width: 50px;
   }
   
   div#table_container table {width: 100%}
   div#table_container th, div#table_container td {border: solid 1px gray; text-align: center;} 
   div#table_container th {background-color: #595959; color: white;} 
</style>

<script src="<%= ctxPath%>/Highcharts-10.3.1/code/highcharts.js"></script>
<script src="<%= ctxPath%>/Highcharts-10.3.1/code/modules/exporting.js"></script>
<script src="<%= ctxPath%>/Highcharts-10.3.1/code/modules/export-data.js"></script>
<script src="<%= ctxPath%>/Highcharts-10.3.1/code/modules/accessibility.js"></script> 

<script src="<%= ctxPath%>/Highcharts-10.3.1/code/modules/series-label.js"></script>

<script src="<%= ctxPath%>/Highcharts-10.3.1/code/modules/data.js"></script>
<script src="<%= ctxPath%>/Highcharts-10.3.1/code/modules/drilldown.js"></script>

<div style="display: flex;">   
  <div style="width: 100%; min-height: 1100px; margin:auto; ">
	
	   <h2 style="margin: 50px 0;">대사살 통계정보(차트)</h2>
	   
	   <form name="searchFrm" style="margin: 20px 0 50px 0; ">
	      <select name="searchType" id="searchType" style="height: 30px;">
	         <option value="">통계선택하세요</option>
	         <option value="register">회원가입 인원통계(7일)</option>
	      </select>
	   </form>
	   
	   <div id="chart_container"></div>
	   <div id="table_container" style="margin: 40px 0 0 0;"></div>

  </div>
</div>

<script type="text/javascript">
	$(function(){
		
		$('select#searchType').change(function(e){
			func_choice($(e.target).val()); 
			// $(e.target).val() 은 
	        // "" 또는 "deptname" 또는 "gender" 또는 "genderHireYear" 또는 
	        // "deptnameGender" 또는 "pageurlUsername" 이다. 
		});
		
		// 문서가 로드 되어지면 부서별 인원통계 페이지가 보이도록 한다.
		$('select#searchType').val("register").trigger("change");
		
	}); // end of $(function(){ ======
		
		
	// function declation
	function func_choice(searchTypeVal){
		
		switch(searchTypeVal) {
		
		case "":						// 통계선택하세요를 선택한 경우
			 $('div#chart_container').empty();
			 $('div#table_container').empty();
			 $('div#highcharts-data-table').empty();
			 break;
			 
		case "register":				// 부서별 인원통계를 선택한 경우(pie차트)	
			// 107명 다 나올거라 data는 필요없다.
			
			 $.ajax({
				 
				url:"<%= ctxPath%>/adm/chart/registerChart",
				dataType:"json",
				success:function(json){
					
					$('div#chart_container').empty();
					$('div#table_container').empty();
					$('div#highcharts-data-table').empty();
					
					// console.log(JSON.stringify(json));
					
					/*
					[{"department_name":"Shipping","percentage":"40.54","cnt":"45"},
					 {"department_name":"Sales","percentage":"30.63","cnt":"34"},
					 {"department_name":"IT","percentage":"8.11","cnt":"9"},
					 {"department_name":"Finance","percentage":"5.41","cnt":"6"},
					 {"department_name":"Purchasing","percentage":"5.41","cnt":"6"},
					 {"department_name":"Executive","percentage":"2.7","cnt":"3"},
					 {"department_name":"Accounting","percentage":"1.8","cnt":"2"},
					 {"department_name":"Marketing","percentage":"1.8","cnt":"2"},
					 {"department_name":"Administration","percentage":"0.9","cnt":"1"},
					 {"department_name":"Human Resources","percentage":"0.9","cnt":"1"},
					 {"department_name":"Public Relations","percentage":"0.9","cnt":"1"},
					 {"department_name":"부서없음","percentage":"0.9","cnt":"1"}]	
					*/
					
					let resultArr = [];
					
					for(let i=0; i<json.length; i++){
						
						let obj;
						
						if(i==0){
							obj = {name:json[i].department_name,
								   y:Number(json[i].percentage),
								   sliced:true,
								   selected:true};	
						}
						else {
							
							obj = {name:json[i].department_name,
									   y:Number(json[i].percentage)
							};
						}
						
						resultArr.push(obj); // 배열속에 객체넣기
						
					} // end of for(let i=0; i<json.length; i++){
						
					Highcharts.chart('chart_container', {
					    chart: {
					        plotBackgroundColor: null,
					        plotBorderWidth: null,
					        plotShadow: false,
					        type: 'pie'
					    },
					    title: {
					        text: '우리회사 부서별 인원통계'
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
					        name: '인원비율',
					        colorByPoint: true,
					        data: resultArr
					    }]
					});
					/* ========================= */
					
					let v_html = `<table>
										<tr>
											<th>부서명</th>
											<th>인원수</th>
											<th>퍼센티지</th>
										</tr>`;
										
					$.each(json,function(index, item){
						v_html += `<tr>
									<td>\${item.department_name}</td>
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
				
			 }); // end of $.ajax({employeeCntByDeptname
			
			 break;
			 
		
		} // end of switch(searchTypeVal) { 
		
	} // end of function func_choice(searchTypeVal){ 
</script>