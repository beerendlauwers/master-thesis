USE [Reference_manual]
GO
/****** Object:  Trigger [dbo].[OnDeleteArtikel]    Script Date: 04/29/2010 09:29:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [dbo].[OnDeleteArtikel] 
   ON  [dbo].[tblArtikel]
   FOR DELETE
AS 
DECLARE @Tag NVarchar(MAX)
DECLARE @bool int
DECLARE @TaalID int
DECLARE @Taal NVarchar(MAX)
DECLARE @BedrijfID NVarchar(MAX)
DECLARE @VersieID NVarchar(MAX)
DECLARE @Var NVarchar(MAX)
DECLARE cDeleted cursor for SELECT FK_Versie,FK_Bedrijf,FK_taal,tag FROM DELETED
BEGIN
open cDeleted;
FETCH NEXT FROM cDeleted into @VersieID, @BedrijfID,@TaalID,@Tag
WHILE @@FETCH_STATUS=0
BEGIN
DECLARE c1 cursor for SELECT taalID from tblTaal
SET @Tag = (select dbo.getSimpleTag(@Tag))
SET @Taal = (select Taal from tblTaal where TaalID=@TaalID)
SET @Var = 'Update tblVglTaal SET ' + @Taal + '=0 where tag='''+ @Tag + '''' + '  and BedrijfID=' + @BedrijfID  +' and VersieID=' + @VersieID 
EXEC(@Var)
SET @Bool = 1
open c1;
FETCH NEXT FROM c1 INTO @TaalID
WHILE @@FETCH_STATUS = 0
BEGIN
	SET @Taal = (select taal from tblTaal where taalID=@TaalID)
	DECLARE @A VARCHAR(100)	
	SELECT @Var = 'SELECT @A = '+@Taal+' FROM tblVglTaal WHERE tag ='''+ @Tag + '''' + ' and BedrijfID=' + @BedrijfID + ' and VersieID=' + @VersieID
	EXEC SP_EXECUTESQL @Var, N'@A VARCHAR(100) OUTPUT', @A OUTPUT
	SET @bool = @A
	IF @bool = 1
		BREAK
	FETCH NEXT FROM c1 INTO @TaalID
END
CLOSE c1
DEALLOCATE c1
	IF @bool = 0
	BEGIN
	DELETE FROM tblVglTaal where tag=@Tag and versieID=@VersieID and BedrijfID=@BedrijfID
	END
FETCH NEXT FROM cDeleted into @VersieID, @BedrijfID,@TaalID,@Tag
END
close cDeleted
DEALLOCATE cDeleted
END

