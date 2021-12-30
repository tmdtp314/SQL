/*

   튜닝 - 인덱스, DB서버 튜닝

   튜닝의 핵심은 애초 쿼리 작성 시 효율적이고 적합한 쿼리문을 작성하는 것이다

*/

/*
자주 발생하는 성능 이슈
  - 비 표준 구문 사용 (join등)
  - Search argument 위반
  - 불필요한 I/O 위반, cursor/loop사용, 입시테이블/변수 사용, 부적절한 함수/뷰사용
  - 부적절한 만능 조회


  - 쿼리 작성 규칙 준수
  - Optimizer 도와주기


*/

/*
 실행계획에서 Index 사용 여부 확인
Ctrl+M 으로 실행계획 on
*/


-- page IO량 확인 ON/OFF
SET STATISTICS IO ON;
SET STATISTICS IO OFF;

select * from dbo.BigOrders
-- 테이블 'BigOrders'. 검색 수 1, 논리적 읽기 수 419, 물리적 읽기 수 0, 미리 읽기 수 0, LOB 논리적 읽기 수 0, LOB 물리적 읽기 수 0, LOB 미리 읽기 수 0.

-- '논리적 읽기 수' : 쿼리에서 읽은 [Data/Index] Page(8KB) 수
-- Page 는 IO에 대한 기본 단위 읽기 IO가(논리적 읽기)가 4이면 4*8=32KB
    
/* 

    실행계획 -  인덱스 사용 여부 판단 

	1. Index 사용하는 경우 
	 클러스터형 인덱스 '검색' , 인덱스 '검색' (Seek)

	2. Index 정상적으로 사용 못하는 경우
	  클러스터형 인덱스 '스캔' , 인덱스 '스캔' , 테이블 '스캔'(Scan)

*/


/*
     SQL Server Profiler 사용 주의
	  - "잘못" 사용 시 서버에 큰 부하 유발
	  - 운영 서버 연결은 DB관리자만 허용
	  - 권한 관리를 통한 사용 제약 필요

*/

/*
    Intellisence(자동완성기능) 끄고 필요할 때만 사용하기
	- 도구 > 옵션 > 텍스트편집기 > Transact-SQL > Intellisense > OFF

*/


/*****ANSI IO표준 사용하기 (버전-SQL2019 호환성 때문..)*****/
  -- JOIN(테이블 컴마로 나열하고 WHERE절에 조인조건), ORDER BY, WITH ROLLUP(과거문법) 등 
  -- 사라지는 구문들은 사용 배제 




/**************쿼리 작성 순서와 성능 사이의 연관******************/
SELECT * FROM DBO.Orders AS o
        WHERE o.CustomerID = '' -- Q) WHERE절 뒤 AND 조건 순서에 따라 성능을 미칠까?
		  AND o.ShipName =''    -- A) 그렇다 Query Optimizer 가 해준다. 
		  AND o.OrderDate = ''  -- 따라서 개발자는 이부분은 고민할 필요 없다


/** Q) FROM 절 작성 순서는 성능과 연관이 있을까?(JOIN 시) **/

-- 교환법칙, 결합법칙
SELECT *
  FROM DBO.[Order Details]
 WHERE (Discount <> 0)
   AND (10/Discount >0)

   -- VS

SELECT *
  FROM DBO.[Order Details]
 WHERE (10/Discount>0)
   AND (Discount<>0)

--순서대로 라면 두번째 쿼리는 에러가 떠야 하는데 (10/0 무한대이므로)
-- 옵티마이저가 DISCOUNT<>0을 먼저 실행시켜 두 쿼리가 오류가 나지 않는다.

SELECT * 
  FROM DBO.Orders AS O
  INNER JOIN DBO.[Order Details] AS D
     ON O.OrderID=D.OrderID
  WHERE O.OrderID = 10249

  -- VS

SELECT *
  FROM DBO.[Order Details] AS D
  INNER JOIN DBO.Orders AS O
     ON D.OrderID=O.OrderID
  WHERE D.OrderID=10249


  -- 결합법칙에 의해 옵티마이저가 어떤 순서에 따라 JOIN 하는것이 성능적으로 좋은 것인지를 계산해서 알아서 실행해준다. 
  -- 단, 결합법칙과 교환조건에는 전제가 있다. 수학적으로 수식순서가 바뀌는 경우에도 답이 동등할 연산이어야 한다.


  /************** 스키마 이름 지정하기 ****************/
  -- 개체 이름 해석에 있어서 개체 유일성을 위해 스키마 이름 필요
  -- DBO.SCHEMA.OBJECT
  -- SCHEMA 생략시 ID사용하는 불필요한 추가 과정을 거치게 된다.
  SELECT * FROM DBO.BigOrders




  /***********날짜시간 상수 이해***************/
   -- 날짜 열은 index를 가지고 있는 경우가 많다
   -- 검색 조건 유형 -> BETWEEN, >, =
   -- MILLI SECOND는 997까지이다 (999까지 아님)



 /**************후행 공백 처리******************/
 -- WHERE VARCHAR_COL = RTRIM(@CHAR) 필요? 
 -- RTRIM 함수는 자제 하는 것이 좋다 성능에 문제 있다. 
 DECLARE @VARCHAR VARCHAR(8), @CHAR CHAR(8)
 SELECT @VARCHAR='SQL ', @CHAR='SQL '

 IF(@VARCHAR='SQL') PRINT('SAME')
 IF(@CHAR='SQL') PRINT('SAME')


 /********조인조건 VS 검색조건, 임의 쿼리 식별자 달기(하드코딩시)*********/
 -- ANSI IO 표준 이전
 SELECT *
   FROM DBO.Orders O,DBO.[Order Details] D
  WHERE O.OrderID = D.OrderID

-- ANSI IO 표준 이후 
 SELECT * 
   FROM DBO.Orders O
   INNER JOIN DBO.[Order Details] D
      ON O.OrderID = D.OrderID

-- 조건의 위치
 SELECT O.OrderID, O.CustomerID, *
   FROM DBO.Customers AS C
   LEFT JOIN DBO.Orders AS O
     ON C.CustomerID=O.CustomerID
   WHERE C.CustomerID IN ('FISSA','PARIS','ANTON')
     AND O.CustomerID IS NULL /* 이 조건의 위치를 어디에 둘것인가*/

SELECT O.OrderID, O.CustomerID, *
   FROM DBO.Customers AS C
   LEFT JOIN DBO.Orders AS O
     ON C.CustomerID=O.CustomerID
	 AND O.CustomerID IS NULL 
   WHERE C.CustomerID IN ('FISSA','PARIS','ANTON')


/***********코드에서 임의/매개변수 커리의 호출 식별자 달기***************/
-- string sql = @"SELECT*FROM DBO.ORDERS -- ORDERS.CS";
-- 이렇게 닷넷에 하드코딩 하는 경우 ORDERS.CS라고 주석달기 (ORDERS.CS)
-- SQL Server 프로파일러/추적/확장이벤트 등에서 추적에 도움


     




   
