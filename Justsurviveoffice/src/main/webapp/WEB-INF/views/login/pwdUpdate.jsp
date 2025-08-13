<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%
    String ctxPath = request.getContextPath();
%>

<style>

body {background-color: #f5f3ff;background-image: url(https://img.freepik.com/free-vector/hand-painted-watercolor-floral-pattern_23-2148931052.jpg);background-size: cover;background-position: center;background-attachment: fixed;background-blend-mode: overlay;}
.formBox {margin:0 auto;max-width:500px;margin:8% auto;border-radius:20px;background-color:#fff;text-align:center;}
.pwdCheck {width: 100%;margin: 25px 0;display: flex;justify-content: space-between; align-items: center;padding: 0 25px;}
@media screen and (max-width:950px){
	.formBox {margin:15vh auto;}
} 
</style>

<script type="text/javascript">
  $(function(){
    $(".passwordUp").on("click", function(){
        const frm = document.passwordUp;
        
        const pwd1 = $("#newPassword1").val();
        const pwd2 = $("#newPassword2").val();

        if (pwd1 !== pwd2) {
            alert("비밀번호가 일치하지 않습니다.");
            return;
        }

        // 비밀번호 값 hidden 처리해서 전송할 수 있음
        $("<input>").attr({
            type: "hidden",
            name: "newPassword2",
            value: pwd2
        }).appendTo(frm);

        frm.action = "<%=ctxPath%>/login/passwordUpdate.do";
        frm.method = "POST";
        frm.submit();
    });
  });
</script>
	
	<div style="margin:150px auto 0;">
		<form name="passwordUp" class="formBox">
			<div style="text-align: center;background: #bf83fb;color: #fff;border-top-left-radius: 10px;border-top-right-radius: 10px;margin-bottom: 1%;font-weight: 600;font-size: 15pt;padding:4% 0;">비밀번호 변경할 아이디: ${requestScope.id}</div>
			<input type="hidden" name="id" value="${requestScope.id}" />
			<div class="pwdCheck">
					비밀번호: <input type="password" name="newPassword1" id="newPassword1">
			</div>
			<div class="pwdCheck">
					비밀번호 재확인: <input type="password" id="newPassword2"> <!-- name 제거 -->
			</div>
			<button type="button" name="passwordUp" class="btn btn-info passwordUp" style="background-color: #c084fc !important;border:0 !important;width:30%;margin-bottom:25px;">변경하기</button>
		</form>
	</div>

</div>
