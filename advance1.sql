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


     


/*  의미 오류 : 쿼리 자체에는 문제가 없으나 쿼리의결과가 
   작성자의 본래 의도와 다르게 나타나는 것 (성능 문제 포함) */

   -- 데이터 일관성 이슈와 잠재적인 성능 이슈 

   /* 불필효한 함수와 조건을 쓰는 것 */
     -- ex) CHECK(Q>0) select .... where Q<0;
	 -- pk is null or ...isnull(pk,0)
	 -- 없는 열에 distinct 쓰는것
     -- order by 절에 pk열 쓰는 것 
	 -- where절에 써야 할조건을 groupby의 having절에 쓰는 경우 ****** 성능문제
	 -- union 쓸 때 중복 결과가 없는 조건에 쓰는것
	 -- 불필요한 조인
	    SELECT O.OrderID, O.OrderDate
		  FROM DBO.ORDERS AS O
		  INNER JOIN DBO.Customers AS C 
		     ON O.CustomerID = C.CustomerID  -- 불필요한 조인조건
	      WHERE O.OrderID=10250; 
	 -- NOT IN(...) 안에 NULL값이 결과로 오지 않도록
	 SELECT E.EmployeeID
	   FROM DBO.Employees AS E
	  WHERE E.EmployeeID NOT IN (SELECT M.ReportsTo FROM DBO.Employees AS M);


	  -- 서브쿼리 내 잘못된 외부 열 참조
	     SELECT OrderDate
		   FROM DBO.Orders
		  WHERE OrderID IN (SELECT OrderID FROM DBO.Customers);
		  -- 서브쿼리만 실행하면 오류나지만 전체 쿼리 실행 시 작동. 하지만 의도치않은 결과 도출
		  -- 전체 조회됨

	  -- 원하는 결과인가?
	   SELECT 50 ORDERID
	     FROM DBO.Orders
		WHERE CustomerID='QUICK'
		ORDER BY OrderDate


	  -- INNER 조인에 해당하는 OUTER조인 --> 참 많은 케이스
       SELECT M.EmployeeID AS ReportsTo, M.LastName, E.EmployeeID, E.Title
	     FROM DBO.Employees AS M
		 LEFT JOIN DBO.Employees AS E
		        ON M.EmployeeID=E.ReportsTo  -- 자기참조 
		WHERE E.Title='Sales Manager'  -- M이 아닌 E를 기준으로 조건문 쓴 결과

		--쿼리문은 OUTER JOIN일지라도 실행계획 보면 INNERJOIN 수행됨


		/* 요약 : 많은 경우 옵티마이저가 자동으로 성능 문제 해결해주지만 애초 작성시 좋은 쿼리로 작성해야..  */


/***************쿼리 금기 사항*****************/
/*1. SEARCH ARGUMENT 란...? 
    Predicate 에서 검색 대상 및 범위를 제한 할 수 있는 식
	(Predicate -> TRUE, FALSE, UNKNOWN 등 BOOLEAN값으로 표현되는 식)
	테이블 전체를 뒤지면서 대상을 조회하지 않도록 구성해야 한다. 
*/


/*2. SARG위반 (NON-SARG유형) - 이 경우 INDEX있어도 아예 못쓰는 경우가 발생 
  
	 - 검색을 제한하지 않는 식(테이블 전체를 다 훑는다)
	 - 인덱스 사용이나 쿼리 최적화에 방해되는 요소를 일컫는다
	 - 인덱스를 만들 경우 쓸 수 없게 된다
*/
  -- 불필요한 열 참조
      SELECT CategoryID,CategoryName FROM DBO.Categories 
      --VS
      SELECT * FROM DBO.Categories
      
     
      SELECT OrderID FROM DBO.Orders  -- 인덱스가 ORDERID에 있는 경우 
	  --VS
      SELECT OrderID,OrderDate FROM DBO.Orders 

  -- 불필요한 행 검색 : 추가 검색 조건이나 적절한 TOP(PagIng) 처리 필요

  -- INDEX열에 부정형 사용 주의
     /* 참고: 조건은 "="이 가장 빠르고 효율적 
	    불필요한 부정형(->범위검색으로 자동 전환됨)은 지양
		검색 범위가 적다면 긍정조건&"=" 조건으로 구현

		ID <> 3           --->   ID > 3 OR ID < 3
		ID !> 10248       --->   ID <= 10248
		ID NOT IN(1,3,5)  --->   ID <> 1 AND ID<> 3 AND ID<>5
		ID IN (2,4,6)     --->   ID = 1 OR ID=2 OR ID=3

	  ** NOT IN은 최후의 보루...최대한 안쓰는게 좋다 **
	  ** 인덱스 쓸 때 효율성이 떨어진다 **
	  복합 인덱스 선행 열에 순차적으로 위의 내용이 적용됨(적,필,상처럼..)
	  따라서 적에 해당하는 인덱스열에 LIKE가 들어가면 후(필,상)이 "="조건으로
	  되어있더라도 인덱스 상실하게됨. 
	 
	 */


/*3. 조건절 상수화 이슈(테이블변수VS임시테이블변수) */
/*4. 테이블 변수 최적화 이슈*/





   
