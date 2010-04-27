USE [Reference_manual]
GO
/****** Object:  Trigger [dbo].[OnInsertTaal]    Script Date: 04/27/2010 16:12:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [dbo].[OnInsertTaal] 
   ON  [dbo].[tblTaal]
   AFTER INSERT
AS 
DECLARE @Taal Varchar(50)
DECLARE @Var Varchar(50) 
DECLARE @Varu Varchar(50)
BEGIN
	SET NOCOUNT ON;
SET @Taal = (Select Taal from INSERTED)
--EXECUTE dbo.Manual_MaakTalenTabel
SET @Var = 'ALTER TABLE tblVglTaal ADD ' + @Taal + ' int;'
exec(@Var)
SET @Varu = 'UPDATE tblVglTaal SET '+ @Taal + '=0;'
exec(@Varu)
END
