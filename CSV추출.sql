--활성화 여부 체크--
SELECT * FROM sys.configurations WHERE name = 'xp_cmdshell'

-----------------------------------------------------------------------
 -- xp_cmdshell활성화 
EXEC sp_configure 'show advanced options', 1
GO

RECONFIGURE
GO

EXEC sp_configure 'xp_cmdshell', 1
GO

RECONFIGURE
GO

----------------------------------------------------------------------
-- xp_cmdshell 비활성화

EXEC sp_configure 'xp_cmdshell', 0
GO

RECONFIGURE
GO

EXEC sp_configure 'show advanced options', 0
GO

RECONFIGURE
GO
----------------------------------------------------------------------

DECLARE @query VARCHAR(MAX)
SET @query = 'BCP "SELECT * FROM NSZ04503.dbo.T_QCD" queryout "C:\SQL_tables.csv" -c -t, -U sa -P !h2876633'
EXEC MASTER..xp_cmdshell @query