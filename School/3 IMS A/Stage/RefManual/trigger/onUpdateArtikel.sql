USE [Reference_manual]
GO
/****** Object:  Trigger [dbo].[OnUpdateArtikel]    Script Date: 04/27/2010 16:12:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [dbo].[OnUpdateArtikel]
   ON  [dbo].[tblArtikel]
   AFTER UPDATE
AS 

DECLARE @Tag Varchar(200)
DECLARE @bool int
DECLARE @TaalIDn int
DECLARE @TaalID int
DECLARE @Tagn Varchar(200)
DECLARE @Taal Varchar(200)
DECLARE @Var NVarchar(2000)
DECLARE @Teller int
DECLARE @Count Varchar(200)
DECLARE @FK_Taal int
DECLARE @speshal Varchar(200)
DECLARE @BedrijfID Varchar(200)
DECLARE @VersieID Varchar(200)
DECLARE @BedrijfIDn Varchar(200)
DECLARE @VersieIDn Varchar(200)
DECLARE @Test Varchar(200)
DECLARE cInserted cursor for select I.tag,I.FK_Versie,I.FK_Bedrijf,I.FK_Taal,D.tag,D.FK_Versie,D.FK_Bedrijf,D.FK_Taal from INSERTED I, DELETED D
BEGIN	
open cInserted;
FETCH NEXT FROM cInserted INTO @Tagn,@VersieIDn,@BedrijfIDn,@TaalIDn,@Tag,@VersieID,@BedrijfID,@TaalID
WHILE @@FETCH_STATUS = 0
BEGIN

	--ALS ER EEN TAG OF VERSIE OF BEDRIJF GEUPDATE WERD IN HET GEUPDATE ARTIKEL
	IF UPDATE( tag ) or UPDATE(FK_Versie) or UPDATE(FK_Bedrijf)
	BEGIN
	--UPDATE DE RIJ EN GA NA OF ER NOG 1'TJES STAAN IN DIE RIJ
		DECLARE cTaalID cursor for SELECT taalID from tblTaal
		SET NOCOUNT ON;
		SET @Tag = (select dbo.getSimpleTag(@Tag))
		SET @Taal = (select Taal from tblTaal where TaalID=@TaalID)
		SET @Var = 'Update tblVglTaal SET ' + @Taal + '=0 where tag='''+ @Tag + '''' + ' and BedrijfID=' + @BedrijfID + ' and VersieID=' + @VersieID
		EXEC(@Var)
		--insert into tblTestTag(ArtikelID,NieuweTag) VALUES(1,@Var)
		SET @Bool = 1
		open cTaalID;
		FETCH NEXT FROM cTaalID INTO @TaalID
		WHILE @@FETCH_STATUS = 0
		BEGIN
			SET @Taal = (select taal from tblTaal where taalID=@TaalID)
			DECLARE @A VARCHAR(100)	
			SELECT @Var = 'SELECT @A = '+@Taal+' FROM tblVglTaal WHERE tag ='''+ @Tag + '''' + ' and BedrijfID=' + @BedrijfID +' and VersieID=' + @VersieID
			EXEC SP_EXECUTESQL @Var, N'@A VARCHAR(100) OUTPUT', @A OUTPUT
			SET @bool = @A
			IF @bool = 1
				BREAK
			FETCH NEXT FROM cTaalID INTO @TaalID
		END
		close cTaalID
		DEALLOCATE cTaalID
	END
	--ALS ER VOOR ALLE TALEN HET AANTAL GEVONDEN TAGS 0 IS DELETE DIE RIJ
	IF @bool = 0
	BEGIN
		DELETE FROM tblVglTaal where tag=@Tag and bedrijfID=@bedrijfID and VersieID=@VersieID
		--SET @Test='DELETE FROM tblVglTaal where tag=''' + @Tag + '''' + ' and bedrijfID=' + @bedrijfID + 'and VersieID= ' + @VersieID
		--insert into tblTestTag(ArtikelID,NieuweTag) VALUES(1,@Test)
	END



	--INSERT NIEUWE RIJ ALS TAG NOG NIET IN TBL VOORKOMT
	SET @Tagn = (select dbo.getSimpleTag(@Tagn))
	SET @Teller = (select count(*) from tblVglTaal where tag=@Tagn AND bedrijfID=@BedrijfIDn and VersieID=@VersieIDn)
	IF @Teller = 0
	BEGIN
		SET @speshal = 'INSERT into tblVglTaal VALUES(' + @VersieIDn + ',' + @BedrijfIDn + ',' + ''''  + @Tagn + '''' 
		DECLARE cTalen cursor FOR select TaalID from tblTaal
		open cTalen;
		FETCH NEXT FROM cTalen into @FK_Taal
		WHILE @@FETCH_STATUS = 0
		BEGIN
			SET @Count = (select count(*) from tblArtikel where dbo.getSimpleTag(tag)=@Tagn AND FK_Taal=@FK_taal AND FK_Bedrijf=@BedrijfIDn AND FK_Versie=@VersieIDn)
			SET @speshal = @speshal + ',' + @Count
			FETCH NEXT FROM cTalen into @FK_Taal
		END
		close cTalen
		DEALLOCATE cTalen
		SET @Var = @speshal + ')'
		--insert into tblTestTag(ArtikelID,NieuweTag) VALUES(1,@Var)
		exec(@Var)
	END
	--UPDATE RIJ ALS TAG AL IN TBL VOORKOMT VOOR BEDRIJF EN VERSIE
	IF @Teller > 0
	BEGIN
		DECLARE cTalen cursor FOR select TaalID from tblTaal
		SET @Var = 'UPDATE tblVglTaal SET '  
		open cTalen;
		FETCH NEXT FROM cTalen into @FK_Taal
		WHILE @@FETCH_STATUS = 0
		BEGIN
			SET @Taal= (select Taal from tblTaal where TaalID=@FK_Taal)
			SET @count = (select count(*) from tblArtikel where dbo.getSimpleTag(tag)=@Tagn AND FK_Taal=@FK_taal  AND FK_Bedrijf=@BedrijfIDn AND FK_Versie=@VersieIDn)
			SET @Var = @Var + @Taal + '=' + @Count + ', '
			FETCH NEXT FROM cTalen into @FK_Taal
		END
		SET @Var = RTRIM(LTRIM(@Var))
		SET @Var= left(@Var,len(@Var)-1)
		SET @Var = @Var + ' where tag=''' + @Tagn + '''' + ' and BedrijfID=' + @BedrijfIDn +' and VersieID=' + @VersieIDn
		--insert into tblTestTag(ArtikelID,NieuweTag) VALUES(1,@Var)
		exec(@Var)
		--select @Var
		close cTalen
		DEALLOCATE cTalen
	END
FETCH NEXT FROM cInserted INTO @Tagn,@VersieIDn,@BedrijfIDn,@TaalIDn,@Tag,@VersieID,@BedrijfID,@TaalID

END
close cInserted
DEALLOCATE cInserted
END