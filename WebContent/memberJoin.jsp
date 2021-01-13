<%@page import="dto.MemberDTO"%>
<%@page import="dao.MemberDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Sign Up</title>
</head>
<body>
<% 
	boolean resultFlag = (Boolean)request.getAttribute("resultFlag");
	if(resultFlag){
%>

	<h2> DB저장 성공!! </h2>
<h1>회원가입이 완료되었습니다.</h1><br>
<table>
	<tr>
			<td>이름:</td>
			<td><%=request.getParameter("name")%></td>
		</tr>
		<tr>
			<td>아이디:</td>
			<td><%=request.getParameter("id")%></td>
		</tr>
		<tr>
			<td>비밀번호:</td>
			<td><%=request.getParameter("password")%></td>
		</tr>
		<tr>
			<td>이메일:</td>
			<td><%=request.getParameter("email")%></td>
		</tr>
</table>
<% } else { %>
<h2> DB저장 실패  </h2>

뒤로가기 버튼을 클릭하십시오<br>
<button onclick="location.href='memberJoinForm.html'">뒤로가기</button>
<%} %>
</body>
</html>