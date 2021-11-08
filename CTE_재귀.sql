WITH CTE(EMPNAME, MGRNAME, DEPT, [LEVEL])
  AS 
  (SELECT EMP, MANAGER, DEPARTMENT, 0
     FROM EMPTBL 
    WHERE MANAGER IS NULL                            -- 앵커문 초기화

    UNION ALL 

   SELECT EMPTBL.EMP, EMPTBL.MANAGER, EMPTBL.DEPARTMENT, CTE.[LEVEL]+1 
     FROM EMPTBL
    INNER JOIN CTE ON EMPTBL.MANAGER=CTE.EMPNAME     -- 재귀문 FOR문과 같은 효과를 가짐 
  )
  SELECT * FROM CTE ORDER BY DEPT [LEVEL];           -- 트리 구조의 LEVEL표기 



------------------------------------------
  1. 앵커문 실행 (초기화, 한 줄)
  2. 재귀문 실행
     - 앵커문(초기문)과 조인한 결과 실행 (레벨1)
     - 위의 실행결과와 조인한 결과 실행 (레벨2)
     - 위의 실행결과와 조인한 결과 시행 (레벨3) 
     - union all 되어 결과 조회 



----------------------------------------------------------------
  WITH CTE(BOM_01,BOM_03,[LEVEL])
  AS 
  (SELECT BOM_01,BOM_07, 1[LEVEL]
     FROM T_BOM  
    UNION ALL 

   SELECT B.BOM_01,B.BOM_07, CTE.[LEVEL]+1 
     FROM T_BOM B		
     INNER JOIN CTE ON B.BOM_07=CTE.BOM_01     
  )
  SELECT BOM_03[ROOT],BOM_01 [SUB],[LEVEL] FROM CTE WHERE [LEVEL]>1

  -- ROOT를 만들기 위해 SUB가 들어간다 
  -- 또 SUB를 만들기 위한 SUB가 있다면 LEVEL이 증가해서 표시
  -- 트리구조 


  --------------WITH문 여러번 쓰기-------------------  >> ','로 구분하여 사용!! 
  WITH CTE(TBL_01, TBL_02)
        AS (SELECT A_01, A_02 FROM T_A 
            INTERSECT
            SELECT B_01, B_02 FROM T_B)
      ,CTE2(TBL_03,TBL_04)
        AS (SELECT C_01, C_02 FROM T_C 
            UNION ALL
            SELECT D_01, D_02 FROM T_D);
  
     SELECT TBL_01,TBL_02 FROM CTE 
  INTERSECT 
     SELECT TBL_03,TBL_04 FROM CTE2
    