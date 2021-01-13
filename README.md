# JSP/Servlet Project
```
💡 JSP/Servlet + Oracle DB 회원가입 시스템을 구현해보고, 공부 내용을 정리하는 공간입니다
```
**개발환경**  
Oracle Database 11g Express Edition Release 11.2.0.2.0  
apache-tomcat-8.5.61 8  
Java EE 8
#
## 1. 테이블 생성
회원가입 시스템에 사용할 테이블 만들기  
```sql
create table members(
  name varchar2(20) not null, 
  id varchar2(10) primary key, 
  password varchar2(10) not null, 
  email varchar2(50) not null, 
  join_date date);
```

## 2. 시스템 설계
**기능**   
- 회원가입, 회원정보 삭제  

**HTML & JSP**      
- memberJoinForm.html: 회원가입폼  
- memberJoin.jsp: 회원가입 성공or실패 출력  
- memberList.jsp: 회원정보 리스트 & 삭제옵션 구현  

**Servlet**    
- MemberJoinServlet.java: 회원가입 처리 서블릿  
- MemberListServlet.java: 회원정보 리스트화 서블릿
- MemberDelServlet.java: 회원정보 삭제하는 서블릿 

## 3. 회원가입 페이지 구현
회원가입 폼을 html로 구현하고, 데이터베이스가 정상적으로 저장되었는지 확인하는 가입완료 페이지를 jsp로 구현해보자.  
```html
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<h2>회원가입 페이지 입니다</h2>
	      <form action="memberJoin" method="post">
            <table>
                <tr>
                    <td>이름:</td>
                    <td><input type="text" name="name" ></td>
                </tr>
                <tr>
                    <td>아이디:</td>
                    <td><input type="text" name="id"></td>
                </tr>
                <tr>
                    <td>비밀번호:</td>
                    <td><input type="password" name="password"></td>
                </tr>
                <tr>
                    <td>이메일:</td>
                    <td><input type="email" name="email"></td>
                </tr>
            </table>
            <input type="submit" value="Submit">
        </form>
        
</body>
</html>
```
```jsp
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
```
![캡처](https://user-images.githubusercontent.com/61649201/104458380-a6908a80-55ee-11eb-9933-6f0cd191fda5.PNG)

## 4. DAO구현
데이터를 삽입, 검색, 삭제하는 기능을 DAO에 구현해보자.  

먼저, 회원정보 입력부분이다.  
```java
public boolean addMember(MemberDTO member) {
		boolean resultFlag = false;
		// 1. 필요한 객체들 선언
		Connection conn = null;
		PreparedStatement ps = null;
		try {
			// 3. DB접속
			conn = DBUtil.getConnection();

			// 4. 쿼리문 준비
			String sql = "insert into members(id,name,password,email,join_date) values(?,?,?,?,sysdate)";
			ps = conn.prepareStatement(sql);
			ps.setString(1, member.getId());
			ps.setString(2, member.getName());
			ps.setString(3, member.getPassword());
			ps.setString(4, member.getEmail());
			// 5. 실행.
			int count = ps.executeUpdate();
			if(count == 1)
				resultFlag = true;
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			// 2. 선언한 객체를 닫아주세요.
			DBUtil.close(conn, ps);
		}

		return resultFlag;
	}
  ```
  => DB에 접속하고 쿼리를 연결할 때 필요한 객체들을 선언하고, 실제 CURD 기능들을 구현하기위해 작성해야하는 가장 중요한 부분이다.  
  
  다음은 데이터베이스에 저장된 회원정보를 조회하는 메서드를 구현한 것이다.  
  ```java
  public List<MemberDTO> getMemberList(){
		
		List<MemberDTO> memberList = new ArrayList<MemberDTO>();
		//1. 필요한 객체 선언 
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {
			//3. DB접속
			conn = DBUtil.getConnection();
			//4. 쿼리작성
			ps = conn.prepareStatement("select id,name,password,email,join_date from members");
			//5. 쿼리실행
			rs = ps.executeQuery();
			//6. 결과값 꺼내기 
			while(rs.next()) {
				MemberDTO member = new MemberDTO();
				member.setId(rs.getString("id"));
				member.setName(rs.getString(2));
				member.setPassword(rs.getString(3));
				member.setEmail(rs.getString(4));
				member.setJoinDate(rs.getString(5));
				
				memberList.add(member);
			}
		}catch (Exception e) {
			e.printStackTrace();
		}finally {
			//2. 선언한 객체 닫기!!
			DBUtil.close(conn, ps, rs);
		}
		
		return memberList;
	}
  ```
  => 위의 insert 구현부와 마찬가지로 DB연결 해주고, 리스트처럼 불러오기 위해 List를 사용했다. 그리고 객체에서 결과값을 받아올 ResultSet이라는 객체를 생성해 주었다.  
  
  그다음은 삭제기능!  
  ```java
  public int deleteMember(String id) {
		int resultCount = 0;
		Connection conn = null;
		PreparedStatement ps = null;
		try {
			conn = DBUtil.getConnection();
			ps = conn.prepareStatement("delete from members where id = ?");
			ps.setString(1, id);
			
			resultCount = ps.executeUpdate();
		}catch (Exception e) {
			e.printStackTrace();
		}finally {
			DBUtil.close(conn, ps);
		}
		
		return resultCount;
	}
  ```
  => 패턴은 똑같다. 
  
  ## 5. JDBC 드라이버 연결
  데이터베이스를 불러오기 위해서는 사용하고있는 DB 드라이버를 연결해주어야 한다. 오라클 jdbc 드라이버를 설치하기위해 jar파일을 라이브러리로 추가해주면 되는데, 여기서는 ojdbc8.jar를 사용했다.  
  코드는 다음과 같다.  
  ```java
  public static Connection getConnection() throws Exception {
		String url = "jdbc:oracle:thin:@localhost:1521:xe";
		String user = "username";		
		String password = "password";
		Connection conn = null;
		Class.forName("oracle.jdbc.driver.OracleDriver");
		conn = DriverManager.getConnection(url, user, password);
		return conn;
	}
  ```
  => username과 password를 입력하면 정상적으로 연결이 될것이다. 
  
  ## 6. Servlet 클래스 구현
  서블릿은 총 3개의 파일을 만들었다. 차례대로 회원가입을 처리하는 서블릿, 회원정보 리스트를 불러오는 서블릿, 정보를 삭제하기 위한 서블릿이다. 각각의 서블릿 클래스는 반드시 HttpServlet로부터 상속받는다. 
  
  - MemberJoinServlet
  ```java
  @WebServlet("/memberJoin")
public class MemberJoinServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
   
	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("utf-8");

		//데이터베이스에 저장
		MemberDAO dao = new MemberDAO();
		MemberDTO member = new MemberDTO();
		member.setId(request.getParameter("id"));
		member.setName(request.getParameter("name"));
		member.setPassword(request.getParameter("password"));
		member.setEmail(request.getParameter("email"));
    
		//DB저장 성공여부에 따라, 성공하면 list출력, 실패하면 회원가입 페이지로 돌아가기
		boolean resultFlag = dao.addMember(member);
		request.setAttribute("resultFlag", resultFlag);
		RequestDispatcher rd = request.getRequestDispatcher("memberJoin.jsp");
		rd.forward(request, response);
		
		// 성공 -> list로 Redirect (mamberList page)
		if(resultFlag) {
			response.sendRedirect("memberList");
		}else {
			
		// 실패 -> memberJoin page
			response.sendRedirect("memberJoin");
		}
```
=> ```@WebServlet``` 서블릿 어노테이션을 사용하면 괄호안에있는 해당 주소를통해 url에 쉽게 접근할 수 있다. Java 5부터 생긴 기능이다.  
회원가입을 하면 가입완료라고 새로운 화면이 나타나고, 회원정보 리스트를 불러오는 화면들은 서블릿이 직접 만드는 것일까? 화면은 모두 jsp에서 구현이 가능하고 서블릿은 직접 구현하진 않고, 클라이언트에서 받은 요청을 그대로 jsp에게 포워딩한다. 즉, 넘겨준다는 의미이다.. jsp는 화면구현을 수행하고 다시 서블릿에 넘겨준다. 

- MemberListServlet
```java
@WebServlet("/memberList")
public class MemberListServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#service(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		//1. DAO에게 memberList를 얻어온다. 
		MemberDAO dao = new MemberDAO();
		List<MemberDTO> memberList = dao.getMemberList();
		//2. 얻어온 memberList를 request객체에게 맡긴다. 
		request.setAttribute("memberList", memberList);
		
		//3. memberList.jsp로 포워딩한다. 
		RequestDispatcher rd = request.getRequestDispatcher("memberList.jsp");
		rd.forward(request, response);
	}

}
```

- MemberDelServlet  
```java
@WebServlet("/memberDel")
public class MemberDelServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		//1.요청객체에서 아이디 값을 얻어온다. 
		String id = request.getParameter("id");
		//2. id에 해당하는 member를 DB에서 삭제한다. 
		MemberDAO dao = new MemberDAO();
		int count = dao.deleteMember(id);
		//3. memberList를 리다이렉트한다. 
		response.sendRedirect("memberList");
	}

}
```  
=> 여기서는 forward가 아닌, redirect를 사용했다. forward와 redirect는 객체의 재사용여부에 따라 적절히 선택하여 사용해야하는데, forward는 말그대로 건내주기만 하는것이므로 클라이언트가 요청한 정보들은 다음 url에서도 계속해서 유효하다. 반면에 redirect명령이 들어오면 브라우저에게 다른 페이지로 이동하라고 명령한다. 이때 브라우저의 주소창은 새로운 url로 바뀌며 클라이언트의 최초의 요청정보들은 더이상 유효하지 않게된다는 차이점이 있다.  

다음은 주소창에 /memberList를 입력해 회원정보 리스트를 불러오고, 삭제 기능을 실행한 모습이다.  
![그림2](https://user-images.githubusercontent.com/61649201/104463940-b9f32400-55f5-11eb-8b1d-4bcd40cc3b48.PNG)

이렇게 회원가입과 회원목록 조회, 삭제까지 해보는 간단한 프로그램을 완성해보았다.  
서버와 DB사이에서 동작하는 서블릿, jsp의 관계들을 머릿속으로 잘 그려볼줄 알아야한다!!  
