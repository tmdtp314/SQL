/* index 열 값 변형 NON SARG */
  -- index열에 사칙연산 적용
  SELECT *
    FROM DBO.[Order Details]
   WHERE OrderID+10=10268  -- 인덱스 열에 사칙연산이 적용되어 열 값 변형
     AND ProductID=5       -- 이 경우 인덱스 못 사용함

    SELECT *
    FROM DBO.[Order Details]
   WHERE OrderID=10268-10  -- 이렇게 써야함
     AND ProductID=5     


 -- INDEX 열엔 함수로 가공되지 않도록 구현해야한다
   SELECT OrderID,OrderDate,CustomerID
     FROM Orders
	WHERE SUBSTRING(CustomerID,1,3)='CEN'  --> LIKE이용해서 사용 'CEN%'

   SELECT OrderID,ShippedDate,CustomerID
     FROM Orders
	WHERE DATEDIFF(DD,ShippedDate,'19980506') <= 1 --> WHERE ShippedDate >= DATEADD(DD,-1,GETDATE())


   SELECT * 
     FROM Northwind.dbo.Orders
	WHERE ISNULL(OrderDate,'19970702')='19970702'  --> WHERE (OrderDate='19970702' OR OrderDate IS NULL) ************************


 -- INDEX열에 암시적 데이터 형 변환
    SELECT stor_id, stor_name -- INDEX(PK:STOR_ID, CHAR(4))
	  FROM PUBS.DBO.STORES
	WHERE stor_id=6380        -- 암시적 형변환이 일어나버림
	                          -- WHERE stor_id='6380'

    
	
/*** INDEX열에 LIKE, 불필요한 또는 NON-SARG유형 ***/	
  SELECT OrderID, OrderDate, CustomerID
    FROM Orders
   WHERE CustomerID LIKE 'CE'      -- '=' 이랑 동등 의미오류
     -- CustomerID LIKE '%CE%'     >> 일단 전부 스캔들어가서 비효율
	 -- OrderID LIKE '1024%'       >> 숫자열에 LIKE 스면 암시적 형변환 발생
	 -- OrderDate LIKE '05% 1990%' >> 암시적 형변환 발생

   
  
  /**열 간 비교되지 않도록 다른 형식으로 구현**/

  SELECT ...
    FROM Northwind.dbo.Orders
   WHERE OrderID = COALESCE(@OrderID,OrderID)
     AND CustomerID = COALESCE(@CustomerID,CustomerID)
  -- 만능조회 (마치 검색조건이 없는것처럼)
  -- 다중 ISNULL이라고 이해하면 됨

     DECLARE @OrderID INT = 10239;
     DECLARE @OrderDate DATETIME ='20211204'
     DECLARE @CustomerID NCHAR(10) = NULL;

     SELECT *
       FROM Northwind.dbo.Orders
      WHERE OrderID = COALESCE(@OrderID,OrderID)
        AND OrderDate = COALESCE(@OrderDate,OrderDate)
        AND CustomerID = COALESCE(@CustomerID,CustomerID)
    -- 이러면 인덱스 사용 안됨

------------ CAOLESCE 함수 ---------
    --  다중 ISNULL()의 축약식
    DECLARE
      @B_Code int = NULL
    , @A_Code int = NULL
    , @C_Code int = 10248
    
    SELECT COALESCE(@A_Code,@B_Code,@C_Code)
      -- 10248 반환
-----------------------------------
/*******NON-SARG사례*************/
 WHERE ISNULL(ShipRegion,'') = 'RJ'

 WHERE LEN(일련번호)=8
 ---> LIKE쓰던지 바꿔줘야함 

 WHERE A.제품번호 = B.제품번호
   AND (CASE A.코드구분 WHEN 'C' THEN A.C_코드
                        ELSE A.D_코드
                         END )='123456789'
  --> CASE문으로 컬럼변형. 인덱스 못씀 
  --> IF문식 AND-OR로 바꿔주자
  WHERE ((A.코드구분='C' AND A.C_코드 = '123456789')
          OR
         (A.코드구분!='C' AND A.D_코드='123456789'))
