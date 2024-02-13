USE [system]
GO
/****** Object:  StoredProcedure [dbo].[CompareCode]    Script Date: 13/02/2024 08:54:02 ******/
DROP PROCEDURE [dbo].[CompareCode]
GO
/****** Object:  View [dbo].[vCompare]    Script Date: 13/02/2024 08:54:02 ******/
DROP VIEW [dbo].[vCompare]
GO
/****** Object:  View [dbo].[TESTCODE]    Script Date: 13/02/2024 08:54:02 ******/
DROP VIEW [dbo].[TESTCODE]
GO
/****** Object:  View [dbo].[DEVCODE]    Script Date: 13/02/2024 08:54:02 ******/
DROP VIEW [dbo].[DEVCODE]
GO
/****** Object:  View [dbo].[SQLCODE]    Script Date: 13/02/2024 08:54:02 ******/
DROP VIEW [dbo].[SQLCODE]
GO
/****** Object:  UserDefinedFunction [dbo].[GetCode]    Script Date: 13/02/2024 08:54:02 ******/
DROP FUNCTION [dbo].[GetCode]
GO
/****** Object:  UserDefinedFunction [dbo].[procTrigger]    Script Date: 13/02/2024 08:54:02 ******/
DROP FUNCTION [dbo].[procTrigger]
GO
/****** Object:  UserDefinedFunction [dbo].[frmcolTrigger]    Script Date: 13/02/2024 08:54:02 ******/
DROP FUNCTION [dbo].[frmcolTrigger]
GO
/****** Object:  UserDefinedFunction [dbo].[frmTrigger]    Script Date: 13/02/2024 08:54:02 ******/
DROP FUNCTION [dbo].[frmTrigger]
GO
/****** Object:  UserDefinedFunction [dbo].[frmTrigger]    Script Date: 13/02/2024 08:54:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Si
-- Create date: 6/2/2024
-- Description:	form column trigger
-- =============================================
CREATE FUNCTION [dbo].[frmTrigger]
(
	 @ENAME VARCHAR(32)	 
	 , @TNAME VARCHAR(32)
)
RETURNS VARCHAR(MAX)
AS
BEGIN

	DECLARE @combinedString VARCHAR(MAX)
	SELECT @combinedString = STRING_AGG (CONVERT(NVARCHAR(MAX),dbo.FORMTRIGTEXT.TEXT),'\n')
	WITHIN GROUP (ORDER BY dbo.FORMTRIGTEXT.TEXTORD)

	FROM            dbo.FORMTRIGTEXT INNER JOIN
                         dbo.T$EXEC INNER JOIN
                         dbo.FORMTRIG INNER JOIN
                         dbo.TRIGGERS ON dbo.FORMTRIG.TRIG = dbo.TRIGGERS.TRIG ON dbo.T$EXEC.T$EXEC = dbo.FORMTRIG.FORM ON dbo.FORMTRIGTEXT.TRIG = dbo.TRIGGERS.TRIG
	WHERE        (dbo.T$EXEC.TYPE = N'F') 	
	AND dbo.FORMTRIGTEXT.FORM = dbo.T$EXEC.T$EXEC
	AND (dbo.T$EXEC.TYPE = N'F')
	AND  dbo.T$EXEC.ENAME = @ENAME	
	AND dbo.TRIGGERS.TRIGNAME = @TNAME
	
	RETURN @combinedString
END
/*

	select dbo.frmTrigger( 'ZCLA_ELACT' , 'PRE-FORM' )
	

*/
GO
/****** Object:  UserDefinedFunction [dbo].[frmcolTrigger]    Script Date: 13/02/2024 08:54:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Si
-- Create date: 6/2/2024
-- Description:	form column trigger
-- =============================================
CREATE FUNCTION [dbo].[frmcolTrigger]
(
	 @ENAME VARCHAR(32)
	 , @CNAME VARCHAR(32)
	 , @TNAME VARCHAR(32)
)
RETURNS VARCHAR(MAX)
AS
BEGIN

	DECLARE @combinedString VARCHAR(MAX)

	SELECT @combinedString = STRING_AGG (CONVERT(NVARCHAR(MAX),dbo.FORMCLTRIGTEXT.TEXT),'\n')
	WITHIN GROUP (ORDER BY dbo.FORMCLTRIGTEXT.TEXTORD)
	FROM            dbo.FORMCLTRIGTEXT INNER JOIN
					dbo.COLUMNS INNER JOIN
					dbo.FORMCLTRIG INNER JOIN
					dbo.T$EXEC INNER JOIN
					dbo.FORMCLMNS ON dbo.T$EXEC.T$EXEC = dbo.FORMCLMNS.FORM ON dbo.FORMCLTRIG.FORM = dbo.T$EXEC.T$EXEC AND dbo.FORMCLTRIG.NAME = dbo.FORMCLMNS.NAME INNER JOIN
					dbo.TRIGGERS ON dbo.FORMCLTRIG.TRIG = dbo.TRIGGERS.TRIG ON dbo.COLUMNS.T$COLUMN = dbo.FORMCLMNS.T$COLUMN ON dbo.FORMCLTRIGTEXT.FORM = dbo.FORMCLMNS.FORM AND 
					dbo.FORMCLTRIGTEXT.TRIG = dbo.TRIGGERS.TRIG AND dbo.FORMCLTRIGTEXT.NAME = dbo.FORMCLTRIG.NAME
	WHERE        (dbo.T$EXEC.T$EXEC > 0) 
	AND dbo.FORMCLTRIGTEXT.FORM = dbo.T$EXEC.T$EXEC
	AND (dbo.T$EXEC.TYPE = N'F')
	AND  dbo.T$EXEC.ENAME = @ENAME
	AND dbo.FORMCLMNS.NAME = @CNAME
	AND dbo.TRIGGERS.TRIGNAME = @TNAME
	
	return @combinedString

END
/*
	select dbo.frmcolTrigger( 'ZCLA_ELACT' , 'STATDES' , 'POST-FIELD' )
	SET @ENAME = 'ZCLA_ELACT'
	SET @CNAME = 'STATDES'
	SET @TNAME = 'POST-FIELD'

*/
GO
/****** Object:  UserDefinedFunction [dbo].[procTrigger]    Script Date: 13/02/2024 08:54:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Si
-- Create date: 6/2/2024
-- Description:	form column trigger
-- =============================================
CREATE FUNCTION [dbo].[procTrigger]
(
	 @ENAME VARCHAR(32)
	 , @POS INT
)
RETURNS VARCHAR(MAX)
AS
BEGIN

	DECLARE @combinedString VARCHAR(MAX)

	SELECT @combinedString = STRING_AGG (CONVERT(NVARCHAR(MAX),dbo.PROGRAMSTEXT.TEXT),'\n')
	WITHIN GROUP (ORDER BY dbo.PROGRAMSTEXT.TEXTORD)
	FROM            dbo.PROGRAMSTEXT INNER JOIN
							 dbo.T$EXEC INNER JOIN
							 dbo.T$EXEC AS RUN INNER JOIN
							 dbo.PROGRAMS ON RUN.T$EXEC = dbo.PROGRAMS.EXECRUN ON dbo.T$EXEC.T$EXEC = dbo.PROGRAMS.T$EXEC ON dbo.PROGRAMSTEXT.PROG = dbo.PROGRAMS.PROG
	WHERE        (dbo.T$EXEC.TYPE = N'P') AND (dbo.T$EXEC.T$EXEC > 0) AND (RUN.ENAME = N'SQLI')

	and POS = @POS
	AND dbo.T$EXEC.ENAME = @ENAME
	
	return @combinedString

END
/*
	select dbo.frmcolTrigger( 'ZCLA_ELACT' , 'STATDES' , 'POST-FIELD' )
	SET @ENAME = 'ZCLA_ELACT'
	SET @CNAME = 'STATDES'
	SET @TNAME = 'POST-FIELD'

*/
GO
/****** Object:  UserDefinedFunction [dbo].[GetCode]    Script Date: 13/02/2024 08:54:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Si
-- Create date: 6/2/2024
-- Description: Build Code for instance
-- =============================================
CREATE FUNCTION [dbo].[GetCode] ()
RETURNS TABLE 
AS
RETURN 
(
	SELECT @@servername as [SERVER],
		   'C' as [TYPE],
		   dbo.T$EXEC.ENAME      AS FORM,
		   dbo.FORMCLMNS.NAME    AS [COLUMN],
		   dbo.TRIGGERS.TRIGNAME AS [TRIGGER],
		   dbo.FORMCLTRIG.TDATE,
		   dbo.USERS.USERLOGIN,
		   dbo.frmcolTrigger(dbo.T$EXEC.ENAME, dbo.FORMCLMNS.NAME, dbo.TRIGGERS.TRIGNAME) as CODE
	FROM   dbo.COLUMNS
		   INNER JOIN dbo.FORMCLTRIG
					  INNER JOIN dbo.T$EXEC
								 INNER JOIN dbo.FORMCLMNS
										 ON dbo.T$EXEC.T$EXEC = dbo.FORMCLMNS.FORM
							  ON dbo.FORMCLTRIG.FORM = dbo.T$EXEC.T$EXEC
								 AND dbo.FORMCLTRIG.NAME = dbo.FORMCLMNS.NAME
					  INNER JOIN dbo.TRIGGERS
							  ON dbo.FORMCLTRIG.TRIG = dbo.TRIGGERS.TRIG
				   ON dbo.COLUMNS.T$COLUMN = dbo.FORMCLMNS.T$COLUMN
		   LEFT OUTER JOIN dbo.USERS
						ON dbo.FORMCLTRIG.T$USER = dbo.USERS.T$USER
	WHERE  ( dbo.T$EXEC.T$EXEC > 0 )
		   AND ( dbo.FORMCLTRIG.TDATE > 0 )
		   AND ( dbo.T$EXEC.TYPE = N'F' )
	union all
	SELECT @@servername,
		   dbo.T$EXEC.TYPE,
		   dbo.T$EXEC.ENAME      AS FORM,
		   ''                    AS [COLUMN],
		   dbo.TRIGGERS.TRIGNAME AS [TRIGGER],
		   dbo.FORMTRIG.TDATE,
		   USERS.USERLOGIN,
		   dbo.frmTrigger(dbo.T$EXEC.ENAME, dbo.TRIGGERS.TRIGNAME)
	from   dbo.T$EXEC
		   INNER JOIN dbo.FORMTRIG
					  INNER JOIN dbo.TRIGGERS
							  ON dbo.FORMTRIG.TRIG = dbo.TRIGGERS.TRIG
				   ON dbo.T$EXEC.T$EXEC = dbo.FORMTRIG.FORM
		   LEFT OUTER JOIN dbo.USERS
						ON dbo.FORMTRIG.T$USER = dbo.USERS.T$USER
	WHERE  ( dbo.T$EXEC.T$EXEC > 0 )
		   AND ( dbo.T$EXEC.TYPE = N'F' )
	union all
	SELECT TOP (100) PERCENT @@SERVERNAME                           AS Expr2,
							 dbo.T$EXEC.TYPE,
							 dbo.T$EXEC.ENAME                       AS FORM,
							 ''                                     AS [COLUMN],							 
							 'STEP ' + Ltrim(Str(dbo.PROGRAMS.POS)) AS [TRIGGER],
							 0,
							 '',
							 dbo.procTrigger(dbo.T$EXEC.ENAME, dbo.PROGRAMS.POS)
	FROM   dbo.T$EXEC
		   INNER JOIN dbo.T$EXEC AS RUN
					  INNER JOIN dbo.PROGRAMS
							  ON RUN.T$EXEC = dbo.PROGRAMS.EXECRUN
				   ON dbo.T$EXEC.T$EXEC = dbo.PROGRAMS.T$EXEC
	WHERE  ( dbo.T$EXEC.TYPE = N'P' )
		   AND ( dbo.T$EXEC.T$EXEC > 0 )
		   AND ( RUN.ENAME = N'SQLI' ) 
)
GO
/****** Object:  View [dbo].[SQLCODE]    Script Date: 13/02/2024 08:54:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[SQLCODE]
AS
SELECT        SERVER, TYPE, FORM, [COLUMN], [TRIGGER], TDATE, USERLOGIN, CODE
FROM            dbo.GetCode() AS GetCode_1
GO
/****** Object:  View [dbo].[DEVCODE]    Script Date: 13/02/2024 08:54:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[DEVCODE]
AS
SELECT        SERVER, TYPE, FORM, [COLUMN], [TRIGGER], TDATE, USERLOGIN, CODE
FROM            dbo.CODETMP
WHERE        (SERVER <> @@SERVERNAME)
GO
/****** Object:  View [dbo].[TESTCODE]    Script Date: 13/02/2024 08:54:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[TESTCODE]
AS
SELECT        SERVER, TYPE, FORM, [COLUMN], [TRIGGER], TDATE, USERLOGIN, CODE
FROM            dbo.CODETMP
WHERE        (SERVER = @@SERVERNAME)
GO
/****** Object:  View [dbo].[vCompare]    Script Date: 13/02/2024 08:54:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vCompare]
AS
SELECT        dbo.DEVCODE.TYPE, dbo.DEVCODE.FORM, dbo.DEVCODE.[COLUMN], dbo.DEVCODE.[TRIGGER], dbo.DEVCODE.CODE AS DEVCODE, dbo.DEVCODE.TDATE AS DEVDATE, dbo.DEVCODE.USERLOGIN AS DEVUSER, 
                         dbo.TESTCODE.CODE AS TESTCODE, dbo.TESTCODE.TDATE AS TESTDATE, dbo.TESTCODE.USERLOGIN AS TESTUSER
FROM            dbo.DEVCODE INNER JOIN
                         dbo.TESTCODE ON dbo.DEVCODE.TYPE = dbo.TESTCODE.TYPE AND dbo.DEVCODE.FORM = dbo.TESTCODE.FORM AND dbo.DEVCODE.[COLUMN] = dbo.TESTCODE.[COLUMN] AND 
                         dbo.DEVCODE.[TRIGGER] = dbo.TESTCODE.[TRIGGER]
GO
/****** Object:  StoredProcedure [dbo].[CompareCode]    Script Date: 13/02/2024 08:54:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Si
-- Create date: 06/02/24
-- Description:	Compare the code on two instances
-- =============================================
CREATE PROCEDURE [dbo].[CompareCode]
AS
BEGIN

	/* DROP TABLE [dbo].[CODETMP] */
	IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CODETMP]') AND type in (N'U')) BEGIN
	print 'Create Table'
		CREATE TABLE [dbo].[CODETMP](
			[SERVER] [nvarchar](50) NOT NULL,
			[TYPE] [char](1) NOT NULL,
			[FORM] [nvarchar](32) NOT NULL,
			[COLUMN] [nchar](32) NULL,
			[TRIGGER] [nchar](32) NULL,
			[TDATE] [int] NULL,
			[USERLOGIN] [nchar](32) NULL,
			[CODE] [nvarchar](max) NULL
		) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

	END

	print 'Clear Table'
	DELETE FROM dbo.CODETMP
	
	print 'Load Table'
	INSERT INTO dbo.CODETMP ( SERVER , TYPE , FORM , [COLUMN] , [TRIGGER] , TDATE , USERLOGIN , CODE)
	SELECT * FROM [CE-AZ-UK-S-PRIO\DEV].system.[dbo].[SQLCODE]
	union all
	SELECT * FROM system.[dbo].[SQLCODE]

	DECLARE @TYPE CHAR(1)
	DECLARE @FORM VARCHAR(32)
	DECLARE @COL VARCHAR(32)
	DECLARE @TRIG VARCHAR(32)
	DECLARE @CODE NVARCHAR(MAX)
	DECLARE @TO INT
	DECLARE @I INT
	SET @I = 0
	DECLARE @P INT
	SET @P = -1

	/* delete dest from src */
	select @TO = COUNT(*)
	from dbo.CODETMP
	where SERVER = @@SERVERNAME

	print 'Begin Cursor'
	declare cur CURSOR for 
	select TYPE , FORM , [COLUMN] , [TRIGGER] , CODE
	from dbo.CODETMP
	where SERVER = @@SERVERNAME
	OPEN cur
	fetch next from cur into @TYPE , @FORM , @COL, @TRIG , @CODE
	WHILE @@FETCH_STATUS = 0  
	BEGIN  	
		SELECT @I = @I + 1
		IF @I % (@TO/100) = 1 BEGIN
			SELECT @P = @P + 1
			SELECT str(@P) + '%'
		END		

		DELETE FROM dbo.CODETMP
		where SERVER <> @@SERVERNAME
		and TYPE = @TYPE
		and FORM = @FORM
		and [COLUMN] = @COL
		and [TRIGGER] = @TRIG
		AND ISNULL(CODE,'') = ISNULL(@CODE , '')
	
		fetch next from cur into @TYPE , @FORM , @COL, @TRIG , @CODE

	END 
	CLOSE cur;  
	DEALLOCATE cur; 

END

/*
exec dbo.CompareCode
DELETE FROM [CE-AZ-UK-S-PRIO\TST].system.[dbo].ZCLA_CODECOMP
WHERE TYPE <> ''
INSERT INTO [CE-AZ-UK-S-PRIO\TST].system.[dbo].ZCLA_CODECOMP (TYPE , ENAME , COLNAME , TRIGNAME , TDATE , USERLOGIN)
select TYPE , FORM , CASE WHEN LEN([COLUMN])=0 THEN '-' ELSE [COLUMN] END , [TRIGGER] , [TDATE] , [USERLOGIN]
from CODETMP
where SERVER <> @@SERVERNAME
*/
GO
