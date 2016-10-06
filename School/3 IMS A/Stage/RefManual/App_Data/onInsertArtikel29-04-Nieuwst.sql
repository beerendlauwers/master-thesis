USE [Reference_manual]
GO
/****** Object:  Trigger [dbo].[OnInsertArtikel]    Script Date: 04/29/2010 13:09:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER TRIGGER [dbo].[OnInsertArtikel]
ON [dbo].[tblArtikel]
AFTER INSERT
AS
DECLARE @ArtikelID int
DECLARE @Tag nVarchar(1000)
DECLARE @Teller int
DECLARE @BedrijfID nVarchar(1000)
DECLARE @VersieID nVarchar(1000)
DECLARE @Var nVarchar(1000)
DECLARE @Count nVarchar(1000)
DECLARE @Taal nVarchar(1000)
DECLARE @FK_Taal int
DECLARE cInserted cursor for Select FK_Versie,FK_Bedrijf,ArtikelID from INSERTED
BEGIN

open cInserted;
FETCH NEXT FROM cInserted INTO @VersieID,@BedrijfID,@ArtikelID
WHILE @@FETCH_STATUS = 0
BEGIN
SET @Tag = (select dbo.getSimpleTag(tag) from tblArtikel where ArtikelID=@ArtikelID)
SET @Teller = (select count(*) from tblVglTaal where tag=@Tag and VersieID=@VersieID and BedrijfID=@BedrijfID)
IF @Teller = 0
BEGIN
	DECLARE cTalen cursor FOR select TaalID from tblTaal
	SET @Var = 'INSERT into tblVglTaal VALUES(' + @VersieID + ',' + @BedrijfID + ',' + ''''  + @Tag + '''' 
	open cTalen;
	FETCH NEXT FROM cTalen into @FK_Taal
	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @Count = (select count(*) from tblArtikel where dbo.getSimpleTag(tag)=@Tag AND FK_Taal=@FK_taal and FK_Bedrijf=@BedrijfID and 

FK_Versie=@VersieID)
		SET @Var = @Var + ',' + @Count
		FETCH NEXT FROM cTalen into @FK_Taal
	END
	SET @Var = @Var + ')'
	exec(@Var)
	close cTalen
	DEALLOCATE cTalen
END
IF @Teller = 1
BEGIN
	DECLARE cTalen cursor FOR select TaalID from tblTaal
	SET @Var = 'UPDATE tblVglTaal SET tag=''' + @Tag + ''''  
	open cTalen;
	FETCH NEXT FROM cTalen into @FK_Taal
	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @Taal= (select Taal from tblTaal where TaalID=@FK_Taal)
		SET @count = (select count(*) from tblArtikel where dbo.getSimpleTag(tag)=@Tag AND FK_Taal=@FK_taal)
		SET @Var = @Var + ', ' + @Taal + '=' + @Count
		FETCH NEXT FROM cTalen into @FK_Taal
	END
	SET @Var = @Var + 'where tag=''' + @Tag + '''' + ' and BedrijfID=' + @BedrijfID  +' and VersieID=' + @VersieID
	exec(@Var)
	close cTalen
	DEALLOCATE cTalen
END
FETCH NEXT FROM cInserted INTO @VersieID,@BedrijfID,@ArtikelID
END
close cInserted
DEALLOCATE cInserted
END
