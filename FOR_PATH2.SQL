
SELECT
(  SELECT ' ' + MEM_02 -- WKSM_02 = MEM_01
     FROM T_WKSM,T_WKS,NSADMIN0.DBO.T_MEM M 
    WHERE M.MEM_CID = WKS_ID 
      AND M.MEM_CID = WKSM_ID 
      AND WKSM_02 = MEM_01 
      AND WKSM_01 = WKS_01 
      AND A.WKSM_01 = WKSM_01 -- 이거 해줘야지 내가 원하는 결과 (WKS_01에 따른 WKSM_02(MEM_02) 가 연속 이어져서 조회된다.)
      AND MEM_11='Y'          -- MEM_11 조회조건을 여기에다가 써줌 밖에다 써줘도 될지 잘 모르겟음. 성능 차이 모르겟음;
      FOR XML PATH ('')
) MEM_11_NM
FROM T_WKSM A 
LEFT OUTER JOIN T_WKS 
ON WKSM_01 = WKS_01 
GROUP BY WKS_01,WKSM_01