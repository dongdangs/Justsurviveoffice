<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    String ctxPath = request.getContextPath();
%>

<jsp:include page="../header/header1.jsp" />

<style type="text/css">
  body {background-color:#f9fafb;}
  .chartMain {max-width:1300px;margin:5% auto;}
  .chartOpt {display:flex;justify-content:space-between;align-items:center;margin-bottom:3%;}
  #searchType {position:relative;}
  .chartPointer {position:absolute;right:0;top:20px;}
  
  .highcharts-data-table table,
  .stats-table {
    width: 100%;
    border-collapse: collapse;
    font-family: 'Noto Sans KR', sans-serif;
    font-size: 0.95rem;
    margin-top: 1.5rem;
  }

  .highcharts-data-table caption {
    padding: 1rem 0;
    font-size: 1.25rem;
    color: #4b5563;
  }

  .highcharts-data-table th,
  .stats-table th {
    background-color: #8080ff; /* 보라색 (Tailwind: violet-400) */
    color: white;
    font-weight: 600;
    padding: 0.75rem;
    border: 1px solid #cbd5e1;
    text-align: center;
  }

  .highcharts-data-table td,
  .stats-table td {
    padding: 0.75rem;
    border: 1px solid #cbd5e1; /* 테두리 진하게 */
    text-align: center;
  }

  .stats-table tr:nth-child(even) {
    background-color: #f9fafb; /* 연한 회색 (Tailwind: gray-50) */
  }

  .stats-table tr:hover {
    background-color: #f1f5f9; /* hover 효과 */
  }
  
  .chartInfo{font-size:1.8rem;}
  
  @media screen and (max-width:1200px){
     .chartMain {margin:8% auto;}
  }
  
   @media screen and (max-width:650px){
     .chartMain {margin:12% auto;}
     .chartInfo {font-size:1.3rem;}
  }
  
</style>


<!-- Highcharts 관련 JS -->
<script src="<%= ctxPath%>/Highcharts-10.3.1/code/highcharts.js"></script>
<script src="<%= ctxPath%>/Highcharts-10.3.1/code/modules/exporting.js"></script>
<script src="<%= ctxPath%>/Highcharts-10.3.1/code/modules/export-data.js"></script>
<script src="<%= ctxPath%>/Highcharts-10.3.1/code/modules/accessibility.js"></script>
<script src="<%= ctxPath%>/Highcharts-10.3.1/code/modules/series-label.js"></script>

<!-- 통계 페이지 레이아웃 -->
<main class="chartMain" style="width:70% !important;">
  <div class="max-w-5xl mx-auto bg-white rounded-2xl shadow-md p-6" 
  	   style="padding:1.5%; border-radius:15px; box-shadow:1px 1px 7px 1px #ddd;">

    <!-- ✅ 여기! 제목 + select 가로 배치 들어갈 자리 -->
    <div class="chartOpt">
      <h2 class="text-2xl font-bold text-gray-800 flex items-center" style="font-size: 20pt;">
        <i class="fas fa-chart-pie text-indigo-600 mr-2 chartInfo" style="color:#8080ff;font-size:19pt;"></i>통계 차트
      </h2>

      <form name="searchFrm">
        <div class="relative w-72" style="position:relative;">
          <select name="searchType" id="searchType"
            class="block w-full px-4 py-3 pr-10 text-gray-700 bg-white border border-gray-300 rounded-lg shadow-sm 
            	   focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 appearance-none z-10">
            <option value=""></option>	   
            <option value="register">회원가입 월별 통계</option>
            <option value="category">카테고리별 인원수 통계</option>
          </select>
        </div>
      </form>
    </div>

    <!-- 그래프 및 표 -->
    <div id="chart_container" class="p-4 bg-gray-50 border border-gray-200 rounded-xl mb-6 min-h-[350px]" 
    	 style="padding:1.5rem !1important;background:#f9fafb;border-radius:15px;"></div>
    <div id="table_container" style="overflow-x:scroll;z-index:30;"></div>

  </div>
</main>

<script type="text/javascript">
    $(function () {
        $('select#searchType').change(function (e) {
            func_choice($(e.target).val());
        });

        $("select#searchType").val("register").trigger("change");
    });

    function func_choice(searchTypeVal) {
        switch (searchTypeVal) {
            case "":
                $("div#chart_container").empty();
                $("div#table_container").empty();
                break;

            case "register":
                $.ajax({
                    url: "<%= ctxPath%>/admin/registerChart",
                    data: { "id": "${sessionScope.loginUser.id}" },
                    dataType: "json",
                    success: function (json) {
                        $("div#chart_container").empty();
                        $("div#table_container").empty();

                        let resultArr = [];

                        for (let i = 0; i < json.length; i++) {
                            let obj;
                            if (i == 0) {
                                obj = {
                                    name: json[i].registerday,
                                    y: Number(json[i].sumpay_pct),
                                    sliced: true,
                                    selected: true
                                };
                            } else {
                                obj = {
                                    name: json[i].categoryname,
                                    y: Number(json[i].sumpay_pct)
                                };
                            }
                            resultArr.push(obj);
                        }

                        Highcharts.chart('chart_container', {
                            chart: {
                                plotBackgroundColor: null,
                                plotBorderWidth: null,
                                plotShadow: false,
                                type: 'pie'
                            },
                            title: {
                                text: '카테고리별 주문 통계'
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
                                name: '주문금액비율',
                                colorByPoint: true,
                                data: resultArr
                            }]
                        });

                        let html = "<table class='stats-table'>";
                        html += "<tr>" +
                            "<th>카테고리</th>" +
                            "<th>주문수</th>" +
                            "<th>총주문금액</th>" +
                            "<th>퍼센티지</th>" +
                            "</tr>";

                        $.each(json, function (index, item) {
                            html += "<tr>" +
                                "<td>" + item.categoryname + "</td>" +
                                "<td>" + item.cnt + "</td>" +
                                "<td style='text-align: right;'>" + Number(item.sumpay).toLocaleString('en') + " 원</td>" +
                                "<td>" + Number(item.sumpay_pct) + " %</td>" +
                                "</tr>";
                        });

                        html += "</table>";
                        $("div#table_container").html(html);
                    },
                    error: function (request, status, error) {
                        alert("code: " + request.status + "\n" + "message: " + request.responseText + "\n" + "error: " + error);
                    }
                });
                break;

            case "myPurchase_byMonth_byCategory":
                $.ajax({
                    url: "<%= ctxPath%>/shop/myPurchase_byMonth_byCategoryJSON.do",
                    data: { "id": "${sessionScope.loginUser.id}" },
                    dataType: "json",
                    success: function (json) {
                        $("div#chart_container").empty();
                        $("div#table_container").empty();

                        const resultArr = [];

                        for (let i = 0; i < json.length; i++) {
                            const month_arr = [
                                Number(json[i].m_01),
                                Number(json[i].m_02),
                                Number(json[i].m_03),
                                Number(json[i].m_04),
                                Number(json[i].m_05),
                                Number(json[i].m_06),
                                Number(json[i].m_07),
                                Number(json[i].m_08),
                                Number(json[i].m_09),
                                Number(json[i].m_10),
                                Number(json[i].m_11),
                                Number(json[i].m_12)
                            ];

                            resultArr.push({
                                name: json[i].categoryname,
                                data: month_arr
                            });
                        }

                        Highcharts.chart('chart_container', {
                            title: {
                                text: new Date().getFullYear() + '년 카테고리별 월별주문 통계'
                            },
                            yAxis: {
                                title: {
                                    text: '주문 금액'
                                }
                            },
                            xAxis: {
                                accessibility: {
                                    rangeDescription: '범위: 1 to 12'
                                }
                            },
                            legend: {
                                layout: 'vertical',
                                align: 'right',
                                verticalAlign: 'middle'
                            },
                            plotOptions: {
                                series: {
                                    label: {
                                        connectorAllowed: false
                                    },
                                    pointStart: 1
                                }
                            },
                            series: resultArr,
                            responsive: {
                                rules: [{
                                    condition: {
                                        maxWidth: 500
                                    },
                                    chartOptions: {
                                        legend: {
                                            layout: 'horizontal',
                                            align: 'center',
                                            verticalAlign: 'bottom'
                                        }
                                    }
                                }]
                            }
                        });

                        let html = "<table class='stats-table'>";
                        html += "<tr><th>카테고리</th>";
                        for (let m = 1; m <= 12; m++) {
                            html += "<th>" + (m < 10 ? '0' + m : m) + "월</th>";
                        }
                        html += "</tr>";

                        $.each(json, function (index, item) {
                            html += "<tr>" +
                                "<td>" + item.categoryname + "</td>" +
                                "<td>" + Number(item.m_01).toLocaleString('en') + "</td>" +
                                "<td>" + Number(item.m_02).toLocaleString('en') + "</td>" +
                                "<td>" + Number(item.m_03).toLocaleString('en') + "</td>" +
                                "<td>" + Number(item.m_04).toLocaleString('en') + "</td>" +
                                "<td>" + Number(item.m_05).toLocaleString('en') + "</td>" +
                                "<td>" + Number(item.m_06).toLocaleString('en') + "</td>" +
                                "<td>" + Number(item.m_07).toLocaleString('en') + "</td>" +
                                "<td>" + Number(item.m_08).toLocaleString('en') + "</td>" +
                                "<td>" + Number(item.m_09).toLocaleString('en') + "</td>" +
                                "<td>" + Number(item.m_10).toLocaleString('en') + "</td>" +
                                "<td>" + Number(item.m_11).toLocaleString('en') + "</td>" +
                                "<td>" + Number(item.m_12).toLocaleString('en') + "</td>" +
                                "</tr>";
                        });

                        html += "</table>";
                        $("div#table_container").html(html);
                    },
                    error: function (request, status, error) {
                        alert("code: " + request.status + "\n" + "message: " + request.responseText + "\n" + "error: " + error);
                    }
                });
                break;
        }
    }
</script>



