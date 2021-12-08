SELECT   LOTP_02
							,DAH_01
							,DAH_02
							,LOTP_04
							,LOTP_05
							,TH_LEN
							,GRADE_1
							,GRADE_2
							,GRADE_3
							,GRADE_4
							,GRADE_5
							,GRADE_6
							,GRADE_7
							,GRADE_8
							,GRADE_9
							,PRODUCT_SUM -- 제품계
							,GOODS_SUM -- 정품계
							,PRODUCT_SUM + BY_PRODUCT_SUM AS PRODUCTION_SUM -- 생산계 = 제품계 + 부산물계
							,MAT_SUM + SUB_SUM_01 AS INPUT_SUM--+ SUB_SUM_02  -- 투입계 = 원자재 + 부자재(이론)
							,MAT_SUM 
							,SUB_SUM_01
							,CASE WHEN GUBUN ='A' THEN SUB_SUM_02 ELSE 0 END SUB_SUM_02
							,SUB_SUM_03
							,BY_PRODUCT_SUM
							,SCRAP_TOP
							,SCRAP_END
							,DROSS
							,ROUND(CASE WHEN GUBUN ='A' THEN (PRODUCT_SUM + BY_PRODUCT_SUM)/(MAT_SUM + SUB_SUM_01)*100 ELSE 0 END,2) AS RATE_01 -- 실수율
							,(PRODUCT_SUM+ BY_PRODUCT_SUM) / (MAT_SUM + SUB_SUM_01) * 100 RATE_02 -- 총수율
							,CASE WHEN GOODS_SUM != 0 THEN GOODS_SUM/(PRODUCT_SUM + BY_PRODUCT_SUM)*100 ELSE 0 END AS RATE_03 -- 주문합격률
							,ROUND(CASE WHEN GUBUN ='A' THEN (GOODS_SUM/(MAT_SUM + SUB_SUM_01))*100 ELSE 0 END,2) AS RATE_04 -- 주문수율
							,CASE WHEN GUBUN ='A' THEN (GOODS_SUM/MAT_SUM)*100 ELSE 0 END AS RATE_05 -- 주문수율 -- 정품수율
							,CASE WHEN GUBUN ='B' THEN SUB_SUM_02/(SUB_SUM_01 - DROSS)*100 ELSE 0  END AS RATE_06 -- 도금부착률
							,(CASE WHEN DROSS = 0 THEN 0 ELSE DROSS/SUB_SUM_01 END)*100  AS RATE_07

							, PRODUCT_SUM + BY_PRODUCT_SUM AS RATE_02_2

					  FROM (
								 
								SELECT   CASE WHEN @CHK_DIM_YN ='Y' THEN '' ELSE  LOTP_02 END  AS LOTP_02
										,CASE WHEN @CHK_DIM_YN ='Y' THEN '' ELSE  DAH_01 END  AS DAH_01 
										,CASE WHEN @CHK_DIM_YN ='Y' THEN '' ELSE  DAH_02 END  AS DAH_02 
										, LOTP_04 --두께
										, LOTP_05 --폭
										, 'C' TH_LEN--길이
										, SUM(GRADE_1) AS  GRADE_1
										, 0 GRADE_2 --2등급
										, SUM(GRADE_3) GRADE_3 --3등급
										, 0 GRADE_4 --4등급 
										, 0 GRADE_5 --5등급
										, 0 GRADE_6 --6등급
										, 0 GRADE_7 --7등급 
										, 0 GRADE_8 --8등급
										, SUM(GRADE_9) AS GRADE_9

										, SUM(GRADE_1 + GRADE_3 + GRADE_9)     AS PRODUCT_SUM -- 제품계.
										, SUM(GOODS_SUM) AS GOODS_SUM -- 정품계
										, 0 AS PRODUCTION_SUM  -- 생산계
										, 0 AS INPUT_SUM -- 투입계
										, SUM(MAT_SUM) AS MAT_SUM -- 원자재
										, 0 AS SUB_SUM_01 -- 부자재(실제)
										, SUM(SUB_SUM_02) AS SUB_SUM_02 -- 부자재(이론)
										, SUM(SUB_SUM_03) AS SUB_SUM_03
										, 0 AS BY_PRODUCT_SUM -- 부산물계

										, 0 AS SCRAP_TOP
										, 0 AS SCRAP_END
										, 0 AS DROSS

										, 'A' AS GUBUN
									FROM
									(
										SELECT   dbo.FN_DATE(LOTP_02,'1') AS LOTP_02
												,DAH_01, DAH_02, DAH_14,  LOTP_04, LOTP_05 , 'C' TH_LEN--길이

												,SUM(CASE WHEN QYM_07 ='1' THEN  QYM_08 ELSE 0 END ) GRADE_1
												,SUM(CASE WHEN QYM_07 ='3' THEN  QYM_08 ELSE 0 END ) GRADE_3
												,SUM(CASE WHEN QYM_07 ='9' THEN  QYM_08 ELSE 0 END ) GRADE_9
												,SUM(CASE WHEN QYM_07 IN ('1','3') THEN  QYM_08 ELSE 0 END ) GOODS_SUM
												, dbo.FN_STA_MAT_SUM2(LOTP_02, DAH_01, LOTP_04, LOTP_05, @LOTA_05) AS MAT_SUM
												, dbo.FN_STA_LOTS_SUM(LOTP_02,DAH_01,'ZN-1', LOTP_04, LOTP_05, @LOTA_05)  AS SUB_SUM_02
												, dbo.FN_STA_MAT_SUM3(LOTP_02, DAH_01, DAH_14,  LOTP_04, LOTP_05, @LOTA_05 ) AS SUB_SUM_03

											FROM  T_LOTP(NOLOCK), T_QYM(NOLOCK) , T_LOTA(NOLOCK), T_DAH(NOLOCK), T_OOK(NOLOCK), T_OOL(NOLOCK)
 
											where 1=1 
											AND QYM_02   =  LOTP_01
											AND QYM_11   = 'Y'
											AND LOTP_02 BETWEEN @LOTP_02_ST AND @LOTP_02_ED
											AND LEFT(LOTP_16,3) = 'CGL'
											AND LOTA_08  = LOTP_16
											AND LOTA_09  = LOTP_23
											AND LOTA_01 = LOTP_17
											AND LOTA_03 = DAH_01
											AND LOTP_03 = OOK_04
											AND OOK_01 = OOL_01
											AND (@LOTA_05 = '' OR LOTA_05 = @LOTA_05)
											AND (@OOK_32 = '' OR OOL_26 LIKE '%' + @OOK_32 + '%')
											GROUP BY  LOTP_02, DAH_01,DAH_02,  DAH_14,  LOTP_04, LOTP_05 
									) Z

									GROUP BY CASE WHEN @CHK_DIM_YN ='Y' THEN '' ELSE  Z.LOTP_02 END 
											,CASE WHEN @CHK_DIM_YN ='Y' THEN '' ELSE  Z.DAH_01 END   
											,CASE WHEN @CHK_DIM_YN ='Y' THEN '' ELSE  Z.DAH_02 END  
											,LOTP_04 , LOTP_05 
						 UNION ALL
								   SELECT CASE WHEN @CHK_DIM_YN='Y' THEN '' ELSE  LOTP_02  END AS LOTP_02            
										, CASE WHEN @CHK_DIM_YN='Y' THEN '' ELSE  'xx-etc' END AS DAH_01            
										, CASE WHEN @CHK_DIM_YN='Y' THEN '' ELSE '스크랩 외' END AS DAH_02          
										, 0 LOTP_04--두께           
										, 0 LOTP_05--폭     
								
										, '' TH_LEN--길이                
										, 0 GRADE_1 -- 1등급           
										, 0 GRADE_2 -- 1등급           
										, 0 GRADE_3 -- 1등급          
										, 0 GRADE_4 -- 1등급           
										, 0 GRADE_5 -- 1등급           
										, 0 GRADE_6 -- 1등급           
										, 0 GRADE_7 -- 1등급           
										, 0 GRADE_8 -- 1등급           
										, 0 GRADE_9 -- 1등급          
										, 0 AS PRODUCT_SUM -- 제품계          
										, 0 AS GOODS_SUM -- 정품계             
										,SUM(PRODUCTION_SUM) PRODUCTION_SUM           
										,SUM(INPUT_SUM) INPUT_SUM           
										,SUM(MAT_SUM) as MAT_SUM           
										,SUM(SUB_SUM_01) as SUB_SUM_01           
										,SUM(SUB_SUM_02) as SUB_SUM_02           
										,0 SUB_SUM_03           
										,SUM(BY_PRODUCT_SUM) BY_PRODUCT_SUM           
										,SUM(SCRAP_TOP) AS SCRAP_TOP          
										,SUM(SCRAP_END) AS SCRAP_END           
										,SUM(DROSS) AS DROSS  ,

										'B' AS GUBUN       
								
										FROM
										(
												SELECT    dbo.FN_DATE(LOTP_02,'1') AS LOTP_02            
														, DAH_01            
														, DAH_02                      
														, PRODUCTION_SUM PRODUCTION_SUM           
														, INPUT_SUM INPUT_SUM           
														, MAT_SUM as MAT_SUM           
														, SUB_SUM_01
														, SUB_SUM_02

														,BY_PRODUCT_SUM BY_PRODUCT_SUM           
														,SCRAP_TOP AS SCRAP_TOP          
														,SCRAP_END AS SCRAP_END           
														,DROSS AS DROSS  
													FROM     
													(                
														SELECT OOZ_02 AS LOTP_02            
															, 'xx-etc'  AS DAH_01            
															, '스크랩 외' AS DAH_02                        
															, SUM(OOZ_08)  AS PRODUCTION_SUM  -- 생산계             
															, SUM(OOZ_08)  AS INPUT_SUM -- 투입계             
															, 0 AS MAT_SUM -- 원자재             
															, (   
																SELECT SUM(LOTZ_05)               
																	FROM T_LOTZ(NOLOCK)               
																WHERE 1=1  
																  AND LOTZ_01 = OOZ_02              
																  AND LOTZ_03 IN ('ZN-1', 'AL-1')               
																  AND (@LOTA_05 = '' OR LOTZ_02 = @LOTA_05)
															) AS SUB_SUM_01 -- 부자재(실제)             
	   
															, (   SELECT ISNULL(SUM(LOTS_07),0)               
																	FROM T_LOTS(NOLOCK),T_LOTA(NOLOCK)               
																WHERE LOTS_03 IN ('ZN-1', 'AL-1')               
																	AND LOTA_01 = LOTS_11
																	AND LOTS_02 = OOZ_02 
																	AND (@LOTA_05 = '' OR LOTA_05 = @LOTA_05)
															) AS SUB_SUM_02 -- 부자재(이론)  
															, 0 SUB_SUM_03             
															, SUM(OOZ_08) AS BY_PRODUCT_SUM -- 부산물계               
															, SUM(CASE WHEN OOZ_04 ='A' THEN OOZ_08 ELSE  0 END )  AS SCRAP_TOP  -- 스크랩 TOP             
															, SUM(CASE WHEN OOZ_04 ='B' THEN OOZ_08 ELSE  0 END )  AS SCRAP_END  -- 스크랩 END            
															, SUM(CASE WHEN OOZ_04 ='C' THEN OOZ_08 ELSE  0 END )  AS DROSS      -- 스크랩 DROSS               
						
															FROM T_OOZ(NOLOCK)
														WHERE 1=1              
															AND OOZ_12 = LEFT('CGL',3)             
															AND OOZ_02 BETWEEN  @LOTP_02_ST AND @LOTP_02_ED
															AND (@LOTA_05 = '' OR OOZ_11 = @LOTA_05)
														GROUP BY OOZ_02
													) Z              
										) ZZ
								
										GROUP BY  CASE WHEN @CHK_DIM_YN  ='Y' THEN '' ELSE LOTP_02 END            

						 ) A

						 ORDER BY CASE WHEN GUBUN ='A' THEN 1 ELSE 2 END , LOTP_02 , DAH_01, LOTP_04, LOTP_05 DESC