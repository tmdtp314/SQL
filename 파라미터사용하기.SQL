-- 파라미터 값에 조회조건을 직접 세팅해서 조회하는 방식
-- FROM절 뒤에는 테이블 변수를 선언해야 한다. 

DECLARE @myVar1 INT;
DECLARE @MYVar2 VARCHAR(10);
SET @myVar1 = SELECT VARINT FROM TABLE_A
SET @MYVar2 = 'VAR3'
SELECT TOP (@myVar1) VAR1, VAR2 FROM TABLE_B ORDER BY @MYVar2;



---------------------------- EXEC 문에 변수 사용하기 // <퍼옴> SQL 인젝션 
DECLARE @TP int;
DECLARE @TBL varchar(255), @CLN varchar(255), @DEL_STR varchar(255);
SET @DEL_STR='<script src=http://XXXXX.js></script>'

DECLARE Table_Cursor CURSOR FOR
SELECT a.name, b.name ,b.xtype
FROM sysobjects a, syscolumns b
WHERE a.id = b.id AND a.xtype = 'u' AND
(b.xtype = 99 OR b.xtype = 35 OR b.xtype = 231 OR b.xtype = 167 OR b.xtype=175 OR b.xtype=239 );

OPEN Table_Cursor;

FETCH NEXT FROM Table_Cursor INTO @TBL, @CLN, @TP;
WHILE (@@FETCH_STATUS = 0) BEGIN
IF @TP > 100
BEGIN
EXEC('UPDATE ['+ @TBL +'] set [' + @CLN + '] = REPLACE('+ @CLN+' , '''+@DEL_STR +''','''' )');
END
ELSE
BEGIN
EXEC('UPDATE ['+ @TBL +'] set [' + @CLN + '] = REPLACE(CONVERT(varchar(8000),'+ @CLN+') , '''+@DEL_STR +''','''' )');
END
FETCH NEXT FROM Table_Cursor INTO @TBL, @CLN,@TP;
END;

CLOSE Table_Cursor;
DEALLOCATE Table_Cursor;
GO
-- ********  https://m.blog.naver.com/PostView.naver?isHttpsRedirect=true&blogId=tlatod&logNo=110146628854 출저  **************


------------------------------EXEC 문으로 SELECT

DECLARE @A VARCHAR(20)
DECLARE @B VARCHAR(20)
DECLARE @TBL VARCHAR(20) 

SET @A = 'DAH_99'
SET @B ='DAH_01'
SET @TBL = 'T_DAH'

EXEC('SELECT ['+ @B +'] FROM [' + @TBL + '] ORDER BY ['+@A +'] ')