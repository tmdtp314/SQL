/***********조건절 형식 중 우변에 상수(변수X)가 위치해야 SARG에 부합 *************/
/*

  1. 로컬변수
  2. 사용자 정의 함수

*/


-- 1. 로컬변수 NON-SARG
CREATE PROC dbo.up_Orders
 @OrderID
AS
  DECLARE @ID INT  -- 로컬변수
  SET @ID = @OrderID

  SELECT * 
    FROM dbo.Orders
   WHERE OrderID > @ID  -- NON SARG 
        -- 단 이 경우 PK(UQ) 열에 EQUAL조건이 들어갈 경우 인덱스 사용 가능(비교되는 값이 하나니까)
  -- @ID 에 서브쿼리를 쓸 경우 
  -- 부등호 우변에 서브쿼리를 직접 작성하는게 좋다


  -- 2. 사용자 정의 함수 NON-SARG
  SELECT *
    FROM dbo.Orders
   WHERE OrderID <= dbo.uf_OrderNo() -- 사용자(스칼라)함수



                