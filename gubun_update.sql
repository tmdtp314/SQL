  IF(@GEM_20='A')     -- ODD에서 수정 할 경우
	 BEGIN
	     SELECT @GEM_02=GEM_02, @GEM_03=GEM_03, @GEM_06 = GEM_06 FROM T_GEM WHERE GEM_01 = @GEM_01       
	   
	       UPDATE  T_GEM
		      SET  GEM_02 = @GEM_02,
			       GEM_03 = @GEM_03,
			       GEM_04 = @GEM_04,
			       GEM_05 = @GEM_05,				  
				   GEM_07 = @GEM_05*@GEM_06,
				   GEM_97 = @GEM_97,
				   GEM_98 = @GEM_98
				   
		    WHERE  GEM_ID = @GEM_ID
		      AND  GEM_01 = @GEM_01 	
	 END
	 ELSE BEGIN 

            UPDATE T_GEM  
               SET GEM_02 = @GEM_02  
                  ,GEM_03 = @GEM_03  
                  ,GEM_04 = @GEM_04  
                  ,GEM_05 = @GEM_05  
                  ,GEM_06 = @GEM_06  
                  ,GEM_07 = @GEM_07  
				  ,GEM_11 = @GEM_11  
				  ,GEM_12 = @GEM_12  
                  ,GEM_13 = @GEM_13  
				  ,GEM_19 = @GEM_06 --가용재고 = 수량  
                  ,GEM_97 = @GEM_97  
                  ,GEM_98 = @GEM_98  
                  ,GEM_99 = GETDATE()  
				  ,GEM_20 = @GEM_20  
             WHERE GEM_ID = @GEM_ID  
               AND GEM_01 = @GEM_01  
	END
	