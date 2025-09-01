<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%
    String ctxPath = request.getContextPath();
%>

<!DOCTYPE html>
<html>
<head>

<!-- Required meta tags -->
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

<!-- Bootstrap CSS -->
<link rel="stylesheet" type="text/css" href="<%= ctxPath%>/bootstrap-4.6.2-dist/css/bootstrap.min.css" > 

<!-- Font Awesome 6 Icons -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.1/css/all.min.css">

<!-- Optional JavaScript -->
<script type="text/javascript" src="<%= ctxPath%>/js/jquery-3.7.1.min.js"></script>
<script type="text/javascript" src="<%= ctxPath%>/bootstrap-4.6.2-dist/js/bootstrap.bundle.min.js" ></script>

<%-- jQueryUI CSS 및 JS --%>
<link rel="stylesheet" type="text/css" href="<%= ctxPath%>/jquery-ui-1.13.1.custom/jquery-ui.min.css" />
<script type="text/javascript" src="<%= ctxPath%>/jquery-ui-1.13.1.custom/jquery-ui.min.js"></script>

<script src="https://cdn.tailwindcss.com"></script>

<style type="text/css">
    /* 배경 */
    body {
        background-color: #9da6ae;
        background-image: url("<%= ctxPath%>/images/background.png");
        background-size: cover;
        background-position: center;
        background-attachment: fixed;
        background-blend-mode: overlay;
        background-repeat:no-repeat;
    }

    /* form 컨테이너 - idFind.jsp와 동일 */
    .form-container {
        margin: 0 auto;
        max-width: 600px; /* ✅ idFind랑 동일한 크기 */
        width: 100%;
        background-color: #ffffffcc; /* ✅ 반투명 흰색 */
        border-radius: 12px;
        box-shadow: 0 8px 20px rgba(0, 0, 0, 0.1);
        backdrop-filter: blur(8px);
        overflow: hidden;
    }

    /* 상단 헤더 */
    .form-header {
        background: #6366f1;
        padding: 16px;
        text-align: center;
        font-size: 18px;
        font-weight: bold;
        color: white;
        position: relative;
    }

    /* 뒤로가기 아이콘 */
    .back-icon {
        background-image: url('<%= ctxPath%>/images/backIco.png');
        position: absolute;
        top: 16px;
        left: 10px;
        width: 30px;
        height: 30px;
        background-size: cover;
        cursor: pointer;
    }

    /* 입력 영역 */
    .form-body {
        padding: 24px;
    }

    /* 입력 필드 */
    .input-group {
        display: flex;
        flex-direction: column;
        margin-bottom: 16px;
    }

    .input-group label {
        font-weight: 600;
        color: #333;
        margin-bottom: 6px;
    }

    .input-group input {
        width: 100%;
        padding: 10px 12px;
        font-size: 14px;
        border: 1px solid #ccc;
        border-radius: 6px;
        outline: none;
        transition: all 0.2s ease-in-out;
    }

    .input-group input:focus {
        border-color: #6366f1;
        box-shadow: 0 0 4px rgba(99, 102, 241, 0.4);
    }

    /* 버튼 */
    .submit-btn {
        width: 100%;
        background-color: #6366f1;
        color: white;
        font-weight: bold;
        padding: 12px 0;
        border: none;
        border-radius: 8px;
        margin-top: 10px;
        margin-bottom: 5px;
        transition: background-color 0.2s ease-in-out;
        cursor: pointer;
    }

    .submit-btn:hover {
        background-color: #4f46e5;
        box-shadow: 0 4px 10px rgba(99, 102, 241, 0.3);
    }
</style>

<script type="text/javascript">
    $(function(){
        $(".submit-btn").on("click", function(){
            const frm = document.passwordUp;
            const pwd1 = $("#newPassword1").val();
            const pwd2 = $("#newPassword2").val();

            if (pwd1 !== pwd2) {
                alert("비밀번호가 일치하지 않습니다.");
                return;
            }

            $("<input>").attr({
                type: "hidden",
                name: "newPassword2",
                value: pwd2
            }).appendTo(frm);

            frm.action = "<%=ctxPath%>/users/pwdUpdate";
            frm.method = "POST";
            frm.submit();
        });
    });
</script>
</head>

<body class="min-h-screen flex items-center justify-center p-4">

    <div class="form-container">
        <!-- 헤더 -->
        <div class="form-header">
            <p class="back-icon" onclick="location.href='http://localhost:9089/justsurviveoffice/'"></p>
            비밀번호 변경할 아이디: ${requestScope.id}
        </div>

        <!-- 입력 폼 -->
        <form name="passwordUp" class="form-body">
            <input type="hidden" name="id" value="${requestScope.id}" />

            <div class="input-group">
                <label for="newPassword1">비밀번호</label>
                <input type="password" id="newPassword1" name="newPassword1" placeholder="새 비밀번호를 입력하세요" />
            </div>

            <div class="input-group">
                <label for="newPassword2">비밀번호 재확인</label>
                <input type="password" id="newPassword2" placeholder="비밀번호를 다시 입력하세요" />
            </div>

            <button type="button" class="submit-btn">변경하기</button>
        </form>
    </div>

</body>
</html>