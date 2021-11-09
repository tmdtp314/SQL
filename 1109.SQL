WITH CTE1([품목],[이월수량],[입고수량],[출고수량],[최종재고입/출고일자],[박스당수량]) 
	          AS (      SELECT OOS_02 CHK_01, OOS_03 CHK_0201, 0 CHK_0202, 0 CHK_0203, OOS_04 CHK_03, 0 CHK_04
                          FROM T_OOS (NOLOCK)    
                         WHERE OOS_ID = 'BADAMS'    
                           AND OOS_01 <= LEFT(CONVERT(VARCHAR(8), DATEADD(MONTH, -1, '20211109'), 112), 6)    
    
                        UNION ALL    
                        SELECT OOK_04, OOK_07, 0, 0, 0, 0    
                          FROM T_OOK (NOLOCK)    
                         WHERE OOK_ID = 'BADAMS'    
                           AND OOK_02  BETWEEN LEFT(CONVERT(VARCHAR(8), DATEADD(MONTH, -1, '20211109'), 112), 6) + '32' AND CONVERT(VARCHAR(8), DATEADD(DAY, -1, '20211109'), 112)  
						 
          
                        UNION ALL    
                        SELECT OOK_04, 0, CASE WHEN OOK_06 = 'I' THEN OOK_07 ELSE 0 END, CASE WHEN OOK_06 = 'O' THEN OOK_07 ELSE 0 END, 0, 0    
                          FROM T_OOK (NOLOCK)    
                         WHERE OOK_ID = 'BADAMS'    
                           AND OOK_02  BETWEEN '20211109' AND '20211109'    					  
                             
                             
                        UNION ALL    
                        SELECT DAH_01, 0, 0, 0, 0, DAHB_06  
                          FROM T_DAH (NOLOCK), T_DAHB(NOLOCK)
					     WHERE DAH_ID = DAHB_ID
					       AND DAH_01 = DAHB_01
					       AND DAH_ID = 'BADAMS'
				 ) 
	SELECT
	       (SUM(CTE1.이월수량)+SUM(CTE1.입고수량)+SUM(CTE1.출고수량)) AS OOK_STC, 
	       (SUM(CTE1.이월수량)+SUM(CTE1.입고수량)+SUM(CTE1.출고수량)) * DAH_11 AS OOK_AMT,
		   (SUM(CTE1.박스당수량)) AS  OOK_BOX,
		   DAH_03, DAH_02, DAH_14, DAH_04, DAH_18, DAH_11,DAH_08, DAH_80
	  FROM CTE1 LEFT OUTER JOIN T_DAH 
	    ON DAH_01 = CTE1.품목 LEFT OUTER JOIN T_OOK 
		ON OOK_04 = CTE1.품목 LEFT OUTER JOIN T_CDO 
	    ON DAH_07 = CDO_02
	 WHERE OOK_11 ='001'
	   AND OOK_12 ='002'
	   AND CDO_01 ='GDR'
	   AND DAH_10 = 'Y'    
	


	   GROUP BY DAH_11, DAH_03, DAH_02, DAH_14, DAH_04, DAH_18, DAH_11,DAH_08, DAH_80  
	   HAVING ((SUM(CTE1.이월수량)+SUM(CTE1.입고수량)+SUM(CTE1.출고수량))<DAH_18 OR ''='')
   
  ------------------------------------------------------------------------------- ****** ------------------------------------------------------------------------------
-- 위, 아래 결과 같음. 가독성 다름, READS수 다름 

 SELECT DAH_03, DAH_02, DAH_14, DAH_04, OOK_PREV, OOK_IN, OOK_OUT, OOK_STC, OOK_BOX, DAH_18, DAH_11, OOK_AMT, DAH_08, DAH_80,ISNULL(CDO_03, '') CDO_03  
    FROM (  
     SELECT CHK_01,DAH_02,DAH_03,DAH_14,DAH_04,OOK_PREV,OOK_IN,OOK_OUT,DAH_18,DAH_11,DAH_08,DAH_80,DAH_06,DAH_07, 

               ROUND((OOK_PREV + OOK_IN + OOK_OUT),3) OOK_STC,
               ((OOK_PREV + OOK_IN + OOK_OUT) * DAH_11) OOK_AMT,
			   CASE WHEN CHK_04 > 0 THEN ROUND((OOK_PREV + OOK_IN + OOK_OUT),3) / CHK_04 ELSE ROUND((OOK_PREV + OOK_IN + OOK_OUT),3) END OOK_BOX
          FROM (SELECT CHK_01, ROUND(SUM(CHK_0201),3) OOK_PREV, ROUND(SUM(CHK_0202),3) OOK_IN, ROUND(SUM(CHK_0203),3) OOK_OUT, SUM(CHK_03) CHK_03, SUM(CHK_04) CHK_04,    
                       DAH_01,DAH_11,     
                       DAH_02, DAH_03, DAH_04, DAH_05, DAH_06, DAH_07, DAH_08, DAH_09, DAH_10, DAH_12, DAH_13,    
                       DAH_14, DAH_15, DAH_1601,DAH_1602,DAH_1603,    
                       DAH_17, ROUND(DAH_18,3) DAH_18, DAH_19, DAH_80    
                  FROM (SELECT OOS_02 CHK_01, OOS_03 CHK_0201, 0 CHK_0202, 0 CHK_0203, OOS_04 CHK_03, 0 CHK_04
                          FROM T_OOS (NOLOCK)    
                         WHERE OOS_ID = 'BADAMS'    
                           AND OOS_01 <= LEFT(CONVERT(VARCHAR(8), DATEADD(MONTH, -1, '20211109'), 112), 6)    
    
                        UNION ALL    
                        SELECT OOK_04, OOK_07, 0, 0, 0, 0    
                          FROM T_OOK (NOLOCK)    
                         WHERE OOK_ID = 'BADAMS'    
                           AND OOK_02  BETWEEN LEFT(CONVERT(VARCHAR(8), DATEADD(MONTH, -1, '20211109'), 112), 6) + '32' AND CONVERT(VARCHAR(8), DATEADD(DAY, -1, '20211109'), 112)  
						 
          
                        UNION ALL    
                        SELECT OOK_04, 0, CASE WHEN OOK_06 = 'I' THEN OOK_07 ELSE 0 END, CASE WHEN OOK_06 = 'O' THEN OOK_07 ELSE 0 END, 0, 0    
                          FROM T_OOK (NOLOCK)    
                         WHERE OOK_ID = 'BADAMS'    
                           AND OOK_02  BETWEEN '20211109' AND '20211109'    					  
                             
                             
                        UNION ALL    
                        SELECT DAH_01, 0, 0, 0, 0, DAHB_06  
                          FROM T_DAH (NOLOCK), T_DAHB(NOLOCK)
					     WHERE DAH_ID = DAHB_ID
					       AND DAH_01 = DAHB_01
					       AND DAH_ID = 'BADAMS' ) T_CHK,    
                       
					     T_DAH (NOLOCK)
					     LEFT OUTER JOIN T_OOK(NOLOCK)
					     ON OOK_04 = DAH_01 
                WHERE DAH_ID = 'BADAMS'    
                  AND DAH_01  = CHK_01    
				  AND OOK_04 = CHK_01
				  AND OOK_11 = '001'
				  AND OOK_12 = '002'
                GROUP BY CHK_01, DAH_02, DAH_03, DAH_04, DAH_05, DAH_06, DAH_07, DAH_08, DAH_09, DAH_10,  DAH_11, DAH_12, DAH_13,    
                         DAH_14, DAH_15, DAH_1601, DAH_1602, DAH_1603, DAH_01,    
           DAH_17, DAH_18, DAH_19, DAH_80 ) T_OOK  
		   WHERE DAH_10 = 'Y'                
        
              AND ('' = '' OR DAH_03 = '') 
              AND ('' = '' OR DAH_06 = '')            
              AND ('' = '' OR DAH_07 = '')   			 
              AND ('' = '' OR DAH_08 = '') ) AAAA,  
         T_CDO (NOLOCK)  
         WHERE 'BADAMS' = CDO_ID     
              AND CDO_01 = 'GDR'     
              AND CDO_02 = DAH_07  
              AND ( '' = '' OR OOK_STC < DAH_18 )  
         ORDER BY DAH_06, CHK_01   



