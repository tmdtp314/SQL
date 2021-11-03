
 UPDATE T_ODD 
    SET ODD_08 += @GEM_06
  WHERE ODD_01 = @GEM_1501
    AND ODD_02 = @GEM_1502


--------------------- 다음과 같은 쿼리이다. 

DECLARE @SUM INT 
SELECT SUM(ODD_08) 
  FROM ODD_01 = @GEM_1501
   AND ODD_02 = @GEM_1502

UPDATE T_ODD  
   SET ODD_08 = @SUM
  FROM ODD_01 = @GEM_1501
   AND ODD_02 = @GEM_1502

   
 ---------------------------

 
 DECLARE @GEM_05 INT 
 DECLARE @GEM_01 VARCHAR(50) 
 DECLARE @GEM_04 VARCHAR(50)
 SET @GEM_04 = 'AAA'         -- DAH_01
 SET @GEM_01 = 'AAA-001'     -- PK OF GEM
 SET @GEM_05 = 1300          -- DAH_07
 
 MERGE INTO T_DAH B -- 번경할 테이블 
      USING (SELECT DAH_07, DAH_01, DAH_08 -- 비교할 TBL
	           FROM T_DAH
		     ) AS A			
			  ON  A.DAH_07!=@GEM_05    -- 바꾸고 싶은 데이터 골라내는 조건 1
			  AND A.DAH_01=@GEM_04	   -- 바꾸고 싶은 데이터 골라내는 조건 2
     		AND A.DAH_08 !='N'       -- 바꾸고 싶은 데이터 골라내는 조건 3
        AND @GEM_05!=0           -- 입력되는 파라미터값에 대한 조건		
			  AND A.DAH_01 = B.DAH_01  -- *************************** 이부분 안 해주면 전체 UPDATE된다. !! (혹은 전체 DELETE )
			WHEN MATCHED THEN UPDATE SET DAH_07= @GEM_05;