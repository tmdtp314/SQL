
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

----------------------------------------------------------------------------------------


--CREATE TABLE #LTABLE ( A INT, B DATETIME, C varchar(20), D DATETIME, E DATETIME, F DATETIME, G DATETIME)  -- 최초한번만

--CREATE TABLE #TMPTBL ( A VARCHAR(50) )   -- 최초 한번만 


 TRUNCATE TABLE #LTABLE
 TRUNCATE TABLE #TMPTBL


  DECLARE @Id int
  DECLARE @FromDate datetime
  DECLARE @ToDate datetime

      SET @Id = 1
      SET @FromDate = '2021-08-01'  -- 시작 날짜
      SET @ToDate = '2021-12-01'    -- 끝 날짜

   WHILE(@Id <=000) 
   BEGIN-- 한 650개 생성해보겟다 (여기는 날짜 몇개 만들건지 돌려보면서 조정해주믄됨) 

	    DECLARE @Days INT = DATEDIFF(day, @FromDate, @ToDate)
        DECLARE @RANDOM0 INT = ROUND(((@Days)*RAND()),0)
	    DECLARE @Random INT = ROUND(((30)*RAND()),0)         -- 20 시 (밤 20시까지만 )
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
WHERE  LEFT((CONVERT(CHAR(10), D, 114)),3) between '17' and '19'    -- 7시에서 19시까지만 
  AND  B IN (  
'2021-08-04',
'2021-08-07',
'2021-08-10',
'2021-08-13',
'2021-08-18',
'2021-08-21',
'2021-08-25',
'2021-08-27',
'2021-08-31',
'2021-09-01',
'2021-09-03',
'2021-09-10',
'2021-09-15',
'2021-09-18',
'2021-09-23',
'2021-09-25',
'2021-09-30',
'2021-10-06',
'2021-10-08',
'2021-10-15',
'2021-10-18',
'2021-10-20',
'2021-10-23',
'2021-10-29',
'2021-11-01',
'2021-11-02',
'2021-11-04',
'2021-11-08',
'2021-11-10',
'2021-11-15',
'2021-11-18',
'2021-11-22',
'2021-11-26'
  )


SELECT distinct first_value(a) over(partition by left(a, 10) order by a)  FROM #TMPTBL 



-----------------------------------------------------------


--CREATE TABLE #LTABLE ( A INT, B DATETIME, C varchar(20), D DATETIME, E DATETIME, F DATETIME, G DATETIME)  -- 최초한번만

--CREATE TABLE #TMPTBL ( A VARCHAR(50) )   -- 최초 한번만 


 TRUNCATE TABLE #LTABLE
 TRUNCATE TABLE #TMPTBL


  DECLARE @Id int
  DECLARE @FromDate datetime
  DECLARE @ToDate datetime

      SET @Id = 1
      SET @FromDate = '2021-11-01'  -- 시작 날짜
      SET @ToDate = '2021-11-30'    -- 끝 날짜

While(@Id <=1400)
Begin
	DECLARE @Days INT = DATEDIFF(day, @FromDate, @ToDate)
    DECLARE @RANDOM0 INT = ROUND(((@Days)*RAND()),0)
	DECLARE @Random INT = ROUND(((20)*RAND()),0)
	declare @random2 int = ROUND(((@Days)*RAND()),0)
	declare @random3 int = ROUND(((@Days)*RAND()),0)
	declare @random4 int = ROUND(((@Days)*RAND()),0)




    Insert into dbo.#LTable values(@Id, DATEADD(day, @RANDOM0, @FromDate), 
	CAST(@Id as nvarchar(10)), DATEADD(hh, @Random, @FromDate),  DATEADD(mi, @random2, @FromDate), DATEADD(sS, @random3, @FromDate), DATEADD(mS, @random4, @FromDate) )
	
    Print @Id
	Set @Id = @Id + 1
End



--SELECT * FROM dbo.#LTable

INSERT INTO #TMPTBL
select CONCAT(
      CONVERT(CHAR(10), B, 23),
	  ' ',
	  LEFT((CONVERT(CHAR(10), D, 114)),3),
	--  CASE WHEN CONVERT(INT,LEFT((CONVERT(CHAR(10), D, 114)),2)) >19 THEN CONVERT(INT,LEFT((CONVERT(CHAR(10), D, 114)),2))-7  else  CONVERT(INT,LEFT((CONVERT(CHAR(10), D, 114)),2)) end,
	--  ':',
	  SUBSTRING((CONVERT(CHAR(10), E, 114)),4,2),
	  SUBSTRING((CONVERT(CHAR(10), F, 114)),6,3),
	  '.',
	  RIGHT((CONVERT(CHAR(13), G, 14)),4)) as dates2
 FROM  #LTable 
 where LEFT((CONVERT(CHAR(10), D, 114)),3) between '08' and '20'
   and  b not in (  
'2021-11-07',
'2021-11-06',
'2021-11-13',
'2021-11-14',
'2021-11-20',
'2021-11-21',
'2021-11-27',
'2021-11-28'
  )
   order by dates2 desc

SELECT * FROM #TMPTBL