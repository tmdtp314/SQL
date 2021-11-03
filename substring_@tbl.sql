DECLARE @RUN_01 VARCHAR(MAX) 
DECLARE @TMPTBL TABLE ([RUN_01] VARCHAR(20))
DECLARE @i INT 
DECLARE @j INT
DECLARE @k INT
SET @RUN_01 = 'R210831-008R210831-007R210831-009R210831-010'


SET @i = 1 
SET @j= LEN(@RUN_01)/11
SET @k = 1
WHILE (@k<=@j) BEGIN 
	--  PRINT SUBSTRING (@RUN_01,@i,11)
	  INSERT INTO @TMPTBL([RUN_01]) SELECT SUBSTRING(@RUN_01,@i,11)
	  SET @i=11*@k	
   	  SET @i=@i+1
	  SET @k=@k+1
	 
END
 SELECT * FROM T_RUN WHERE RUN_01 IN (SELECT RUN_01 FROM @TMPTBL)



 ------------------------------------------------------------------------------------------------------
DECLARE @RUN_01 VARCHAR(MAX) 
DECLARE @TMPTBL TABLE ([RUN_01] VARCHAR(20), CHECK(LEN(RUN_01)>30)) -- 30이 넘으면 CHECK할 거임 
DECLARE @i INT 
DECLARE @j INT
DECLARE @k INT
SET @RUN_01 = 'R210831-008R210831-007R210831-009R210831-010'

SET @i = 1 
SET @j= LEN(@RUN_01)/11
SET @k = 1
BEGIN TRY 
 BEGIN TRAN 
WHILE (@k<=@j) BEGIN 
	--  PRINT SUBSTRING (@RUN_01,@i,11)
	  INSERT INTO @TMPTBL([RUN_01]) SELECT SUBSTRING(@RUN_01,@i,11)
	  SET @i=11*@k	
   	  SET @i=@i+1
	  SET @k=@k+1
	 
END
COMMIT TRAN 
END TRY 
BEGIN CATCH
 PRINT LEN(@RUN_01)
END CATCH
-- SELECT * FROM T_RUN WHERE RUN_01 IN (SELECT RUN_01 FROM @TMPTBL)

 ------------------------------------------------------------------------------------------------------



