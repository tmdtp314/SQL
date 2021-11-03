		
---------------------------------------------------------------- with문

	WITH CTE(WKSM_01) 
	  AS (
	      SELECT DISTINCT(WKSM_01) 
	        FROM T_WKSM,NSADMIN0.DBO.T_MEM M2               -- 로그인 한 사람 = 담당자 
		   WHERE WKSM_02 = M2.MEM_01 
		     AND M2.MEM_01 LIKE +'%'+@WKS_98+'%'
		     AND M2.MEM_CID = @WKS_ID

			 INTERSECT

	      SELECT DISTINCT(WKSM_01)                           -- 담당자
	        FROM T_WKSM,NSADMIN0.DBO.T_MEM M2 
		   WHERE WKSM_02 = M2.MEM_01 
		     AND (M2. MEM_02 LIKE '%'+@WKS_98_02+'%'OR @WKS_98_02='')
			 AND M2.MEM_CID = @WKS_ID
	     ) 

         SELECT dbo.FN_DATE(T_WKS.WKS_02, '1') AS WKS_02
	    	    ,dbo.FN_DATE(T_WKS.WKS_06, '1') AS WKS_06
	    	    ,WKS_01
				,WKS_05
				,WKS_03
				,WKS_04
				,WKS_08
				,WKS_99				
                ,M.MEM_02
	    		,PCB_02 AS MEM_32_NM
	    		,dbo.FN_WKSM_COLOR(@WKS_ID,WKS_01) as WKSM_LIST
				,dbo.FN_MEM_11('SWENG',WKS_01) as MEM_11_NM
			

          FROM T_WKS  
               INNER JOIN NSADMIN0.dbo.T_MEM M  
                ON WKS_ID = M.MEM_CID  
               AND WKS_98 = M.MEM_01  
			   LEFT OUTER JOIN NSADMIN0.DBO.T_PCB F
                 ON WKS_ID = F.PCB_CID
                AND M.MEM_32 = F.PCB_01  			  
               
         WHERE WKS_ID = @WKS_ID  	
           AND (@WKS_03 = '' OR WKS_03 = @WKS_03)   --구분  
           AND (@WKS_05 = '' OR WKS_05 = @WKS_05)   --분류(DDL)  
           AND (@WKS_04 ='' OR WKS_04 LIKE '%' + @WKS_04 + '%' )     --업무내용  
           AND ((M.MEM_02 LIKE '%' + @WKS_1001 + '%') OR (PCB_02 LIKE'%'+@WKS_1001+'%'))    --요청자  	
		   AND WKS_01 IN (SELECT WKSM_01 FROM CTE)  
	   
         ORDER BY WKS_01 DESC   

         ------------최종 쿼리---------------------- with 문 대신 서브쿼리로 


         IF @GUBUN = 'LIST'  BEGIN   
         SELECT dbo.FN_DATE(T_WKS.WKS_02, '1') AS WKS_02
	    	    ,dbo.FN_DATE(T_WKS.WKS_06, '1') AS WKS_06
	    	    ,WKS_01
				,WKS_05
				,WKS_03
				,WKS_04
				,WKS_08
				,WKS_99				
                ,M.MEM_02
	    		,PCB_02 AS MEM_32_NM
	    		,dbo.FN_WKSM_COLOR(@WKS_ID,WKS_01) as WKSM_LIST
				,dbo.FN_MEM_11('SWENG',WKS_01) as MEM_11_NM
			

          FROM T_WKS  
               INNER JOIN NSADMIN0.dbo.T_MEM M  
                ON WKS_ID = M.MEM_CID  
               AND WKS_98 = M.MEM_01  
			   LEFT OUTER JOIN NSADMIN0.DBO.T_PCB F
                 ON WKS_ID = F.PCB_CID
                AND M.MEM_32 = F.PCB_01  			  
               
         WHERE WKS_ID = @WKS_ID  	
           AND (@WKS_03 = '' OR WKS_03 = @WKS_03)   --구분  
           AND (@WKS_05 = '' OR WKS_05 = @WKS_05)   --분류(DDL)  
           AND (@WKS_04 ='' OR WKS_04 LIKE '%' + @WKS_04 + '%' )     --업무내용  
           AND WKS_01 IN (SELECT DISTINCT(WKSM_01)
		                    FROM T_WKSM, T_WKS,NSADMIN0.DBO.T_MEM M 
						   WHERE MEM_CID = @WKS_ID
						     AND WKSM_01 = WKS_01 
						     AND M.MEM_01 = WKSM_02 							 
							 AND M.MEM_02 LIKE '%'+@WKS_98+'%' )
		   AND WKS_01 IN (SELECT DISTINCT(WKSM_01) 
		                    FROM T_WKSM, T_WKS, NSADMIN0.DBO.T_MEM M, NSADMIN0.DBO.T_PCB F
		                   WHERE MEM_CID=@WKS_ID
						     AND WKSM_01 = WKS_01
						     AND M.MEM_01 = WKSM_02
							 AND M.MEM_32 = F.PCB_01 	
							 AND MEM_CID = PCB_CID
							 AND (M.MEM_02 LIKE '%'+@WKS_98_02+'%' OR F.PCB_02 = @WKS_98_02 OR @WKS_98_02=''))
		   AND (M.MEM_02 LIKE '%'+@WKS_1001+'%' OR F.PCB_02 LIKE '%'+@WKS_1001+'%' OR @WKS_1001 ='')
	   
         ORDER BY WKS_01 DESC   
  