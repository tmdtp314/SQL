
SELECT A.OOK_02,
       STUFF((SELECT '^'+OOK_01 FROM T_OOK WHERE OOK_02 = A.OOK_02 FOR XML PATH ('')),1,1,'') AS OOK_01S, 
       A.OOK_04
  FROM T_OOK AS A 
  GROUP BY OOK_02, OOK_04

  ----------------------  날짜, 품목별로 OOK_01들을 이어 붙임 'O21040200001^O21040200002^O21040200003' << 이런 식으로

