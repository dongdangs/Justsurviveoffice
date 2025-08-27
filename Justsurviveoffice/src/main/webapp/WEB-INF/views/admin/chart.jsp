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

<div style="display:flex;">
  <div style="width:100%; min-height:1100px; margin:auto;">
    <h2 style="margin: 50px 0;">대사살 통계정보(차트)</h2>

    <form name="searchFrm" style="margin: 20px 0 50px 0;">
      <select name="searchType" id="searchType" style="height:30px;">
        <option value="">통계선택하세요</option>
        <option value="register">회원가입 인원통계(월별)</option>
        <%-- 향후 확장: <option value="register7d">회원가입 인원통계(최근 7일)</option> --%>
      </select>
    </form>

    <div id="chart_container"></div>
    <div id="table_container" style="margin-top:40px;"></div>
  </div>
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

            // 기대 응답: [ {mm:"01", cnt:"3"}, {mm:"02", cnt:"0"}, ... {mm:"12", cnt:"5"} ]
            const labels = json.map(x => x.mm);
            const data   = json.map(x => Number(x.cnt || 0));
            const total  = data.reduce((a,b)=>a+b, 0);

            Highcharts.chart('chart_container', {
              chart: { type: 'column' },
              title: { text: '월별 가입자 수' },
              xAxis: { categories: labels, title: { text: '월' } },
              yAxis: { min: 0, title: { text: '가입자 수(명)' } },
              tooltip: {
                // column 차트는 기본 percentage 없음 → 직접 계산
                formatter: function () {
                  const pct = total === 0 ? 0 : (this.y * 100 / total);
                  return '<b>' + this.y + '명</b> (' + pct.toFixed(2) + '%)';
                }
              },
              plotOptions: {
                column: { 
                	dataLabels: { 
                		enabled: true, 
                		format: '{point.y}' 
                		} 
              		}
              },
              series: [
            	  { 
            		  name: '가입자 수', 
            		  data: data 
            		  }
              ]
            });

            // 표 렌더링
            let v_html = `<table class="table table-sm table-bordered">
                <thead class="thead-light">
                  <tr>
                    <th style="text-align:center;">월</th>
                    <th style="text-align:right;">가입자 수</th>
                    <th style="text-align:right;">퍼센티지</th>
                  </tr>
                </thead>
                <tbody>`;

            $.each(json, function(index, item){
              const mm  = item.mm;
              const cnt = Number(item.cnt || 0);
              const pct = total === 0 ? 0 : (cnt * 100 / total);
              v_html += `<tr>
                  <td style="text-align:center;">\${mm}</td>
                  <td style="text-align:right;">\${cnt.toLocaleString()}</td>
                  <td style="text-align:right;">\${pct.toFixed(2)}%</td>
                </tr>`;
            });

            v_html += `<tr>
                <th style="text-align:center;">합계</th>
                <th style="text-align:right;">\${total.toLocaleString()}</th>
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

      // === 확장 예시 ===
      // case "register7d":
      //   $.ajax({ url: "<%= ctxPath%>/admin/chart/registerChart7d", dataType:"json", success: ... });
      //   break;
    }
  }
</script>
