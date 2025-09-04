<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>

<%
   String ctxPath = request.getContextPath();
%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>설문 시작 페이지</title>

<!-- Bootstrap CSS -->
<link rel="stylesheet" href="<%= ctxPath%>/bootstrap-4.6.2-dist/css/bootstrap.min.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">

<script src="<%=ctxPath%>/js/jquery-3.7.1.min.js"></script>
<script src="<%=ctxPath%>/bootstrap-4.6.2-dist/js/bootstrap.bundle.min.js"></script>

<style>
   .survey-container {
      max-width: 450px;
      margin: 9% auto;
      padding: 20px;
      background: #f8f9fa;
      border-radius: 20px;
      box-shadow: 0 6px 14px rgba(0,0,0,0.08);
   }
   .survey-image img {
      border-radius: 16px;
   }
   .btn-start {
      background-color: #4da3ff;
      border: none;
      padding: 14px;
      font-weight: bold;
      border-radius: 30px;
      color: white;
      width: 100%;
   }
   .btn-start:hover { background-color: #368ce8; }

   /* 로딩 */
   .loader {
      border: 12px solid #f3f3f3;
      border-radius: 50%;
      border-top: 12px solid #007bff;
      width: 80px;
      height: 80px;
      animation: spin 1.5s linear infinite;
   }
   @keyframes spin { 0%{transform:rotate(0deg);} 100%{transform:rotate(360deg);} }
   #loading-screen {
      position: fixed; inset:0;
      background: rgba(255,255,255,0.7);
      display:flex; justify-content:center; align-items:center;
      z-index:9999;
   }

   /* 슬라이드 */
   .slides-wrapper {
      overflow: hidden;
      width: 100%;
   }
   .slides {
      display: flex;
      transition: transform .35s ease;
   }
   .slide {
      min-width: 100%;
      box-sizing: border-box;
   }

   /* 버블 스타일 */
   .question-bubble {
      background: #fff;
      border-radius: 20px;
      padding: 15px 20px;
      margin-bottom: 35px;
      box-shadow: 0 2px 8px rgba(0,0,0,0.05);
      text-align: left;
   }
   .question-bubble .QNo {
      font-size: 1rem;
      font-weight: bold;
      color: #99CCFF;
      margin-bottom: 10px;
   }
   .question-bubble .QText {
      font-size: 1.1rem;
      font-weight: 600;
      color: #333;
   }
   .option-bubble {
      background: #e9f3ff;
      border-radius: 20px;
      padding: 12px 18px;
      margin: 10px 0;
      cursor: pointer;
      transition: background 0.2s ease;
      text-align: left;
   }
   .option-bubble:hover { background: #cfe7ff; }
   .option-bubble:active { background: #b5d9ff; }

   /* 결과 */
   .result-bubble {
      background: #fff;
      border-radius: 20px;
      padding: 20px;
      box-shadow: 0 4px 12px rgba(0,0,0,0.08);
   }
</style>
</head>
<body class="bg-light">
   
   <!-- 로딩 -->
   <div id="loading-screen">
      <div class="loader"></div>
   </div>
   
   <!-- 시작 화면 -->
   <div class="survey-container text-center">
      <h4 class="fw-bold text-primary">성향 TEST</h4>
      <p class="text-muted">어떤 유형인지 알아보세요.</p>
      
      <div class="survey-image my-3">
         <img src="<%= ctxPath %>/images/mz.png" class="img-fluid w-100" alt="성향 이미지">
      </div>
      
      <button type="button" class="btn-start">설문 시작하기</button>
   </div>

<script>
   const isLogin = ${not empty sessionScope.loginUser};
   
   $(function(){
      $("#loading-screen").hide();
      $(".btn-start").click(function(){
         $(".survey-container").empty();
         $("#loading-screen").show();
         surveyStart();
      });
   });

   // 설문 시작
   function surveyStart() {
      $.ajax({
         url:"<%= ctxPath%>/categoryTest/surveyStart",
         dataType:"json",
         success:function(json){
            let v_html = `
            <div class="slides-wrapper">
               <div class="slides" id="slides">`;
            
            $.each(json, function(index, item){
               v_html += `
               <div class="slide px-2">
                  <div class="question-bubble">
                     <div class="QNo">Q\${index+1}</div>
                     <div class="QText">\${item.text}</div>
                  </div>`;
               
               $.each(item.options, function(opt_index, opt_item){
                  v_html += `
                     <div class="option-bubble opt-btn" 
                        data-qstno="\${index}" 
                        data-cat="\${opt_item.categoryNo}">
                        \${opt_item.text}
                     </div>`;
               });
               
               v_html += `</div>`;
            });
            
            v_html += `</div></div>`; // slides-wrapper 닫기
            $(".survey-container").html(v_html);
            
            const total = json.length;
            const answer_arr = [];
            
            $(".survey-container").on("click", ".opt-btn", function(){
               const qstno = Number($(this).data("qstno"));
               const optionNo = Number($(this).data("cat"));
               answer_arr[qstno] = optionNo;
               
               if(qstno < total-1){
                  $("#slides").css("transform", `translateX(-\${(qstno+1)*100}%)`);
               } else {
                  submitAnswers(answer_arr);
               }
            });
         },
         complete:function(){
            $("#loading-screen").hide();
         }
      });
   }

   // 결과 제출
   function submitAnswers(answer_arr) {
      $("#loading-screen").show();
      
      $.ajax({
         url:"<%= ctxPath%>/categoryTest/submit",
         method:"POST",
         data:{"answer_arr":answer_arr},
         dataType:"json",
         success:function(json){
            let r_html = `
            <div class="result-bubble text-center">
               <img src="<%= ctxPath %>/images/\${json.categoryImagePath}" class="img-fluid rounded mb-3">
               <div class="bg-primary text-white rounded p-3 fw-bold mb-3">`;
            
            $.each(json.tags, function(i, tag){
               r_html += `#\${tag} `;
               if(i % 3 === 2) r_html += `<br>`;
            });
            
            r_html += `</div>
               <h3 class="text-muted">\${json.categoryName}</h3>
            </div>`;
            
            if (!isLogin) {
               r_html += `<button class="btn btn-outline-primary btn-lg w-100 mt-3 fw-bold" onclick="login()">로그인하고 성향 저장하기</button>`;
            } else {
               r_html += `
               <form name="surveyForm" class="mt-4">   
                  <input type="hidden" name="categoryNo" value="\${json.categoryNo}"/>   
                  <button class="btn btn-outline-primary btn-lg w-100 fw-bold" onclick="saveCategory()">성향 GET!</button>
               </form>`;
            }
            
            r_html += `<button class="btn btn-outline-secondary btn-lg w-100 mt-3 fw-bold" onclick="retryTest()">테스트 다시하기</button>`;
            
            $(".survey-container").html(r_html);
         },
         complete:function(){
            $("#loading-screen").hide();
         }
      });
   }
   
   function login() { location.href = '<%= ctxPath %>/users/loginForm'; }
   function saveCategory() {
      const form = document.surveyForm;
      if(confirm("한 번 저장한 성향은 변경할 수 없습니다.\n저장하시겠습니까?")){
         form.method = "post";
         form.action = "<%= ctxPath %>/categoryTest/saveCategory";
         form.submit();
      }
   }
   function retryTest() { location.href = '<%= ctxPath %>/categoryTest/survey'; }
</script>
</body>
</html>
