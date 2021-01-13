# JSP/Servlet Project
```
💡 JSP/Servlet + Oracle DB 회원가입 시스템을 구현해보고, 공부 내용을 정리하는 공간입니다
```
**개발환경**  
Oracle Database 11g Express Edition Release 11.2.0.2.0  
apache-tomcat-8.5.61 8  
Java EE 8

**1. 테이블 생성**  
회원가입 시스템에 사용할 테이블 만들기  
```sql
create table members(
  name varchar2(20) not null, 
  id varchar2(10) primary key, 
  password varchar2(10) not null, 
  email varchar2(50) not null, 
  join_date date);
```

**2. 시스템 설계**  



