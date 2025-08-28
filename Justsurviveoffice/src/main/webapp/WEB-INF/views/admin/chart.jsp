<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String ctxPath = request.getContextPath(); // e.g. /myspring
%>

<jsp:include page="../header/header2.jsp" />

<style type="text/css">
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

<!-- Highcharts -->
<script src="<%= ctxPath%>/Highcharts-10.3.1/code/highcharts.js"></script>
<script src="<%= ctxPath%>/Highcharts-10.3.1/code/modules/exporting.js"></script>
<script src="<%= ctxPath%>/Highcharts-10.3.1/code/modules/export-data.js"></script>
<script src="<%= ctxPath%>/Highcharts-10.3.1/code/modules/accessibility.js"></script>
<script src="<%= ctxPath%>/Highcharts-10.3.1/code/modules/series-label.js"></script>
<script src="<%= ctxPath%>/Highcharts-10.3.1/code/modules/data.js"></script>
<script src="<%= ctxPath%>/Highcharts-10.3.1/code/modules/drilldown.js"></script>

<div class="col-md-10">
<div style="display:flex;width:100%;">
  <div style="width:100%; min-height:1100px; margin:auto;">
    <h2 style="margin: 50px 0;">대사살 통계정보(차트)</h2>

    <form name="searchFrm" style="margin: 20px 0 50px 0;">
      <select name="searchType" id="searchType" style="height:30px;">
        <option value="">통계선택하세요</option>
        <option value="register">회원가입 인원통계(월별)</option>
        <option value="category">카테고리 인원통계</option>
        <%-- 향후 확장: <option value="register7d">회원가입 인원통계(최근 7일)</option> --%>
      </select>
    </form>

    <div id="chart_container"></div>
    <div id="table_container" style="margin-top:40px;"></div>
  </div>
</div>
<!-- end of chart !-->
</div>
<script type="text/javascript">
  $(function(){
    $('#searchType').change(function(e){
      func_choice($(e.target).val());
    });

    // 최초 로딩 시 월별 선택 후 실행
    $('#searchType').val("register").trigger("change");
  });

  function func_choice(searchTypeVal){
    switch(searchTypeVal) {
      case "":
        $('#chart_container, #table_container, #highcharts-data-table').empty();
        break;

		case "register": // 월별 가입자
		  $.ajax({
		    url: "<%= ctxPath%>/admin/chart/registerChart",
		    dataType: "json",
		    success: function(json){
		      $('#chart_container, #table_container, #highcharts-data-table').empty();

		      // 1) 01~12월 고정 라벨
		      const labelsFixed = Array.from({length:12}, (_,i)=> String(i+1).padStart(2,'0'));

		      // 2) 응답을 mm->cnt 맵으로 만들고, 고정 라벨 순서대로 값(없으면 0) 채우기
		      const monthMap = {};
		      (json || []).forEach(({mm, cnt}) => {
		        monthMap[String(mm).padStart(2,'0')] = Number(cnt || 0);
		      });
		      const data = labelsFixed.map(mm => monthMap[mm] ?? 0);

		      const total = data.reduce((a,b)=>a+b, 0);

		      // 3) Highcharts: 세로 막대(컬럼). 가로 막대 원하면 type: 'bar' 로 설정 하면됨
		      Highcharts.chart('chart_container', {
		        chart: { type: 'column' }, // 'bar'로 바꾸면 가로 막대임
		        title: { text: '2025년 월별 가입자 수' },
		        xAxis: { categories: labelsFixed, title: { text: '월' } },
		        yAxis: { min: 0, allowDecimals: false, title: { text: '가입자 수(명)' } },
		        tooltip: {
		          formatter: function () {
		            const pct = total === 0 ? 0 : (this.y * 100 / total);
		            return '<b>' + this.x + '월</b><br/>' + this.y + '명 (' + pct.toFixed(2) + '%)';
		          }
		        },
		        plotOptions: {
		          column: {
		            pointPadding: 0.1,
		            borderWidth: 0,
		            dataLabels: { enabled: true, format: '{point.y}' }
		          }
		        },
		        series: [{ name: '가입자 수', data }]
		      });
		      
		      let v_html = `<table class="table table-sm table-bordered">
		          <thead class="thead-light">
		            <tr>
		              <th style="text-align:center;">월</th>
		              <th style="text-align:right;">가입자 수</th>
		              <th style="text-align:right;">퍼센티지</th>
		            </tr>
		          </thead>
		          <tbody>`;

		      labelsFixed.forEach(mm => {
		        const cnt = monthMap[mm] ?? 0;
		        const pct = total === 0 ? 0 : (cnt * 100 / total);
		        v_html += `<tr>
		            <td style="text-align:center;">\${mm}</td>
		            <td style="text-align:right;">\${cnt.toLocaleString()}명</td>
		            <td style="text-align:right;">\${pct.toFixed(2)}%</td>
		          </tr>`;
		      });

		      v_html += `<tr>
		          <th style="text-align:center;">합계</th>
		          <th style="text-align:right;">\${total.toLocaleString()}명</th>
		          <th style="text-align:right;">\${total === 0 ? '0.00%' : '100.00%'}</th>
		        </tr>`;

		      v_html += `</tbody></table>`;
		      $('#table_container').html(v_html);
		    },
		    error: function(request, status, error){
		      alert("code: "+request.status+"\nmessage: "+request.responseText+"\nerror: "+error);
		    }
		  });
		  break;
	
	      // ===== 카테고리는 장유민이 제작함 ===== //
		case "category":
            $.ajax({
                url: "<%= ctxPath%>/admin/chart/categoryChart",
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
                            selected: true};
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
                      text: '카테고리별 인원통계'
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
              // ====================================================== //
              
              let v_html = `<table>
                           <tr>
                              <th>카테고리</th>
                              <th>인원수</th>
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
