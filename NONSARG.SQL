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

   