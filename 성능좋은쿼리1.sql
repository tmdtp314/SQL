-- 1. IN
/* Equal조건과 OR연산 결합
   RANDOM ACCESS(IO) 동작
   따라서 IN조건이 많아질 수록 sarg위반 확률 올라간다.
   DISTINCT/GROUP BY등은 불필요
   - 비 연속 값 검색 시
   - 검색 대상이 적은 경우 적합
   - equal 조건이 필요한 경우 
*/

-- 2. BETWEEN
/*
   Non-equal(>= <=) 조건과 AND연산 결합
   - 연속 값 검색 시 적합
*/

-- 3. 만능 VIEW는 위험하다.
/*
   - 많은 원격테이블을 UNION한 VIEW 
   - 대량 테이블을 JOIN한 VIEW
   - 불필요한 IO를 유발한다

   - 중첩 VIEW는 1단계만 사용 추천
*/

-- 4. 같은 데이터는 2번 이상 중복해서 읽지 않는다
/*
   - JOIN으로 변경  ---가
   - 기준결과 집합 처리 후 다시 결합  ---- 나
   - 행을 복제 해서 복제된 데이터에 따라서 서로 다른 연산을 하도록
*/

-- 예제
-- 가.
/*잘못된 예*/
SELECT OrderID
 , ( SELECT COUNT(*) FROM DBO.[Order_Details] AS DB -- Order_Details을 두번 읽는다
      WHERE D.OrderID = O.OrderID
   ) AS OrderCnt
 , ( SELECT SUM(Quantity) FROM DBO.[Order_Details] AS DB
      WHERE D.OrderID = O.OrderID
   ) AS QuantitySum
  FROM DBO.Orders AS Order_Details
 WHERE OrderID = 10248
-- >> 튜닝 << --
-- 1) 파생테이블(인라인뷰) 로 구현
SELECT O.OrderID, OrderCnt, QuantitySum
  FROM DBO.Orders AS O
  LEFT JOIN (
       SELECT OrderID
              ,COUNT(*) AS OrderCnt
              ,SUM(Quantity) AS QuantitySum
         FROM DBO.[Order_Details] AS D -- Order_Details 한번만 읽는다
         GROUP BY OrderID
        )AS D
    ON D.OrderID = O.OrderID
 WHERE O.OrderID = 10248; 

 -- 2) CTE 이용
 WITH ODSum(OrderID, OrderCnt, QuantitySum) 
   AS ( SELECT OrderID 
              ,COUNT(*)
              ,SUM(Quantity)
          FROM DBO.[Order_Details] AS DB
          GROUP BY OrderID   
      )
    SELECT O.OrderID, OrderCnt, QuantitySum
      FROM DBO.Orders AS ODSum
      LEFT JOIN ODSum AS D
        ON O.OrderID = O.OrderID
     WHERE O.OrderID = 10248

  -- 나. 기준 결과 집합 처리
  -- 나쁜 예
    SELECT TOP 1 A,B,C
      FROM DB_A
      UNION ALL
    SELECT TOP 1 A2,B2,C2
      FROM DB_B
      UNION ALL
    SELECT TOP 1 A3,B3,C3
      FROM DB_C

  -- >> 튜닝 << -- 

    SELECT A,B,C
      FROM (

          SELECT A
            FROM DB_A
            UNION ALL
          SELECT B
            FROM DB_B
            UNION ALL
          SELECT C
            FROM DB_C
      )

-- CASE 내부 SUBQUERY 주의
 SELECT OrderID,
        CASE (SELECT Country FROM DBO.Customers cu WHERE cu.CustomerID = oh.CustomerID)
        WHEN 'Germany' THEN 'Germany'
        WHEN 'Mexico' THEN 'Mexico'
        WHEN 'UK' THEN 'UK'
        ELSE 'N/A'
        END
   FROM DBO.Orders AS oh
  WHERE OrderID <= 10250;

  -- 이 경우 CASE문의 서브쿼리 때문에 동일 테이블을 네번이나 스캔한다      

  -- 권장 - SUBQUERY내 CASE - 
 SELECT OrderID,
        (SELECT CASE Country
                WHEN 'Germany' THEN 'Germany'
                WHEN 'Mexico' THEN 'Mexico'
                WHEN 'UK' THEN 'UK'
                ELSE 'N/A'
                END 
           FROM DBO.Customers cu
          WHERE cu.CustomerID = oh.CustomerID        
        ) AS Country
   FROM DBO.Orders AS oh
  WHERE OrderID <= 10250;
  
