
--CREATE TABLE #LTABLE ( A INT, B DATETIME, C DATETIME, D DATETIME, E DATETIME, F DATETIME, G DATETIME)  -- 최초한번만

--CREATE TABLE #TMPTBL ( A VARCHAR(50) )   -- 최초 한번만 


 TRUNCATE TABLE #LTABLE
 TRUNCATE TABLE #TMPTBL


  DECLARE @Id int
  DECLARE @FromDate datetime
  DECLARE @ToDate datetime

      SET @Id = 1
      SET @FromDate = '2021-08-01'  -- 시작 날짜
      SET @ToDate = '2021-10-31'    -- 끝 날짜

   WHILE(@Id <=650) 
   BEGIN-- 한 650개 생성해보겟다 (여기는 날짜 몇개 만들건지 돌려보면서 조정해주믄됨) 

	    DECLARE @Days INT = DATEDIFF(day, @FromDate, @ToDate)
        DECLARE @RANDOM0 INT = ROUND(((@Days)*RAND()),0)
	    DECLARE @Random INT = ROUND(((20)*RAND()),0)         -- 20 시 (밤 20시까지만 )
	    DECLARE @random2 INT = ROUND(((60)*RAND()),0)    
	    DECLARE @random3 INT = ROUND(((60)*RAND()),0)
	    DECLARE @random4 INT = ROUND(((1000)*RAND()),0)
	    
        INSERT INTO dbo.#LTable
	         VALUES(   @Id, 
	                   DATEADD(day, @RANDOM0, @FromDate), 
	                   CAST(@Id as nvarchar(10)), 
	    			   DATEADD(HH, @Random, @FromDate),  
	    			   DATEADD(MI, @random2, @FromDate), 
	    			   DATEADD(SS, @random3, @FromDate), 
	    			   DATEADD(MS, @random4, @FromDate) 
	    		   )	
	    SET @Id = @Id + 1
    END


 INSERT INTO #TMPTBL
 SELECT CONCAT(
        CONVERT(CHAR(10), B, 23),
        ' ',
    	LEFT((CONVERT(CHAR(10), D, 114)),3),
    	SUBSTRING((CONVERT(CHAR(10), E, 114)),4,2),
    	SUBSTRING((CONVERT(CHAR(10), F, 114)),6,3),
    	'.',
    	RIGHT((CONVERT(CHAR(13), G, 14)),4)) as dates2
 FROM  #LTable 
WHERE  LEFT((CONVERT(CHAR(10), D, 114)),3) between '07' and '19'    -- 7시에서 19시까지만 
  AND  B NOT IN (                                                   -- 제외할 날짜 (토,일,대체공휴일 등등)
                   '2021-10-31', 
                   '2021-10-24', 
                   '2021-10-17',
                   '2021-10-11',
                   '2021-10-10',
                   '2021-10-09',
                   '2021-10-04',
                   '2021-10-03',
                   '2021-09-26',
                   '2021-09-22',
                   '2021-09-21',
                   '2021-09-20',
                   '2021-09-19',
                   '2021-09-12',
                   '2021-09-05',
                   '2021-08-29',
                   '2021-08-22',
                   '2021-08-16',
                   '2021-08-15',
                   '2021-08-08',
                   '2021-08-01')

SELECT * FROM #TMPTBL ORDER BY A DESC 

