
SELECT LEFT(A, 6), COUNT(1) FROM
(SELECT CONVERT(CHAR, LOG_04, 112) A, COUNT(1) B FROM  NSADMIN0.DBO.T_LOG(NOLOCK)
WHERE LOG_ID = 'XXXXXX'
AND CONVERT(VARCHAR, LOG_04, 112) BETWEEN '20211001' AND '20211031'
AND LOG_03 <> '::1'
GROUP BY CONVERT(CHAR, LOG_04, 112)) B
GROUP BY LEFT(A, 6)

;

-- 총 건수 구하기
SELECT COUNT(*)
FROM  NSADMIN0.DBO.T_LOG
WHERE 1=1
  AND LOG_ID = 'XXXXXX'
  AND LOG_02 = 'A1'
  AND LOG_03 <> '::1'
  AND CONVERT(VARCHAR, LOG_04, 112) BETWEEN '20211001' AND '20211031';


  select * from NSADMIN0.DBO.T_LOG(NOLOCK) WHERE LOG_ID = 'XXXXXX' and log_03 = '125.136.170.219' and log_04 > '2021-08-01'

select * from t_run where run_99 > '2021-08-01'

 
--  select DATEADD(MI, @random3, run_99) from t_run  where run_99 >'2021-08-01'



  select * from t_run  where run_99 >'2021-08-01'
  select dbo.FN_DATE('20210802','1') 

  merge into t_run a
  using NSADMIN0.DBO.T_LOG(NOLOCK) b
    on b.LOG_01 = a.run_98;


	select * from t_run, NSADMIN0.DBO.T_LOG(NOLOCK) a
	  where t_run.run_98 = a.log_01
	    and t_run.run_id = a.log_id
		and run_99 >'20210801'
		and log_04 >'20210801'
		and a.log_id = 'XXXXXX'

		select DISTINCT * from t_run  inner join  NSADMIN0.DBO.T_LOG(NOLOCK) a
		 on t_run.run_98 = a.log_01
	    and t_run.run_id = a.log_id
		and run_99 >'20210801'
		and log_04 >'20210801'
		and a.log_id = 'XXXXXX'
		AND dbo.fn_date(run_02,'1') =  convert(varchar(10), A.LOG_04, 120)
	

	SELECT * FROM t_run  inner join  NSADMIN0.DBO.T_LOG(NOLOCK) a
		 on t_run.run_98 = a.log_01
	    and t_run.run_id = a.log_id
		and run_99 >'20210801'
		and log_04 >'20210801'
		and a.log_id = 'XXXXXX'
		AND dbo.fn_date(run_02,'1') =  convert(varchar(10), A.LOG_04, 120)
		




    DECLARE @random3 INT = ROUND(((60)*RAND()),0)  -- 로그인 한 시간에서 60분이 지나지 않게 로그기록 설정
	MERGE INTO T_RUN A
	 USING  NSADMIN0.DBO.T_LOG(NOLOCK) B
	   ON A.RUN_98 = B.LOG_01
	  AND A.RUN_ID = B.LOG_ID
	  AND A.RUN_99 >'20210801'
	  AND B.LOG_04 >'2021-08-01'
	  AND B.LOG_ID = 'XXXXXX'
	  AND DBO.FN_DATE(run_02,'1') = CONVERT(varchar(10), B.LOG_04, 120)
	  AND  CONVERT(VARCHAR(8),RUN_99,112)  != A.RUN_02
	 WHEN MATCHED THEN 
	  UPDATE SET A.RUN_99 =  DATEADD(MI, @random3, B.LOG_04) ; -- 로그인 기록 테이블 사용 

	  SELECT * FROM T_RUN WHERE RUN_99 >'2021-08-01'




	    NSADMIN0.DBO.T_LOG(NOLOCK) B 
	  WHERE A.RUN_98 = B.LOG_01
	  AND A.RUN_ID = B.LOG_ID
	    AND A.RUN_99 >'20210801'
	  AND B.LOG_04 >'2021-08-01'
	  AND B.LOG_ID = 'XXXXXX'
	  AND DBO.FN_DATE(run_02,'1') = CONVERT(varchar(10), B.LOG_04, 120)

	  SELECT distinct(run_01),b.log_04 FROM T_RUN A,
	  ( select distinct first_Value(log_04) over(partition by  CONVERT(varchar(10), LOG_04, 120) order by log_04) log_04, log_id , log_01 from   NSADMIN0.DBO.T_LOG(NOLOCK) where log_01 = 'XXXXXX002') B
	  WHERE A.RUN_98 = B.LOG_01
	  AND A.RUN_ID = B.LOG_ID
	    AND A.RUN_99 >'20210801'
	  AND B.LOG_04 >'2021-08-01'
	  and run_98 = 'XXXXXX002'
	  AND B.LOG_ID = 'XXXXXX'
	  AND DBO.FN_DATE(run_02,'1') = CONVERT(varchar(10), LOG_04, 120)



	  select * from 2021-11-10 18:08:40.033


	 DECLARE @random3 INT = ROUND(((60)*RAND()),0)
	MERGE INTO T_RUN A
	 USING  ( select distinct first_Value(log_04) over(partition by  CONVERT(varchar(10), LOG_04, 120) order by log_04) log_04, log_id , log_01 from   NSADMIN0.DBO.T_LOG(NOLOCK) where log_01 = 'XXXXXX002') B
	   ON A.RUN_98 = B.LOG_01
	  AND A.RUN_ID = B.LOG_ID
	  AND A.RUN_99 >'20210801'
       and run_98 = 'XXXXXX002'
	  AND B.LOG_04 >'2021-08-01'
	  AND B.LOG_ID = 'XXXXXX'
	  AND DBO.FN_DATE(run_02,'1') = CONVERT(varchar(10), B.LOG_04, 120)	
	 WHEN MATCHED THEN 
	  UPDATE SET A.RUN_99 =  DATEADD(MI, @random3, B.LOG_04) ;   

	  SELECT * FROM T_RUN WHERE RUN_99 >'2021-08-01'


	  select * from t_run 

	

	
	 select distinct first_Value(log_04) over(partition by  CONVERT(varchar(10), LOG_04, 120) order by log_04) log_04, log_id from   NSADMIN0.DBO.T_LOG(NOLOCK) where log_01 = 'XXXXXX002'

	 select distinct 

	

	
	 DECLARE @random3 INT = ROUND(((8)*RAND()),0)
	MERGE INTO T_ODM A
	 USING  ( select distinct first_Value(log_04) over(partition by  CONVERT(varchar(10), LOG_04, 120) order by log_04) log_04, log_id , log_01 from   NSADMIN0.DBO.T_LOG(NOLOCK) where log_01 = 'XXXXXX002' and LOG_04 >'2021-11-01') B
	   ON A.ODM_98 = B.LOG_01
	  AND A.ODM_ID = B.LOG_ID
	  AND A.ODM_99 >'2021-11-01'
       and ODM_98 = 'XXXXXX002'
	  AND B.LOG_04 >'2021-11-01'
	  AND B.LOG_ID = 'XXXXXX'
	  AND DBO.FN_DATE(ODM_02,'1') = CONVERT(varchar(10), B.LOG_04, 120)	
	 WHEN MATCHED THEN 
	  UPDATE SET A.odm_99 =  DATEADD(MI, @random3, B.LOG_04) ;

	

	 DECLARE @random INT = ROUND(((500)*RAND()),0)
	  merge into t_odd a
	  using t_odm b
	     on a.odd_01 = b.odm_01
		and a.odd_id = b.odm_id
		and b.ODM_99 >'2021-11-01'
		and a.odd_id='XXXXXX'		
	when matched then 
	   update set a.odd_99 = dateadd(ms,@random,b.odm_99);

	

	   	  


	   DECLARE @random3 INT = ROUND(((20)*RAND()),0)
	MERGE INTO T_GEM A
	 USING  ( select distinct first_Value(log_04) over(partition by  CONVERT(varchar(10), LOG_04, 120) order by log_04) log_04, log_id , log_01 from   NSADMIN0.DBO.T_LOG(NOLOCK) where log_01 = 'XXXXXX002' and log_04 > '2021-11-01') B
	   ON A.GEM_98 = B.LOG_01
	  AND A.GEM_ID = B.LOG_ID
	  AND A.GEM_99 >'2021-11-01'
       and gem_98 = 'XXXXXX002'
	  AND B.LOG_04 >'2021-11-01'
	  AND B.LOG_ID = 'XXXXXX'
	  AND DBO.FN_DATE(GEM_02,'1') = CONVERT(varchar(10), B.LOG_04, 120)	
	 WHEN MATCHED THEN 
	  UPDATE SET A.gem_99 =  DATEADD(mi, @random3, B.LOG_04) ;



   DECLARE @random3 INT = ROUND(((5)*RAND()),0)
	MERGE INTO T_LOT A
	 USING  ( select distinct last_Value(log_04) over(partition by  CONVERT(varchar(10), LOG_04, 120) order by CONVERT(varchar(10), LOG_04, 120)) log_04, log_id , log_01 from   NSADMIN0.DBO.T_LOG(NOLOCK) where log_01 = 'XXXXXX002' and log_04 > '2021-08-01') B
	             -- distinct last_value하기 위에서는 over (partion by A order by A ) 에서 A끼리 서로 맞춰줘야 한다.) 그렇지 않으면 여러 개 조회됨(ss,ms가 다르므로)
       ON A.LOT_98 = B.LOG_01
	  AND A.LOT_ID = B.LOG_ID
	  AND A.LOT_99 >'2021-08-01'
       and LOT_98 = 'XXXXXX002'
	  AND B.LOG_04 >'2021-08-01'
	  AND B.LOG_ID = 'XXXXXX'
	  AND DBO.FN_DATE(LOT_02,'1') = CONVERT(varchar(10), B.LOG_04, 120)	
	 WHEN MATCHED THEN 
	  UPDATE SET A.LOT_99 =  DATEADD(mi, @random3, B.LOG_04) ;

	  select * from t_lot where left(lot_1602,2) <'14' and lot_99 > '2021-08-01'
	  update  t_lot set lot_1602 = '17:'+ right(lot_1602,2) where left(lot_1602,2) <'14' and lot_99 > '2021-08-01'
	  select * from t_lot where lot_01 ='L211029-001'

	--  update t_lot set lot_99=DATEADD(day, 1, lot_99) where lot_01 ='L211029-001'


	select * from  NSADMIN0.DBO.T_LOG where log_id ='XXXXXX'
	

	select * from t_lot where lot_99 > '2021-08-01'

	
   DECLARE @ran INT = ROUND(((60)*RAND()),0)
	select dateadd(mi,@ran,'17:20')

	 update t_lot set lot_1501='08:00', lot_1502 ='18:00' where lot_99>'2021-08-01' and  lot_1501='' or lot_1502=''

	 select distinct last_Value(log_04) over(partition by  CONVERT(varchar(10), LOG_04, 120) order by CONVERT(varchar(10), LOG_04, 120)) from  NSADMIN0.DBO.T_LOG where log_id ='XXXXXX' and log_01 = 'XXXXXX002' and log_04 >'2021-11-01'

	

	select * from t_lot where lot_99>'2021-11-01'

	MERGE INTO T_LOT A
	 USING  T_LOT B
	   ON A.LOT_01 = B.LOT_01
	  AND A.LOT_ID = B.LOT_ID
	  AND A.LOT_99 = B.LOT_99
	  AND A.LOT_99 >'2021-08-01'
      and A.LOT_98 = 'XXXXXX002'
	 WHEN MATCHED THEN 
	  UPDATE SET A.LOT_1602 = substring(CONVERT(varchar, B.LOT_99, 120),12,5);

	  select substring(CONVERT(varchar, LOt_99, 120),12,5) from t_lot  where lot_99>'2021-11-01'

	  select substring(CONVERT(varchar, B.LOT_99, 120),12,5) from t_lot  where lot_99>'2021-11-01' AND A.LOT_01 = B.LOT_01


	  
	MERGE INTO T_LOT A
	 USING  T_LOT B
	   ON A.LOT_01 = B.LOT_01
	  AND A.LOT_ID = B.LOT_ID
	  AND A.LOT_99 = B.LOT_99
	  AND A.LOT_99 >'2021-08-01'
      and A.LOT_98 = 'XXXXXX002'
	 WHEN MATCHED THEN 
	  UPDATE SET A.LOT_10 = DATEDIFF(MINUTE,'08:00',B.LOT_1602);


	  select * from NSADMIN0.DBO.T_LOG where log_04 > '2021-11-28' and log_id ='XXXXXX'



	select * from t_lot where lot_01 ='L210804-001'
