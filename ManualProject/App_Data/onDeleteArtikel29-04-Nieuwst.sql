USE [Reference_manual]
GO
/****** Object:  Trigger [dbo].[OnDeleteArtikel]    Script Date: 04/29/2010 13:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER TRIGGER [dbo].[OnDeleteArtikel] 
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
--WE HEBBEN NET 1 OF MEERDERE ARTIKELS VERWIJDERD EN GAAN DIE IN DE CURSOR LADEN
DECLARE cDeleted cursor for SELECT FK_Versie,FK_Bedrijf,FK_taal,tag FROM DELETED
BEGIN
open cDeleted;
FETCH NEXT FROM cDeleted into @VersieID, @BedrijfID,@TaalID,@Tag
WHILE @@FETCH_STATUS=0
BEGIN
DECLARE c1 cursor for SELECT taalID from tblTaal
SET @Tag = (select dbo.getSimpleTag(@Tag))
SET @Taal = (select Taal from tblTaal where TaalID=@TaalID)
--WANNEER EEN ARTIKEL WORDT VERWIJDERD MOET DE REFERNTIE DAARVAN IN tblVglTaal OOK VERWIJDERD WORDEN (MET HET UPDATE STATEMENT DAT HIER WORDT OPGEBOUWD)
SET @Var = 'Update tblVglTaal SET ' + @Taal + '=0 where tag='''+ @Tag + '''' + '  and BedrijfID=' + @BedrijfID  +' and VersieID=' + @VersieID 
EXEC(@Var)
SET @Bool = 1
open c1;
FETCH NEXT FROM c1 INTO @TaalID
WHILE @@FETCH_STATUS = 0
BEGIN
--VERVOLGENS GAAN WE KIJKEN OF ER IN DE RIJ WAAR WE JUIST EEN 1'tje HEBBEN VERWIJDERD OVERAL NULLEN STAAN OF NIET, ZOJA GAAN WE DIE RIJ VERWIJDEREN AANGEZIEN GEEN ENKEL ARTIKEL NOG DIE HEEFT
	SET @Taal = (select taal from tblTaal where taalID=@TaalID)
	DECLARE @A VARCHAR(1000)	
	SELECT @Var = 'SELECT @A = '+@Taal+' FROM tblVglTaal WHERE tag ='''+ @Tag + '''' + ' and BedrijfID=' + @BedrijfID + ' and VersieID=' + @VersieID
	EXEC SP_EXECUTESQL @Var, N'@A VARCHAR(1000) OUTPUT', @A OUTPUT
	SET @bool = @A
--ALS HIJ TOCH EEN 1'tje TERUGVIND STAPT HIJ UIT DE LUS EN GAAT HIJ NIKS DOEN	
	IF @bool = 1
		BREAK
	FETCH NEXT FROM c1 INTO @TaalID
END
CLOSE c1
DEALLOCATE c1
--ALS HIJ GEEN ENKEL 1'tje TERUGVINDT IN DE RIJ, GAAT HIJ DIE RIJ VERWIJDEREN
	IF @bool = 0
	BEGIN
	DELETE FROM tblVglTaal where tag=@Tag and versieID=@VersieID and BedrijfID=@BedrijfID
	END
FETCH NEXT FROM cDeleted into @VersieID, @BedrijfID,@TaalID,@Tag
END
close cDeleted
DEALLOCATE cDeleted
END

