<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>    

<%
	String ctxPath = request.getContextPath();
	// ctxPath => 
%>  

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원관리</title>

<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<link rel="stylesheet" type="text/css" href="<%= ctxPath%>/bootstrap-4.6.2-dist/css/bootstrap.min.css">

<script type="text/javascript" src="<%= ctxPath%>/js/jquery-3.7.1.min.js"></script>
<script type="text/javascript" src="<%= ctxPath%>/bootstrap-4.6.2-dist/js/bootstrap.bundle.min.js" ></script>

<script type="text/javascript">
	
	$(function(){
		
		// 모든 회원정보
		allMember();
		
		// 회원상세정보
		$(document).on('click', 'td.userinfo', function(e){
			const userId = $(e.target).parent().children('td:first-child').text();
		//	alert(userId);
			
			oneMember(userId);
		});// end of $(document).on('click', 'td.userinfo', function(e){})------------------------
		
	});// end of $(function(){})------------------------------
	
	
	// Function Declaration
	
	// === 모든 회원정보 출력 === //
	function allMember() {
		
		$.ajax({
			url:"<%= ctxPath%>/memberInfo/allMember",
			dataType:"json",
			success:function(json){
			//	console.log(JSON.stringify(json));
				/*
					[{"userId":"leemj","userName":"이미자","userPwd":"qwer1234$","gender":2,"regDate":"2025-08-06T10:10:11"}
					,{"userId":"leesk","userName":"이성계","userPwd":"qwer1234$","gender":1,"regDate":"2025-08-06T10:10:11"}
					,{"userId":"leess","userName":"이순신","userPwd":"qwer1234$","gender":1,"regDate":"2025-08-06T10:10:11"}
					,{"userId":"eomjh","userName":"엄정화","userPwd":"qwer1234$","gender":2,"regDate":"2025-08-06T10:10:11"}
					,{"userId":"iyou","userName":"아이유","userPwd":"qwer1234$","gender":2,"regDate":"2025-08-06T10:10:11"}
					,{"userId":"kimth","userName":"김태희","userPwd":"qwer1234$","gender":2,"regDate":"2025-08-06T10:10:11"}
					,{"userId":"parkby","userName":"박보영","userPwd":"qwer1234$","gender":2,"regDate":"2025-08-06T10:10:11"}
					,{"userId":"limyw","userName":"임영웅","userPwd":"qwer1234$","gender":1,"regDate":"2025-08-06T10:10:11"}
					,{"userId":"leeyj","userName":"이영자","userPwd":"qwer1234$","gender":2,"regDate":"2025-08-06T10:10:11"}
					,{"userId":"parkbk","userName":"박보검","userPwd":"qwer1234$","gender":1,"regDate":"2025-08-06T10:10:11"}
					,{"userId":"kangjh","userName":"강정화","userPwd":"qwer1234$","gender":2,"regDate":"2025-08-06T10:10:11"}]
				*/
				let v_html = `
							<table class='table table-striped'>
								<thead>
									<th>아이디</th>
									<th>회원명</th>
									<th>성별</th>
									<th>수정/삭제</th>
								</thead>
								<tbody>`;
				
				if(json.length == 0) {
					v_html += `
							<tr>
								<td colspan='4' align='center'>가입된 회원이 없습니다.</td>    
							</tr>`;
				}
				else {
					$.each(json, function(index, item){
						const v_gender = item.gender == 1 ? '남' : '여';
						v_html += `
								<tr style='cursor: pointer;'>
									<td class='userinfo' width='25%'>\${item.userId}</td>
									<td class='userinfo' width='25%'>\${item.userName}</td>
									<td class='userinfo' width='25%'>\${v_gender}</td>
									<td width='25%'>
										<button type='button' class='btn btn-sm btn-success mr-2' onclick='goUpdate("\${item.userId}")'>수정</button>
										<button type='button' class='btn btn-sm btn-danger' onclick='goDelete("\${item.userId}")'>삭제</button>
									</td>
								</tr>`;
					});
				}
				
				v_html += `
							</tbody>
						</table>`;
				
				$('div#tbl_1').html(v_html);
			},
			error: function(request, status, error){
				alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
			} 
		});
		
	}// end of function allMember()-------------------------
	
	
	// === 회원상세정보 출력 === //
	function oneMember(userId) {
		
		$.ajax({
			url:"<%= ctxPath%>/memberInfo/oneMember",
			data:{"userId":userId},
			dataType:"json",
			success:function(json){
				console.log(JSON.stringify(json));
				/*
					[{"userId":"leemj","userName":"이미자","userPwd":"qwer1234$","gender":2,"regDate":"2025-08-06T10:10:11"}]
				*/
				
				const v_gender = json.gender ==1 ? '남' : '여';
				const v_regDate = json.regDate.split("T").join(" ");
				
				let v_html = `
							<table class='table table-dark'>
								<tr>
									<th>아이디</th>
									<td>\${json.userId}</td>
								</tr>
								<tr>
									<th>회원명</th>
									<td>\${json.userName}</td>
								</tr>
								<tr>
									<th>성별</th>
									<td>\${v_gender}</td>
								</tr>
								<tr>
									<th>비밀번호</th>
									<td>\${json.userPwd}</td>
								</tr>
								<tr>
									<th>가입일자</th>
									<td>\${v_regDate}</td>
								</tr>
							</table>`;
				
				
				
				
				$('div#tbl_2').html(v_html);
			},
			error: function(request, status, error){
				alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
			} 
		});
		
	}// end of function allMember()-------------------------
	
	
	// === 회원 입력 및 수정 완료요청 === // 
	function goRegister() {
		
		const frm = document.registerFrm;
		
		const userId = frm.userId.value.trim();
		if(userId == "") {
			alert("아이디를 입력하세요!!");
			return;
		}
		
		const userPwd = frm.userPwd.value.trim();
		if(userPwd == "") {
			alert("비밀번호를 입력하세요!!");
			return;
		}
		
		const userName = frm.userName.value.trim();
		if(userName == "") {
			alert("성명을 입력하세요!!");
			return;
		}
		
		const genderLength = $('input:radio[name="gender"]:checked').length;
		if(genderLength == 0) {
			alert("성별을 선택하세요!!");
			return;
		}
		
		const frm_value = $('form[name="registerFrm"]').serialize();
	//	console.log(frm_value);
		// userId=rdg&userPwd=qwer1234%24&userName=%EA%B9%80%EC%9C%A4%ED%98%B8&gender=1
		
		$.ajax({
			url:"<%= ctxPath%>/memberInfo/register",
			type:"post",
			data:frm_value,
			dataType:"json",
			success:function(json){
			//	console.log(JSON.stringify(json));
				// {"member":{"userId":"rdg","userName":"김윤호","userPwd":"qwer1234$","gender":1,"regDate":null}}
				
				if(json.member != null) {
					allMember();
					oneMember(frm.userId.value);
					frm.reset();
					
					if($('p#title').text() == '회원수정') {	// 회원수정이 완료되면 원래대로 해주기
						$('p#title').html('회원입력').removeClass("text-danger").addClass("text-muted");
					}
				}
				
			},
			error: function(request, status, error){
				alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
			} 
		});
		
	}// end of function goRegister()----------------------------
	
	
	// === 회원수정 폼태그 만들기 === //
	function goUpdate(userId) {
		
		$.ajax({
			url:"<%= ctxPath%>/memberInfo/oneMember",
			data:{"userId":userId},
			dataType:"json",
			success:function(json){
				console.log(JSON.stringify(json));
				/*
					[{"userId":"leemj","userName":"이미자","userPwd":"qwer1234$","gender":2,"regDate":"2025-08-06T10:10:11"}]
				*/
				
				$('p#title').html('회원수정').removeClass("text-muted").addClass("text-danger");
				
				$('form[name="registerFrm"] input:text[name="userId"]').val(json.userId).attr("readonly", true);
				
				$('form[name="registerFrm"] input:text[name="userName"]').val(json.userName);
				
				$('form[name="registerFrm"] input:radio[name="gender"]').each(function(index, elmt){
					if($(elmt).val() == json.gender) {
						$(elmt).prop("checked", true);
						return false;	// 반복 종료
					}
				});
				
			},
			error: function(request, status, error){
				alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
			} 
		});
		
	}// end of function goUpdate(userId)----------------------------
	
	
	// ==== 회원 입력 및 수정시 취소 ====
	function goCancle() {
		
		if($('p#title').text() == '회원수정') {	// '회원수정' 이라면 '회원입력'으로 원래대로 해주기
			$('p#title').html('회원입력').removeClass("text-danger").addClass("text-muted");
		}
		
	}// end of function goCancle()----------------------
	
	
	// ==== 회원삭제 ====
	function goDelete(userId) {
		
		if(confirm(`정말로 \${userId} 님을 삭제하시겠습니까?`)) {
			
			$.ajax({
				url:"<%= ctxPath%>/memberInfo/delete",
				type:"delete",
				data:{"userId":userId},
				dataType:"json",
				success:function(json){
					console.log(JSON.stringify(json));
					// {"n":1}
					
					if(json.n == 1) {
						alert(`\${userId} 님을 삭제하였습니다.`);
						
						allMember();
						$('div#tbl_2').empty();
					}
				},
				error: function(request, status, error){
					alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
				} 
			});	
		}
		
	}// end of function goDelete(userId)----------------------
	
	
	// 회원검색(쿼리메소드)
	function goSearch_QueryMethod() {
		
		const userName = $('input:text[name="userName"]').val();
		const gender = $('select[name="gender"]').val();
		
		$.ajax({
			url:"<%= ctxPath%>/memberInfo/searchQueryMethod",
			data:{"userName":userName
				 ,"gender":gender},
			dataType:"json",
			success:function(json){
			//	console.log(JSON.stringify(json));
				/*
					[{"userId":"leemj","userName":"이미자","userPwd":"qwer1234$","gender":2,"regDate":"2025-08-06T10:10:11"}
					,{"userId":"leesk","userName":"이성계","userPwd":"qwer1234$","gender":1,"regDate":"2025-08-06T10:10:11"}
					,{"userId":"leess","userName":"이순신","userPwd":"qwer1234$","gender":1,"regDate":"2025-08-06T10:10:11"}
					,{"userId":"eomjh","userName":"엄정화","userPwd":"qwer1234$","gender":2,"regDate":"2025-08-06T10:10:11"}
					,{"userId":"iyou","userName":"아이유","userPwd":"qwer1234$","gender":2,"regDate":"2025-08-06T10:10:11"}
					,{"userId":"kimth","userName":"김태희","userPwd":"qwer1234$","gender":2,"regDate":"2025-08-06T10:10:11"}
					,{"userId":"parkby","userName":"박보영","userPwd":"qwer1234$","gender":2,"regDate":"2025-08-06T10:10:11"}
					,{"userId":"limyw","userName":"임영웅","userPwd":"qwer1234$","gender":1,"regDate":"2025-08-06T10:10:11"}
					,{"userId":"leeyj","userName":"이영자","userPwd":"qwer1234$","gender":2,"regDate":"2025-08-06T10:10:11"}
					,{"userId":"parkbk","userName":"박보검","userPwd":"qwer1234$","gender":1,"regDate":"2025-08-06T10:10:11"}
					,{"userId":"kangjh","userName":"강정화","userPwd":"qwer1234$","gender":2,"regDate":"2025-08-06T10:10:11"}]
				*/
				let v_html = `
							<table class='table table-striped'>
								<thead>
									<th>아이디</th>
									<th>회원명</th>
									<th>성별</th>
									<th>수정/삭제</th>
								</thead>
								<tbody>`;
				
				if(json.length == 0) {
					v_html += `
							<tr>
								<td colspan='4' align='center'>가입된 회원이 없습니다.</td>    
							</tr>`;
				}
				else {
					$.each(json, function(index, item){
						const v_gender = item.gender == 1 ? '남' : '여';
						v_html += `
								<tr style='cursor: pointer;'>
									<td class='userinfo' width='25%'>\${item.userId}</td>
									<td class='userinfo' width='25%'>\${item.userName}</td>
									<td class='userinfo' width='25%'>\${v_gender}</td>
									<td width='25%'>
										<button type='button' class='btn btn-sm btn-success mr-2' onclick='goUpdate("\${item.userId}")'>수정</button>
										<button type='button' class='btn btn-sm btn-danger' onclick='goDelete("\${item.userId}")'>삭제</button>
									</td>
								</tr>`;
					});
				}
				
				v_html += `
							</tbody>
						</table>`;
				
				$('div#tbl_1').html(v_html);
			},
			error: function(request, status, error){
				alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
			} 
		});
		
	}// end of function goSearch_QueryMethod()------------------------
	
	
	// 회원검색 [쿼리DSL(Domain Specific Language)]
	function goSearch_QueryDSL() {
		
		const userName = $('input:text[name="userName"]').val();
		const gender = $('select[name="gender"]').val();
		
		$.ajax({
			url:"<%= ctxPath%>/memberInfo/searchQueryDSL",
			data:{"userName":userName
				 ,"gender":gender},
			dataType:"json",
			success:function(json){
				console.log(JSON.stringify(json));
				/*
					[{"userId":"leemj","userName":"이미자","userPwd":"qwer1234$","gender":2,"regDate":"2025-08-06T10:10:11"}
					,{"userId":"leesk","userName":"이성계","userPwd":"qwer1234$","gender":1,"regDate":"2025-08-06T10:10:11"}
					,{"userId":"leess","userName":"이순신","userPwd":"qwer1234$","gender":1,"regDate":"2025-08-06T10:10:11"}
					,{"userId":"eomjh","userName":"엄정화","userPwd":"qwer1234$","gender":2,"regDate":"2025-08-06T10:10:11"}
					,{"userId":"iyou","userName":"아이유","userPwd":"qwer1234$","gender":2,"regDate":"2025-08-06T10:10:11"}
					,{"userId":"kimth","userName":"김태희","userPwd":"qwer1234$","gender":2,"regDate":"2025-08-06T10:10:11"}
					,{"userId":"parkby","userName":"박보영","userPwd":"qwer1234$","gender":2,"regDate":"2025-08-06T10:10:11"}
					,{"userId":"limyw","userName":"임영웅","userPwd":"qwer1234$","gender":1,"regDate":"2025-08-06T10:10:11"}
					,{"userId":"leeyj","userName":"이영자","userPwd":"qwer1234$","gender":2,"regDate":"2025-08-06T10:10:11"}
					,{"userId":"parkbk","userName":"박보검","userPwd":"qwer1234$","gender":1,"regDate":"2025-08-06T10:10:11"}
					,{"userId":"kangjh","userName":"강정화","userPwd":"qwer1234$","gender":2,"regDate":"2025-08-06T10:10:11"}]
				*/
				let v_html = `
							<table class='table table-striped'>
								<thead>
									<th>아이디</th>
									<th>회원명</th>
									<th>성별</th>
									<th>수정/삭제</th>
								</thead>
								<tbody>`;
				
				if(json.length == 0) {
					v_html += `
							<tr>
								<td colspan='4' align='center'>가입된 회원이 없습니다.</td>    
							</tr>`;
				}
				else {
					$.each(json, function(index, item){
						const v_gender = item.gender == 1 ? '남' : '여';
						v_html += `
								<tr style='cursor: pointer;'>
									<td class='userinfo' width='25%'>\${item.userId}</td>
									<td class='userinfo' width='25%'>\${item.userName}</td>
									<td class='userinfo' width='25%'>\${v_gender}</td>
									<td width='25%'>
										<button type='button' class='btn btn-sm btn-success mr-2' onclick='goUpdate("\${item.userId}")'>수정</button>
										<button type='button' class='btn btn-sm btn-danger' onclick='goDelete("\${item.userId}")'>삭제</button>
									</td>
								</tr>`;
					});
				}
				
				v_html += `
							</tbody>
						</table>`;
				
				$('div#tbl_1').html(v_html);
			},
			error: function(request, status, error){
				alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
			} 
		});
		
	}// end of function goSearch_QueryDSL()------------------------
	
	
</script>

</head>
<body>
	<div class="container">
		<div class="row pt-5">
			<div class="col-md-8">
				<p class="h2 text-center text-muted">회원정보</p>
				<div id="tbl_1" class="mt-4"></div>
			
				<form name="searchFrm">
					<ul style="list-style-type: none; padding: 0; border: solid 0px blue;">
						<li style="display: inline-block; border: solid 0px green; width:35%;">
							<label style="display: inline-block; border: solid 0px red; width:20%;">회원명</label>
							<input type="text" name="userName" width="40%" />
							<input type="text" style="display: none;" />
						</li>
						<li style="display: inline-block; width:60%;">
							<select name="gender" style="width: 20%; height: 35px;">
								<option value="">성별선택</option>
								<option value="1">남</option>
								<option value="2">여</option>
							</select>
							<button type="button" class="btn btn-primary ml-2" onclick="goSearch_QueryMethod()">회원검색(쿼리메소드)</button>
							<button type="button" class="btn btn-danger ml-2" onclick="goSearch_QueryDSL()">회원검색(쿼리DSL)</button>
						</li>
					</ul>
				</form>
				
			</div>
			
			<div class="col-md-3 offset-md-1">
				<p class="h3 text-center text-success">회원상세정보</p>
				<div id="tbl_2" class="mt-4"></div>
				
				<p class="h3 text-center text-muted mt-5" id="title">회원입력</p>
				<form name="registerFrm">
					<ul style="list-style-type: none; line-height: 1.5;">
						<li class="py-2">
							<label>아이디</label>
							<input type="text" name="userId" />
						</li>
						<li class="py-2">
							<label>비밀번호</label>
							<input type="password" name="userPwd" />
						</li>
						<li class="py-2">
							<label>성명</label>
							<input type="text" name="userName" />
						</li>
						<li class="py-2">
							<label>성별</label>
							<label for="male" class="ml-4">남</label><input type="radio" name="gender" id="male" value="1" />
							<label for="female" class="ml-2">여</label><input type="radio" name="gender" id="female" value="2" />
						</li>
						<li>
							<button type="button" class="btn btn-primary mr-5" onclick="goRegister()">완료</button>
							<button type="reset"  class="btn btn-danger" onclick="goCancle()">취소</button>
						</li> 
					</ul>
				</form>
				
			</div>
			
		</div>
	</div>	
</body>
</html>



