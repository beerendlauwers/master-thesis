
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


CREATE TRIGGER [dbo].[OnUpdateTaal] 
   ON  [dbo].[tblTaal]
   AFTER UPDATE
AS 
DECLARE @oudeTaal Varchar(50)
DECLARE @NieuweTaal Varchar(50)
DECLARE @Var Varchar(50)

BEGIN
	SET NOCOUNT ON;
--EXECUTE dbo.Manual_MaakTalenTabel
SET @oudeTaal = (SELECT taal from DELETED)
SET @oudeTaal = '[tblVglTaal].['+ @oudeTaal + ']'
SET @NieuweTaal = (SELECT taal from INSERTED)
EXEC sp_rename  @oudeTaal , @NieuweTaal, 'COLUMN'  
print(@NieuweTaal)
print(@oudeTaal)
END


CREATE TRIGGER [dbo].[OnDeleteTaal] 
   ON  [dbo].[tblTaal]
   AFTER DELETE
AS
DECLARE @Taal Varchar(50)
DECLARE @Var Varchar(200) 
DECLARE @VarD Varchar(200)
BEGIN
	SET NOCOUNT ON;
SET @Taal = (select taal from DELETED)
declare @table_name nvarchar(256)
declare @col_name nvarchar(256)
set @table_name = 'tblVglTaal'
set @col_name = @Taal



SET @VarD = (select  d.name from sys.tables t join
    sys.default_constraints d
        on d.parent_object_id = t.object_id
    join
    sys.columns c
        on c.object_id = t.object_id
        and c.column_id = d.parent_column_id
where t.name = @table_name
and c.name = @col_name)
IF @VarD IS NOT NULL
BEGIN
SET @VarD = 'ALTER TABLE tblVglTaal DROP ' + @VarD + ';'
exec(@VarD)
END
SET @Var = 'ALTER TABLE tblVglTaal DROP COLUMN ' + @Taal + ';'
exec(@Var)
END