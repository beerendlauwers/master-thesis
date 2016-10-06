USE [Reference_manual]
GO
/****** Object:  StoredProcedure [dbo].[Util_SplitString]    Script Date: 04/29/2010 13:02:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Util_SplitString]
	@string VARCHAR(MAX)
AS
	DECLARE @pos INT
	DECLARE @piece VARCHAR(2000)
BEGIN
	SET NOCOUNT ON;

    -- Need to tack a delimiter onto the end of the input string if one doesn't exist
	IF right(rtrim(@string),1) <> ','
		SET @string = @string  + ','

	SET @pos =  patindex('%,%' , @string)

	while @pos <> 0
	begin
		set @piece = left(@string, @pos - 1)
 
		-- You have a piece of data, so insert it, print it, do whatever you want to with it.
		print cast(@piece as varchar(500))

	set @string = stuff(@string, 1, @pos, '')
	set @pos =  patindex('%,%' , @string)
	end

END
GO
/****** Object:  StoredProcedure [dbo].[Manual_MaakTalenTabel]    Script Date: 04/29/2010 13:02:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Manual_MaakTalenTabel]
	
AS
DECLARE @FK_Taal int
DECLARE @ArtikelID int
DECLARE @Teller int
DECLARE @Tag nvarchar(1000)
DECLARE @BedrijfID VARCHAR(600)
DECLARE @VersieID VARCHAR(600)
DECLARE @Taal nvarchar(1000)
DECLARE @Var nvarchar(1000)
DECLARE @TaalCount nvarchar(1000)
DECLARE @TaalFetch VARCHAR(600)

BEGIN

DROP TABLE tblVglTaal
CREATE TABLE tblVglTaal(VersieID int,BedrijfID int,Tag nvarchar(1000))

--tblVglTaal AANMAKEN

DECLARE cTalen cursor FOR select TaalID from tblTaal
open cTalen;
FETCH NEXT FROM cTalen into @FK_Taal
WHILE @@FETCH_STATUS = 0
BEGIN
--DE KOLOMMEN WORDEN GEHAALD UIT DE tblTaal TABEL OM ZO VOOR ELKE BESTAANDE TAAL EEN KOLOM TE MAKEN
SET @Taal = (select Taal from tblTaal where Taalid=@FK_Taal)
SET @Var = 'ALTER TABLE tblVglTaal ADD ' + @Taal + ' int;'
EXEC(@Var)
FETCH NEXT FROM cTalen into @FK_Taal
END
close cTalen
DEALLOCATE cTalen
DELETE FROM tblVglTaal

--tblVglTaal VULLEN

--WE MOETEN VOOR ELKE VERSIE EN ELK BEDRIJF DEZE PROCEDURE DOORLOPEN OMDAT WE VERSIE AFHANKELIJK WERKEN, DWZ DAT EEN ARTIKEL IN EEN ANDERE VERSIE EN BEDRIJF DEZELFDE KLEINE TAG MAG HEBBEN: module_tag
SET NOCOUNT ON;
DECLARE cVersie cursor for select versieID from tblVersie
open cVersie;
FETCH NEXT FROM cVersie into @VersieID
WHILE @@FETCH_STATUS = 0
BEGIN
DECLARE cBedrijf cursor for select BedrijfID from tblBedrijf
open cBedrijf;
FETCH NEXT FROM cBedrijf into @BedrijfID
WHILE @@FETCH_STATUS=0
BEGIN
--WE GAAN HET VOLGENDE DAN VOOR ELKE TAAL DOEN
	DECLARE cTalen cursor FOR select TaalID from tblTaal
	open cTalen;
	FETCH NEXT FROM cTalen into @FK_Taal
	WHILE @@FETCH_STATUS = 0
	BEGIN
--DUS PER CURSOR VOOR VERSIE,VOOR BEDRIJF,VOOR TAAL GAAN WE DE VEREENVOUDIGDE TAGS OPHALEN VAN DE ARTIKELS VOOR DE VERSIE, BEDRIJF, TAAL WAAR WE IN ZITTEN ALS CURSOR
		DECLARE c1 cursor FOR select dbo.getSimpleTag(tag) from tblArtikel where FK_Taal = @FK_Taal and FK_Bedrijf=@BedrijfID and FK_Versie=@VersieID
		open c1;
		FETCH NEXT FROM c1 into @Tag	
		WHILE @@FETCH_STATUS = 0
		BEGIN
-- WE GAAN TELLEN HOEVEEL MAAL DIE VERKORTE TAG AL VOORKOMT IN DE tblVglTaal VOOR DE VERSIE, HET BEDRIJF EN DE TAAL VAN DE HUIDIGE CURSORS
			SET @Teller = (select count(*) from tblVglTaal where tag = @Tag and versieID=@VersieID and BedrijfID=@BedrijfID)
--ALS DAT 0 IS DAN GAAN WE EEN NIEUWE RIJ INVOEREN IN DE TABEL MET DE JUISTE WAARDES VAN 1'TJES EN NULLEN			
			if @Teller = 0
			BEGIN
			DECLARE cTalen1 cursor FOR select taalID from tblTaal
			SET @Var = 'INSERT INTO tblVglTaal VALUES(' + @VersieID + ',' + @BedrijfID + ',''' + @Tag + ''''
			open cTalen1;
			FETCH NEXT FROM cTalen1 into @FK_Taal
			WHILE @@FETCH_STATUS = 0
			BEGIN
-- HIER KIJKEN WE VOOR ELKE TAAL OF DIE TAG BESTAAT OF NIET EN ZOJA INSERTEN WE EEN 1'TJE EN ANDERS EEN 0
				SET @TaalFetch = (select count(*) from tblArtikel where FK_Taal = @FK_Taal and FK_Versie=@VersieID and FK_Bedrijf=@BedrijfID and dbo.getSimpleTag(tag) = @Tag );
				SET @Var = @Var + ',' + @TaalFetch 
				FETCH NEXT FROM cTalen1 into @FK_Taal
			END
			close cTalen1
			DEALLOCATE cTalen1
			set @Var = @Var + ')'
			--print @Var 
			EXEC(@Var)
			END
		FETCH NEXT FROM c1 into @Tag
		END
		close c1
		DEALLOCATE c1
		FETCH NEXT FROM cTalen into @FK_Taal
	END
	close cTalen
	DEALLOCATE cTalen
FETCH NEXT FROM cBedrijf into @BedrijfID
END
close cBedrijf
DEALLOCATE cBedrijf
FETCH NEXT FROM cVersie into @VersieID
END
close cVersie
DEALLOCATE cVersie
END
GO
/****** Object:  StoredProcedure [dbo].[Check_Module]    Script Date: 04/29/2010 13:02:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Check_Module] 
	@module nvarchar(1000)
	
AS
BEGIN
	
	SET NOCOUNT ON;
--GA KIJKEN OF DIE MODULE AL VOORKOMT IN DE TABEL WANT WE MOGEN GEEN DUBBELE MODULES BEKOMEN
    select * from tblModule where module = @module;
END
GO
/****** Object:  StoredProcedure [dbo].[Check_ModuleByID]    Script Date: 04/29/2010 13:02:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Check_ModuleByID] 
	@module nvarchar(1000),
	@id INT
	
AS
BEGIN
	
	SET NOCOUNT ON;

    select * from tblModule where module = @module AND moduleID! = @id;
END
GO
/****** Object:  StoredProcedure [dbo].[Manual_GetModuleByID]    Script Date: 04/29/2010 13:02:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Manual_GetModuleByID] 
	@id INT
AS
BEGIN
	
	SET NOCOUNT ON;
--HAALT EEN MODULE OP DMV DE ID
    select * from tblModule where moduleID = @id;
END
GO
/****** Object:  StoredProcedure [dbo].[Manual_getAllModules]    Script Date: 04/29/2010 13:02:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Manual_getAllModules]
AS


BEGIN
	
	SET NOCOUNT ON;
--HAALT DE MODULES OP GEORDEND
	SELECT module AS tag from tblModule ORDER by module
END
GO
/****** Object:  StoredProcedure [dbo].[Check_ArtikelsbyModule]    Script Date: 04/29/2010 13:02:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Check_ArtikelsbyModule] 
	@ModuleID int
AS
DECLARE @Module nvarchar(1000)
BEGIN
--DEZE STORED PROCEDURE GEBRUIKEN WE OM NA TE GAAN OF ER NOG ARTIKELS GEBRUIK MAKEN VAN DIE MODULE IN HUN TAG
-- ALS DEZE QUERY 1 OF MEERDERE ARTIKELS TERUGGEEFT MOGEN WE DAN DIE MODULE NATUURLIJK NIET VERWIJDEREN
SET @Module = (select Module from tblModule where ModuleID=@ModuleID)
    SET NOCOUNT ON;
	SELECT * from tblArtikel where dbo.getModule(tag)=@Module
END
GO
/****** Object:  StoredProcedure [dbo].[onUpdateModule]    Script Date: 04/29/2010 13:02:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[onUpdateModule]
	@oudeModule nvarchar(1000),
	@nieuweModule nvarchar(1000)
AS
DECLARE @NieuweTag nvarchar(1000)
DECLARE @oudeTag nvarchar(1000)
DECLARE @Var nvarchar(1000)
DECLARE cArtikels cursor for select tag from tblArtikel where ( SELECT data FROM dbo.SplitTekst(tag,'_') WHERE id = 4 ) = @oudeModule
BEGIN



open cArtikels;
FETCH NEXT FROM cArtikels into @OudeTag
WHILE @@FETCH_STATUS = 0
BEGIN
SET @NieuweTag = (SELECT data FROM dbo.SplitTekst(@oudeTag,'_') WHERE id = 1) + '_' + (SELECT data FROM dbo.SplitTekst(@oudeTag,'_') WHERE id = 2) + '_' + (SELECT data FROM dbo.SplitTekst(@oudeTag,'_') WHERE id = 3) + '_' + @NieuweModule + '_' + (SELECT data FROM dbo.SplitTekst(@oudeTag,'_') WHERE id = 5)
SET @Var = 'UPDATE tblArtikel SET tag=''' + @NieuweTag + '''' +' where tag=''' + @oudeTag + ''''
PRINT (@oudeTag)
PRINT (@NieuweTag)
PRINT (@Var)
EXEC(@Var)
FETCH NEXT FROM cArtikels into @OudeTag
END
close cArtikels;
DEALLOCATE cArtikels;


END
GO
/****** Object:  StoredProcedure [dbo].[Manual_HerstelTags]    Script Date: 04/29/2010 13:02:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Manual_HerstelTags]
	@teGebruikenModule nvarchar(1000)
AS
--EERST ALLE ARTIKELS OPHALEN MET EEN SLECHTE TAG
	DECLARE cArtikels CURSOR FOR SELECT tag, artikelID FROM tblArtikel A WHERE ( SELECT count(data) FROM dbo.SplitTekst( A.tag, '_' ) ) < 5
	DECLARE @artikelID INT
	DECLARE @huidigeTag nvarchar(1000)
	DECLARE @versie nvarchar(1000)
	DECLARE @taal nvarchar(1000)
	DECLARE @bedrijf nvarchar(1000)
	DECLARE @tag nvarchar(1000)
BEGIN
--DAARNA GAAN WE DE TAG OPSPLITSEN EN DE JUISTE WAARDES ERIN STEKEN	
	OPEN cArtikels;
	FETCH NEXT FROM cArtikels INTO @huidigeTag, @artikelID
	WHILE @@FETCH_STATUS = 0
	BEGIN
		SELECT @versie = data FROM dbo.SplitTekst( @huidigeTag, '_' ) WHERE id = 1;
		SELECT @taal = data FROM dbo.SplitTekst( @huidigeTag, '_' ) WHERE id = 2;
		SELECT @bedrijf = data FROM dbo.SplitTekst( @huidigeTag, '_' ) WHERE id = 3;
		SELECT @tag = data FROM dbo.SplitTekst( @huidigeTag, '_' ) WHERE id = 4;
		SET @huidigeTag = @versie + '_' + @taal + '_' + @bedrijf + '_' + @teGebruikenModule + '_' + @tag;
		UPDATE tblArtikel SET tag = @huidigeTag WHERE artikelID = @artikelID

		FETCH NEXT FROM cArtikels INTO @huidigeTag, @artikelID
	END

	CLOSE cArtikels;
	DEALLOCATE cArtikels;

END
GO
/****** Object:  StoredProcedure [dbo].[onUpdateVersie]    Script Date: 04/29/2010 13:02:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[onUpdateVersie]
	@oudeVersie nvarchar(1000),
	@nieuweVersie nvarchar(1000)
AS
DECLARE @NieuweTag nvarchar(1000)
DECLARE @oudeTag nvarchar(1000)
DECLARE @Var nvarchar(1000)
DECLARE cArtikels cursor for select tag from tblArtikel where ( SELECT data FROM dbo.SplitTekst(tag,'_') WHERE id = 1 ) = @oudeVersie
BEGIN

open cArtikels;
FETCH NEXT FROM cArtikels into @OudeTag
WHILE @@FETCH_STATUS = 0
BEGIN
SET @NieuweTag = @nieuweVersie + '_' + (SELECT data FROM dbo.SplitTekst(@oudeTag,'_') WHERE id = 2) + '_' + (SELECT data FROM dbo.SplitTekst(@oudeTag,'_') WHERE id = 3) + '_' + (SELECT data FROM dbo.SplitTekst(@oudeTag,'_') WHERE id = 4) + '_' + (SELECT data FROM dbo.SplitTekst(@oudeTag,'_') WHERE id = 5)
SET @Var = 'UPDATE tblArtikel SET tag=''' + @NieuweTag + '''' +' where tag=''' + @oudeTag + ''''
PRINT (@oudeTag)
PRINT (@NieuweTag)
PRINT (@Var)
EXEC(@Var)
FETCH NEXT FROM cArtikels into @OudeTag
END
close cArtikels;
DEALLOCATE cArtikels;


END
GO
/****** Object:  StoredProcedure [dbo].[onUpdateBedrijf]    Script Date: 04/29/2010 13:02:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[onUpdateBedrijf]
	@oudBedrijf nvarchar(1000),
	@nieuwBedrijf nvarchar(1000)
AS
DECLARE @NieuweTag nvarchar(1000)
DECLARE @oudeTag nvarchar(1000)
DECLARE @Var nvarchar(1000)
DECLARE cArtikels cursor for select tag from tblArtikel where ( SELECT data FROM dbo.SplitTekst(tag,'_') WHERE id = 3 ) = @oudBedrijf
BEGIN

open cArtikels;
FETCH NEXT FROM cArtikels into @OudeTag
WHILE @@FETCH_STATUS = 0
BEGIN
SET @NieuweTag = (SELECT data FROM dbo.SplitTekst(@oudeTag,'_') WHERE id = 1) + '_' + (SELECT data FROM dbo.SplitTekst(@oudeTag,'_') WHERE id = 2) + '_' + @nieuwBedrijf + '_' + (SELECT data FROM dbo.SplitTekst(@oudeTag,'_') WHERE id = 4) + '_' + (SELECT data FROM dbo.SplitTekst(@oudeTag,'_') WHERE id = 5)
SET @Var = 'UPDATE tblArtikel SET tag=''' + @NieuweTag + '''' +' where tag=''' + @oudeTag + ''''
PRINT (@oudeTag)
PRINT (@NieuweTag)
PRINT (@Var)
EXEC(@Var)
FETCH NEXT FROM cArtikels into @OudeTag
END
close cArtikels;
DEALLOCATE cArtikels;
END
GO
/****** Object:  StoredProcedure [dbo].[onUpdateTaalTag]    Script Date: 04/29/2010 13:02:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[onUpdateTaalTag]
	@oudeTaalTag nvarchar(1000),
	@nieuweTaalTag nvarchar(1000)
AS
DECLARE @NieuweTag nvarchar(1000)
DECLARE @oudeTag nvarchar(1000)
DECLARE @Var nvarchar(1000)
DECLARE cArtikels cursor for select tag from tblArtikel where ( SELECT data FROM dbo.SplitTekst(tag,'_') WHERE id = 2 ) = @oudeTaalTag
BEGIN

open cArtikels;
FETCH NEXT FROM cArtikels into @OudeTag
WHILE @@FETCH_STATUS = 0
BEGIN
SET @NieuweTag = (SELECT data FROM dbo.SplitTekst(@oudeTag,'_') WHERE id = 1) + '_' + @nieuweTaalTag + '_' + (SELECT data FROM dbo.SplitTekst(@oudeTag,'_') WHERE id = 3) + '_' + (SELECT data FROM dbo.SplitTekst(@oudeTag,'_') WHERE id = 4) + '_' + (SELECT data FROM dbo.SplitTekst(@oudeTag,'_') WHERE id = 5)
SET @Var = 'UPDATE tblArtikel SET tag=''' + @NieuweTag + '''' +' where tag=''' + @oudeTag + ''''
PRINT (@oudeTag)
PRINT (@NieuweTag)
PRINT (@Var)
EXEC(@Var)
FETCH NEXT FROM cArtikels into @OudeTag
END
close cArtikels;
DEALLOCATE cArtikels;
END
GO
/****** Object:  StoredProcedure [dbo].[Manual_getVideoByNaam]    Script Date: 04/29/2010 13:02:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Manual_getVideoByNaam]
	@videoNaam nvarchar(1000)
AS
BEGIN
	
	SET NOCOUNT ON;
--WORDT NIET MEER GEBRUIKT
    select * from tblVideo where videoNaam=@videoNaam
END
GO
/****** Object:  StoredProcedure [dbo].[Manual_getVideoByID]    Script Date: 04/29/2010 13:02:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Manual_getVideoByID]
@videoID int
AS
BEGIN
	
	SET NOCOUNT ON;
--WORDT NIET MEER GEBRUIKT
    select * from tblVideo where VideoID=@VideoID
END
GO
/****** Object:  StoredProcedure [dbo].[Manual_getArtikelsByModule]    Script Date: 04/29/2010 13:02:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Manual_getArtikelsByModule]
	@Module nvarchar(1000),
	@FK_taal int,
	@FK_versie int,
	@FK_Bedrijf int
AS
BEGIN
	
	SET NOCOUNT ON;
--GAAT ALLE ARTIKELS OPHALEN VOOR EEN MEEGEGEVEN MODULE (HIJ GAAT DIE MODULE UIT DE TAG FILTEREN VOOR ELK ARTIKEL EN DAN ZIEN OF DIE OVEREENKOMT MET DE GEWENSTE MODULE)
	SELECT * from tblArtikel where dbo.getModule(tag) = @Module and FK_Versie = @FK_versie and FK_taal=@FK_taal and FK_Bedrijf=@FK_Bedrijf ORDER BY titel

END
GO
/****** Object:  StoredProcedure [dbo].[Manual_getModulesMetArtikels]    Script Date: 04/29/2010 13:02:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Manual_getModulesMetArtikels]
	@FK_taal int,
	@FK_Versie int,
	@FK_Bedrijf int
AS


BEGIN
	
	SET NOCOUNT ON;

-- HAALT ENKEL MODULES OP UIT DE DATABASE DIE IN EEN ARTIKELTAG GEBRUIKT WORDEN
	SELECT DISTINCT dbo.getModule(tag) AS tag from tblArtikel where  FK_Taal=@FK_Taal and FK_Versie = @FK_Versie and FK_Bedrijf=@FK_Bedrijf 
END
GO
/****** Object:  StoredProcedure [dbo].[Manual_getCategorieByID]    Script Date: 04/29/2010 13:02:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Manual_getCategorieByID]
	@categorieID int
AS
BEGIN
	
	SET NOCOUNT ON;
--HAAL EEN CATEGORIE OP BASIS VAN ZIJN ID OP
	select * from tblCategorie where CategorieID=@CategorieID
END
GO
/****** Object:  StoredProcedure [dbo].[Manual_GetRootNode]    Script Date: 04/29/2010 13:02:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Manual_GetRootNode] 
AS
BEGIN
	
	SET NOCOUNT ON;
--HAALT DE ROOTNODE OP UIT DE tblCategorie
    SELECT * from tblCategorie WHERE categorie = 'root_node';
END
GO
/****** Object:  StoredProcedure [dbo].[Manual_getHoogte]    Script Date: 04/29/2010 13:02:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Manual_getHoogte] 
	@categorieID int, @bedrijfID int, @versieID int, @taalID int
AS
BEGIN
	
	SET NOCOUNT ON;
-- HAALT DE VOLGENDE HOOGTE OP VOOR WANNEER ER EEN CATEGORIE OF ARTIKEL WORDT GEWIJZIGD OF TOEGVOEGD, DIT IS DAN DE GROOTSTE HOOGTE ONDER EEN BEPAALDE CATEGORIE.
	SELECT * from tblCategorie where FK_parent=@categorieID AND FK_taal = @taalID AND FK_bedrijf = @bedrijfID AND FK_versie = @versieID AND hoogte >= (select max(hoogte) from tblCategorie where FK_Parent=@CategorieID AND FK_taal = @taalID AND FK_bedrijf = @bedrijfID AND FK_versie = @versieID)
END
GO
/****** Object:  StoredProcedure [dbo].[Manual_updateHoogte]    Script Date: 04/29/2010 13:02:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Manual_updateHoogte]
	@FK_parent int,
	@hoogte int
AS
BEGIN

	SET NOCOUNT ON;
--DEZE PROCEDURE WORDT NIET MEER GEBRUIKT
    UPDATE tblCategorie set hoogte= hoogte + 1 where FK_parent=@FK_parent AND hoogte>=@hoogte
END
GO
/****** Object:  StoredProcedure [dbo].[Check_CategorieByTaal]    Script Date: 04/29/2010 13:02:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Check_CategorieByTaal] 
	@taal INT
AS
BEGIN
	SET NOCOUNT ON;
--WE GAAN KIJKEN OF ER NOG CATEGORIEN ONDER EEN BEPAALDE TAAL STAAN, ZOJA MOGEN WE DIE TAAL NOG NIET VERWIJDEREN...

    SELECT * FROM tblCategorie WHERE FK_taal=@taal;
END
GO
/****** Object:  StoredProcedure [dbo].[deleteAllArtikelsForVersie]    Script Date: 04/29/2010 13:02:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[deleteAllArtikelsForVersie]
	@VersieID int
AS
BEGIN
	
DELETE from tblArtikel where FK_Versie=@VersieID
DELETE from tblCategorie where FK_Versie=@VersieID and Categorie!='root_node'
    
END
GO
/****** Object:  StoredProcedure [dbo].[Manual_getCategorieByParentVersieTaalBedrijf]    Script Date: 04/29/2010 13:02:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Manual_getCategorieByParentVersieTaalBedrijf]
	@FK_Parent int,
	@FK_Taal INT,
	@FK_Versie INT,
	@FK_Bedrijf INT
AS
BEGIN
	
	SET NOCOUNT ON;
--HAAL EEN CATEGORIE OP, OP BASIS VAN TAAL,BEDRIJF,VERSIE EN DE PARENT
    select * from tblCategorie where FK_Parent=@FK_Parent AND FK_TAAL = @FK_TAAL AND FK_Versie = @FK_Versie AND FK_Bedrijf = @FK_Bedrijf AND Categorie != 'root_node' ORDER BY Hoogte
END
GO
/****** Object:  StoredProcedure [dbo].[Check_CategorieByBedrijf]    Script Date: 04/29/2010 13:02:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Check_CategorieByBedrijf]
	@bedrijf INT
AS
BEGIN
	
--WE GAAN NAGAAN OF ER NOG CATEGORIE BESTAAN VOOR DIT BEDRIJF WANT ALS DIT WEL HET GEVAL IS MOGEN WE DAT BEDRIJF NIET VERWIJDEREN
SET NOCOUNT ON;
    SELECT * FROM tblCategorie WHERE FK_bedrijf=@bedrijf;
END
GO
/****** Object:  StoredProcedure [dbo].[DeleteAllArtikelsForBedrijf]    Script Date: 04/29/2010 13:02:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[DeleteAllArtikelsForBedrijf] 
	@BedrijfID int
AS
BEGIN
--VERWIJDER ALLE ARTIKELS VOOR DAT BEDRIJF EN VERVOLGENS ALLE CATEGORIEN VOOR DAT BEDRIJF BEHALVE DE ROOTNODE
	DELETE from tblArtikel WHERE FK_Bedrijf=@BedrijfID
	DELETE from tblCategorie WHERE FK_Bedrijf=@BedrijfID and Categorie!='root_node'
END
GO
/****** Object:  StoredProcedure [dbo].[Manual_GetCategorieByVersie]    Script Date: 04/29/2010 13:02:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Manual_GetCategorieByVersie] 
	@versie int
AS
BEGIN
	
	SET NOCOUNT ON;
--HAAL ALLE CATEGORIEN OP ONDER EEN BEPAALDE VERSIE
    SELECT * FROM tblCategorie WHERE FK_Versie=@versie;
END
GO
/****** Object:  StoredProcedure [dbo].[Manual_InsertCategorie]    Script Date: 04/29/2010 13:02:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Manual_InsertCategorie] 
	@catnaam nvarchar(1000),
	@diepte INT,
	@hoogte INT,
	@FK_parent INT,
	@FK_taal INT,
	@FK_bedrijf INT,
	@FK_versie INT
AS
BEGIN
--INSERT EEN CATEGORIE IN tblCategorie
	INSERT INTO tblCategorie(Categorie,Diepte,Hoogte,FK_parent,FK_taal,FK_bedrijf,FK_versie)
	VALUES( @catnaam, @diepte, @hoogte, @fk_parent, @fk_taal, @fk_bedrijf, @fk_versie);

	SELECT SCOPE_IDENTITY();

END
GO
/****** Object:  StoredProcedure [dbo].[Manual_GetAllCategorieBy]    Script Date: 04/29/2010 13:02:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Manual_GetAllCategorieBy]
	@taal INT, @bedrijf INT, @versie INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
--HAAL ALLE CATEGORIEN OP MET DE OPGEGEVEN TAAL, BEDRIJF, EN VERSIE
SELECT * FROM tblCategorie WHERE (FK_Taal = @taal AND FK_Versie = @versie AND FK_Bedrijf = @bedrijf) OR Categorie = 'root_node';
END
GO
/****** Object:  StoredProcedure [dbo].[Check_Categorie]    Script Date: 04/29/2010 13:02:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Check_Categorie] 
	@catnaam nvarchar(1000),
	@versie int,
	@bedrijf int,
	@taal INT
AS
BEGIN
--WE GAAN NAGAAN OF ER AL EEN CATEGORIE BESTAAT MET DIE NAAM, OMDAT WE GEEN CATEGORIE MET DEZELFDE NAAM MOGEN TOEVOEGEN IN HETZELFDE BEDRIJF DEZELFDE VERSIE EN TAAL.
SET NOCOUNT ON;
    SELECT * FROM tblCategorie WHERE Categorie=@catnaam AND FK_bedrijf=@bedrijf AND FK_Versie=@versie AND FK_taal=@taal;
END
GO
/****** Object:  StoredProcedure [dbo].[Check_CategorieByID]    Script Date: 04/29/2010 13:02:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Check_CategorieByID] 
	@catnaam nvarchar(1000),
	@versie INT,
	@bedrijf INT, 
	@taal INT,
	@ID INT
AS
BEGIN
	
--WE GAAN NAGAAN OF ER AL EEN CATEGORIE BESTAAT MET DIE NAAM, OMDAT WE GEEN CATEGORIE MET DEZELFDE NAAM MOGEN TOEVOEGEN IN HETZELFDE BEDRIJF DEZELFDE VERSIE EN TAAL.
--DEZE STORED PROCEDURE WORDT GEBRUIKT BIJ EEN UPDATE VAN CATEGORIE ALS CHECK


    SELECT * FROM tblCategorie
	WHERE Categorie = @catnaam AND FK_versie = @versie AND FK_bedrijf = @bedrijf AND FK_taal = @taal AND CategorieID! = @ID;
END
GO
/****** Object:  StoredProcedure [dbo].[Manual_getCategorieByParent]    Script Date: 04/29/2010 13:02:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Manual_getCategorieByParent]
	@FK_Parent int
AS
BEGIN
	
	SET NOCOUNT ON;
--HAAL ALLE CATEGORIEN OP ONDER EEN BEPAALDE CATEGORIE
    select * from tblCategorie where FK_Parent=@FK_Parent
END
GO
/****** Object:  StoredProcedure [dbo].[Manual_getCategorieZonderRoot]    Script Date: 04/29/2010 13:02:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Manual_getCategorieZonderRoot] 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
--HAALT ALLE CATEGORIEN OP BEHALVE DE ROOT NODE, DIT WORDT GEBRUIKT OM DROPDOWNS TE VULLEN ZOALS CATEGORIE WIJZIGEN EN VERWIJDEREN,OMDAT DE ROOT NODE VAST STAAT EN DEZE ZEKER NOOIT MAG VERANDEREN.
    select * from tblCategorie where Categorie!='root_node'
END
GO
/****** Object:  StoredProcedure [dbo].[Manual_UpdateTagTalen]    Script Date: 04/29/2010 13:02:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Manual_UpdateTagTalen]
	@NieuweTag nvarchar(1000),
	@OudeTag nvarchar(1000),
	@Versie int,
	@Bedrijf int
	
AS
DECLARE @VersieID int
DECLARE @BedrijfID int
DECLARE @Versienaam nvarchar(1000)
DECLARE @bedrijfnaam nvarchar(1000)
DECLARE @InTag nvarchar(1000)
DECLARE @FK_Taal int
DECLARE	@Taal nvarchar(1000)
DECLARE @ID int
DECLARE @Tag nvarchar(1000)

IF @Bedrijf=-1 AND @Versie=-1 
BEGIN
DECLARE c1 cursor FOR select ArtikelID,tag,FK_Taal,FK_Versie,FK_Bedrijf from tblArtikel where dbo.getSimpleTag(tag) = dbo.getSimpleTag(@OudeTag)
open c1;
FETCH NEXT FROM c1 into	@ID,@Tag,@FK_Taal,@VersieID,@BedrijfID
WHILE @@FETCH_STATUS = 0
BEGIN
SET @Taal = (select taalTag from tblTaal where TaalID=@FK_Taal)
SET @Versienaam = (select versie from tblVersie where VersieID=@VersieID)
SET @bedrijfnaam=(select tag from tblBedrijf where BedrijfID=@BedrijfID)
SET @InTag = @Versienaam + '_' + @Taal + '_' + @bedrijfnaam + '_' + dbo.getSimpleTag(@NieuweTag)
UPDATE tblArtikel SET tag = @InTag WHERE artikelID=@ID
FETCH NEXT FROM c1 into @ID,@Tag,@FK_Taal,@VersieID,@BedrijfID
END
close c1
DEALLOCATE c1;
END
ELSE
BEGIN
DECLARE c1 cursor FOR select ArtikelID,tag,FK_Taal,FK_Versie,FK_Bedrijf from tblArtikel where dbo.getSimpleTag(tag) = dbo.getSimpleTag(@OudeTag) and FK_Versie=@Versie and FK_Bedrijf=@Bedrijf
open c1;
FETCH NEXT FROM c1 into	@ID,@Tag,@FK_Taal,@VersieID,@BedrijfID
WHILE @@FETCH_STATUS = 0
BEGIN
SET @Taal = (select taalTag from tblTaal where TaalID=@FK_Taal)
SET @Versienaam = (select versie from tblVersie where VersieID=@VersieID)
SET @bedrijfnaam=(select tag from tblBedrijf where BedrijfID=@BedrijfID)
SET @InTag = @Versienaam + '_' + @Taal + '_' + @bedrijfnaam + '_' + dbo.getSimpleTag(@NieuweTag)
UPDATE tblArtikel SET tag = @InTag WHERE artikelID=@ID
FETCH NEXT FROM c1 into @ID,@Tag,@FK_Taal,@VersieID,@BedrijfID
END

END
GO
/****** Object:  StoredProcedure [dbo].[Manual_getTitelByTag]    Script Date: 04/29/2010 13:02:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Manual_getTitelByTag]
	@Tag nvarchar(1000)
AS
--DEZE PROCEDURE WORDT GEBRUIKT OM DE TITEL VAN EEN ARTIKEL OP TE HALEN DOOR MIDDEL VAN DE AFGEKORTE TAG
--DIT WORDT GEBRUIKT IN DE OVERZICHTSTABEL VAN TALEN OMDAT DAAR ENKEL DE VERKORTE TAG TE VINDEN IS
--HIER WORDT DAN DE EERST GEVONDEN TITEL TERUGGEGEVEN
--MET ANDERE WOORDEN ALS HET ARTIKEL NIET BESTAAT IN HET NEDERLANDS MAAR WEL IN HET FRANS,HET ITALIAANS EN HET DUITS
--EN DUITS HEEFT DE KLEINSTE ID DAN WORDT DE DUITSE TITEL TERUGGEGEVEN

Declare @TaalID int
DECLARE @TITEL AS nvarchar(1000)
DECLARE c1 cursor for select TaalID from tblTaal
BEGIN
	SET NOCOUNT ON;
	open c1;
	FETCH NEXT FROM c1 INTO @TaalID
	WHILE @@FETCH_STATUS = 0
	BEGIN
	SET @TITEL = (SELECT titel FROM tblArtikel where dbo.getSimpleTag(tag) = @Tag AND FK_Taal = @TaalID)
	IF @TITEL IS NOT NULL
	BREAK
	FETCH NEXT FROM c1 INTO @TaalID
	END
Select @TITEL
END
GO
/****** Object:  StoredProcedure [dbo].[Manual_getArtikelsByTitel]    Script Date: 04/29/2010 13:02:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Manual_getArtikelsByTitel] 
	@titel nvarchar(1000)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT * from tblArtikel where titel LIKE @titel;
END
GO
/****** Object:  StoredProcedure [dbo].[Manual_GetArtikelsByParent]    Script Date: 04/29/2010 13:02:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Manual_GetArtikelsByParent]
	@categorieID INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
--HAALT ALLE ARTIKELS ONDER EEN BEPAALDE CATEGORIE OP
	SELECT * FROM tblArtikel WHERE FK_categorie = @categorieID
END
GO
/****** Object:  StoredProcedure [dbo].[vergelijkTalen]    Script Date: 04/29/2010 13:02:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[vergelijkTalen] 

AS
DECLARE @ArtikelID int
DECLARE @Tag nvarchar(1000)
DECLARE c1 cursor FOR select ArtikelID,tag from tblArtikel where FK_Taal = 5 and substring(tag,1,6)='010302'
BEGIN
	SET NOCOUNT ON;
	BEGIN
		
		open c1
		FETCH NEXT FROM c1 into @ArtikelID,@Tag
		--print(@Tag)
		WHILE @@FETCH_STATUS = 0
		BEGIN
			SET @Tag = (substring(@Tag,1,10) + substring(@Tag,12,50))
			--print(@tag)
			--UPDATE tblArtikel SET tag = @Tag where ArtikelID= @ArtikelID
			FETCH NEXT FROM c1 into @ArtikelID,@Tag
		END
		close c1
		DEALLOCATE c1
	END
end
GO
/****** Object:  StoredProcedure [dbo].[Manual_UpdateTag]    Script Date: 04/29/2010 13:02:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Manual_UpdateTag] 
@FK_Taal int
AS
--DEZE PROCEDURE WORDT NIET MEER GEBRUIKT
--IS AANGEMAAKT OM DE EERSTE KEER DE TAGS SCHOON TE MAKEN ZODAT WE DAAR IETS MEE KONDEN DOEN
DECLARE @Teller int
DECLARE @Tag nvarchar(1000)
DECLARE @String nvarchar(1000)
DECLARE @ArtikelID int
DECLARE @ArtikelID2 int
DECLARE @ID1 int
DECLARE @ID2 int
declare @idstring nvarchar(1000)
set @idstring = 'DTA/FINAN'
declare @idstring2 nvarchar(1000)
set @idstring2 = 'DTA/FRAME'
set @ID1 = (select artikelID from tblArtikel where FK_Taal = @FK_Taal and substring(tag,4,9) = @idstring)
set @ID2 = (select artikelID from tblArtikel where FK_Taal = @FK_Taal and substring(tag,4,9) = @idstring2)
--cursor 1 dient om de meest standaard tags op te halen en hun ID's
DECLARE c1 cursor FOR select tag,ArtikelID from tblArtikel where FK_Taal = @FK_Taal AND substring(tag,7,1)='/' AND artikelID<>@ID1 AND artikelID<>@ID2
--cursor 2 dient om de tags en ID's op te halen van waar de tags beginnen met TIPS of GLOS
DECLARE c2 cursor FOR select tag,ArtikelID from tblArtikel where FK_Taal = @FK_Taal AND substring(tag,8,1)='/' AND artikelID<>@ID1 AND artikelID<>@ID2
--cursor 2 dient om de tags en ID's op te halen van de WELKOM tags
DECLARE c3 cursor FOR select tag,ArtikelID from tblArtikel where FK_Taal = @FK_Taal AND substring(tag,4,6)='WELKOM' AND artikelID<>@ID1 AND artikelID<>@ID2
--alle FR tags ophalen
--DECLARE c4 cursor FOR select tag,ArtikelID from tblArtikel where FK_Taal = @FK_Taal2
--alle NL tags ophalen
--DECLARE c5 cursor FOR select tag,ArtikelID from tblArtikel where FK_Taal = @FK_Taal

BEGIN
SET NOCOUNT ON;
--UPDATE ALLE TAGS IN CURSOR 1
open c1;
FETCH NEXT FROM c1 into @String,@ArtikelID
WHILE @@FETCH_STATUS = 0
Begin
	SET @TAG = ('010302_NL_AAAFinancials_' + substring(@String,4,3) + '_' + substring(@String,8,50))
	update tblArtikel SET tag = @TAG where artikelID = @ArtikelID
	--insert into tblTestTag VALUES(@artikelID,@string,@TAG)
FETCH NEXT FROM c1 into @String,@ArtikelID
END
close c1
--UPDATE ALLE TAGS IN CURSOR 2
open c2;
FETCH NEXT FROM c2 into @String,@ArtikelID
WHILE @@FETCH_STATUS = 0
Begin
	SET @TAG = ('010302_NL_AAAFinancials_' + substring(@String,4,4) + '_' + substring(@String,9,50))
	--SET @TAG = (substring(@TAG,1,2) + '_' + substring(@TAG,4,50))
	update tblArtikel SET tag = @TAG where artikelID = @ArtikelID	
	
	--insert into tblTestTag VALUES(@artikelID,@string,@TAG)
FETCH NEXT FROM c2 into @String,@ArtikelID
END
close c2
--UPDATE ALLE TAGS IN CURSOR 3
open c3;
FETCH NEXT FROM c3 into @String,@ArtikelID
WHILE @@FETCH_STATUS = 0
Begin
	SET @TAG = ('010302_NL_AAAFinancials_' + substring(@string,4,50))
	--SET @TAG = (substring(@String,1,3) + substring(@String,5,30))
	--SET @TAG = (substring(@TAG,1,2) + '_' + substring(@TAG,4,50))
	update tblArtikel SET tag = @TAG where artikelID = @ArtikelID	
	
	--insert into tblTestTag VALUES(@artikelID,@string,@TAG)
FETCH NEXT FROM c3 into @String,@ArtikelID
END
close c3
--UPDATEN alle van FINAN en FRAME tag's
SET @String = (select tag from tblArtikel where artikelID = @ID1)
SET @TAG = ('010302_NL_AAAFinancials_' + substring(@String,4,3) + '_' + substring(@String,8,50))
update tblArtikel SET tag = @TAG where artikelID = @ID1
--insert into tblTestTag VALUES (@ID1,@String,@TAG)
SET @String = (select tag from tblArtikel where artikelID = @ID2)
SET @TAG = ('010302_NL_AAAFinancials_' + substring(@String,4,3) + '_' + substring(@String,8,50))
update tblArtikel SET tag = @TAG where artikelID = @ID2
--insert into tblTestTag VALUES(@ID2,@String,@TAG)

END
GO
/****** Object:  StoredProcedure [dbo].[Check_Artikel]    Script Date: 04/29/2010 13:02:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Check_Artikel] 
	@titel nvarchar(1000),
	@versie int,
	@bedrijf int,
	@taal INT
AS
BEGIN
--WE GAAN NAKIJKEN OF EEN ARTIKEL AL BESTAAT MET DIE TITEL VOOR DAT BEDRIJF DIE VERSIE EN DIE TAAL, DIT GEBEURT VOOR EEN INSERT
--DIT DOEN WE OMDAT EEN ARTIKEL IN HETZELFDE BEDRIJF EN VERSIE NIET DEZELFDE TITEL MAG HEBBEN? DAAROM DUS DEZE CHECK
SET NOCOUNT ON;
    SELECT * FROM tblArtikel WHERE Titel=@titel AND FK_bedrijf=@bedrijf AND FK_Versie=@versie AND FK_taal=@taal;
END
GO
/****** Object:  StoredProcedure [dbo].[Check_ArtikelByID]    Script Date: 04/29/2010 13:02:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Check_ArtikelByID] 
	@titel nvarchar(1000),
	@versie int,
	@bedrijf int,
	@taal INT,
	@ID INT
AS
BEGIN
	
--DEZE STORED PROCEDURE GEBRUIKEN WE BIJ EEN UPDATE VAN EEN ARTIKEL? WE GAAN OPNIEUW KIJKEN OF EEN ARTIKEL MET DEZELFDE TITEL AL BESTAAT
SET NOCOUNT ON;
    SELECT * FROM tblArtikel WHERE Titel=@titel AND FK_bedrijf=@bedrijf AND FK_Versie=@versie AND FK_taal=@taal AND ArtikelID! = @ID;
END
GO
/****** Object:  StoredProcedure [dbo].[Check_ArtikelByTag]    Script Date: 04/29/2010 13:02:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Check_ArtikelByTag] 
	@tag nvarchar(1000),
	@versie int,
	@bedrijf int,
	@taal INT
AS
BEGIN
--HIER GAAN WE HETZELFDE DOEN ALS Check_Artikel MAAR DAN MET DE TAG IN PLAATS VAN DE TITEL
SET NOCOUNT ON;
    SELECT * FROM tblArtikel WHERE Tag=@tag AND FK_bedrijf=@bedrijf AND FK_Versie=@versie AND FK_taal=@taal;
END
GO
/****** Object:  StoredProcedure [dbo].[Manual_GetArtikelsByTitel_Versie_Bedrijf_Taal]    Script Date: 04/29/2010 13:02:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Manual_GetArtikelsByTitel_Versie_Bedrijf_Taal] 
	@titel nvarchar(1000), @versie INT, @bedrijf INT, @taal INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
--WORDT TOCH NIET GEBRUIKT
    -- Insert statements for procedure here
	SELECT * from tblArtikel where FK_versie = @versie AND FK_bedrijf = @bedrijf AND FK_TAAL = @taal AND titel LIKE @titel;
END
GO
/****** Object:  StoredProcedure [dbo].[Manual_getArtikelTekst]    Script Date: 04/29/2010 13:02:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Manual_getArtikelTekst]
	@zoekterm nvarchar(1000),
	@tag nvarchar(1000)
AS
DECLARE @ArtikelTekst NVARCHAR(max)
DECLARE @WeergaveTekst nvarchar(1000)
--DECLARE @index int
BEGIN
	
	SET NOCOUNT ON;
	SET @ArtikelTekst = (SELECT tekst from tblArtikel where tag= @Tag)
--DIT DIENT VOOR DE ZOEKFUNCTIONALITEIT, HIJ GAAT VOOR EEN ARTIKEL (TAG) EEN STUK TEKST ZOEKEN WAARIN HET ZOEKWOORD VOORKOMT EN OM DIE TEKST IN DE ZOEKRESULTATEN WEER TE GEVEN
	SET @weergaveTekst = (select substring(Tekst,charindex(@Zoekterm,@ArtikelTekst,60),150) from tblArtikel where tag=@tag)
SELECT @weergaveTekst
END
GO
/****** Object:  StoredProcedure [dbo].[Manual_getArtikelByTekst_Versie_Bedrijf_Taal]    Script Date: 04/29/2010 13:02:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Manual_getArtikelByTekst_Versie_Bedrijf_Taal] 
	@tekst NVARCHAR(2048), @versie INT, @bedrijf INT, @taal INT
AS
BEGIN
	
	SET NOCOUNT ON;
--DOET EEN FULLTEXT SEARCH EN GEEFT ALLE ARTIKELS TERUG OP BASIS VAN VERSIE,BEDRIJF EN TAAL
	SELECT * FROM tblArtikel WHERE CONTAINS(tekst,@tekst) AND FK_versie = @versie AND FK_bedrijf = @bedrijf AND FK_taal = @taal;
END
GO
/****** Object:  StoredProcedure [dbo].[Manual_GetArtikelGegevensByTekst]    Script Date: 04/29/2010 13:02:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Manual_GetArtikelGegevensByTekst] 
	@tekst VARCHAR(2048),
	@isfinal nvarchar(1000),
	@versies nvarchar(1000),
	@bedrijven nvarchar(1000),
	@talen nvarchar(1000)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
--GAAT DE INTERESSANTE ARTIKELGEGEVENS OPHALEN ZOALS TITEL,TAG,VERSIE,FINAAL,BEDRIJF,TAAL EN ARTIKELID VOOR DE MEEGEGEVEN WAARDES EN GAAT ZOEKEN OP TEKST

    -- Insert statements for procedure here
	SELECT A.Titel, A.Tag, A.Is_final, V.Versie, B.Naam, T.Taal, A.ArtikelID
	FROM tblArtikel A, tblVersie V, tblBedrijf B, tblTaal T
	WHERE contains(tekst,@tekst)
	AND A.FK_Versie = V.VersieID
	AND A.FK_Bedrijf = B.BedrijfID
	AND A.FK_Taal = T.TaalID
	AND A.Is_final IN ( SELECT * FROM Split(@isfinal,',') )
	AND A.FK_Versie IN ( SELECT * FROM Split(@versies,',') )
	AND A.FK_Bedrijf IN ( SELECT * FROM Split(@bedrijven,',') )
	AND A.FK_Taal IN ( SELECT * FROM Split(@talen,',') );
END
GO
/****** Object:  StoredProcedure [dbo].[Manual_theUltimateGet]    Script Date: 04/29/2010 13:02:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Manual_theUltimateGet] 
	@bedrijfID int,
	@versieID int,
	@TaalID int,
	@tekst nvarchar(1000)


	
AS
DECLARE @find varchar(30);
BEGIN
--WORDT GEBRUIKT VOOR DE ZOEKRESULTATEN, HIJ GAAT EEN FULLTEXT SEARCH DOEN OP DE tblArtikel EN EEN SEARCH OP TITEL
--OMDAT DE GEBRUIKER BIJ HET ZOEKEN ENKEL ARTIKELS VOOR ZIJN VERSIE BEDRIJF EN TAAL MOET ZIEN WORDT DAAR OOK NOG OP GEFILTERT
SET NOCOUNT ON;
	SET @find = '"*' + @tekst + '*"'
	select A.titel,A.tag,A.Tekst,V.Versie,T.taal 
	from tblArtikel A, tblVersie V, tblTaal T 
	where (contains(tekst, @find)OR titel LIKE '%' + @tekst +'%') AND (FK_Bedrijf=0 or FK_Bedrijf=@bedrijfID) AND (FK_Versie=@VersieID) AND (FK_Taal=@TaalID)
	AND A.FK_Versie=V.VersieID AND A.FK_Taal=T.TaalID
END
GO
/****** Object:  StoredProcedure [dbo].[Manual_getArtikelsByVersie]    Script Date: 04/29/2010 13:02:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Manual_getArtikelsByVersie]
	@VersieID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
--HAAL ALLE ARTIKELS ONDER EEN BEPAALDE VERSIE OP
	select * from tblArtikel Where FK_Versie=@VersieID
END
GO
/****** Object:  StoredProcedure [dbo].[Manual_getArtikelsByTaal]    Script Date: 04/29/2010 13:02:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Manual_getArtikelsByTaal]
	@TaalID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
--HAALT ALLE ARTIKELS ONDER EEN BEPAALDE TAAL OP
    select * from tblArtikel where FK_Taal = @TaalID
END
GO
/****** Object:  StoredProcedure [dbo].[Manual_getArtikelsByBedrijf]    Script Date: 04/29/2010 13:02:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Manual_getArtikelsByBedrijf]
	@BedrijfID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
-- GAAT ALLE ARTIKELS OPHALEN VOOR EEN BEPAALD BEDRIJF
    select * from tblArtikel where FK_Bedrijf=@BedrijfID
END
GO
/****** Object:  StoredProcedure [dbo].[Manual_GetArtikelGegevensByTag]    Script Date: 04/29/2010 13:02:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Manual_GetArtikelGegevensByTag] 
	@tag nvarchar(1000),
	@isfinal nvarchar(1000),
	@versies nvarchar(1000),
	@bedrijven nvarchar(1000),
	@talen nvarchar(1000)
AS
BEGIN
--GAAT DE INTERESSANTE ARTIKELGEGEVENS OPHALEN ZOALS TITEL,TAG,VERSIE,FINAAL,BEDRIJF,TAAL EN ARTIKELID VOOR DE MEEGEGEVEN WAARDES EN GAAT ZOEKEN OP TAG
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT A.Titel, A.Tag, A.Is_final, V.Versie, B.Naam, T.Taal, A.ArtikelID
	FROM tblArtikel A, tblVersie V, tblBedrijf B, tblTaal T
	WHERE A.Tag LIKE @tag
	AND A.FK_Versie = V.VersieID
	AND A.FK_Bedrijf = B.BedrijfID
	AND A.FK_Taal = T.TaalID
	AND A.Is_final IN ( SELECT * FROM Split(@isfinal,',') )
	AND A.FK_Versie IN ( SELECT * FROM Split(@versies,',') )
	AND A.FK_Bedrijf IN ( SELECT * FROM Split(@bedrijven,',') )
	AND A.FK_Taal IN ( SELECT * FROM Split(@talen,',') );
END
GO
/****** Object:  StoredProcedure [dbo].[Manual_GetArtikelGegevensByTitel]    Script Date: 04/29/2010 13:02:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Manual_GetArtikelGegevensByTitel] 
	@titel nvarchar(1000),
	@isfinal nvarchar(1000),
	@versies nvarchar(1000),
	@bedrijven nvarchar(1000),
	@talen nvarchar(1000)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
--GAAT DE INTERESSANTE ARTIKELGEGEVENS OPHALEN ZOALS TITEL,TAG,VERSIE,FINAAL,BEDRIJF,TAAL EN ARTIKELID VOOR DE MEEGEGEVEN WAARDES EN GAAT ZOEKEN OP TITEL

    -- Insert statements for procedure here
	SELECT A.Titel, A.Tag, A.Is_final, V.Versie, B.Naam, T.Taal, A.ArtikelID
	FROM tblArtikel A, tblVersie V, tblBedrijf B, tblTaal T
	WHERE titel LIKE @titel
	AND A.FK_Versie = V.VersieID
	AND A.FK_Bedrijf = B.BedrijfID
	AND A.FK_Taal = T.TaalID
	AND A.Is_final IN ( SELECT * FROM Split(@isfinal,',') )
	AND A.FK_Versie IN ( SELECT * FROM Split(@versies,',') )
	AND A.FK_Bedrijf IN ( SELECT * FROM Split(@bedrijven,',') )
	AND A.FK_Taal IN ( SELECT * FROM Split(@talen,',') );
END
GO
/****** Object:  StoredProcedure [dbo].[DeleteAllArtikelsForCategorie]    Script Date: 04/29/2010 13:02:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[DeleteAllArtikelsForCategorie]
	@CategorieID int
AS
BEGIN
--VERWIJDER ALLE ARTIKELS ONDER EEN BEPAALDE CATEGORIE
    DELETE from tblArtikel WHERE FK_Categorie=@CategorieID
END
GO
/****** Object:  StoredProcedure [dbo].[vergelijkTalen1]    Script Date: 04/29/2010 13:02:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[vergelijkTalen1]

AS
DECLARE @ArtikelID int
DECLARE @Tag nvarchar(1000)
DECLARE @Teller int
DECLARE @Var nvarchar(1000)
DECLARE @FK_Taal int
DECLARE @Taal nvarchar(1000)
DECLARE @Count nvarchar(1000)
DECLARE c1 cursor FOR select taalID from tblTaal
BEGIN
	SET NOCOUNT ON;
	SET @ArtikelID = (select max(ArtikelID) from tblArtikel)
	SET @Tag = (select substring(tag,4,50) from tblArtikel where ArtikelID=@ArtikelID)
	SET @Teller = (select count(*) from tblVglTaal where tag=@Tag)
	IF @Teller = 0
	BEGIN
		open c1;
		SET @Var = 'insert into tblVglTaal VALUES(''' + @Tag + '''' 
		FETCH NEXT FROM c1 into @FK_Taal
		WHILE @@FETCH_STATUS = 0
			SET @count = (select count(*) from tblArtikel where FK_Taal = @FK_Taal and substring(tag,4,50) = @Tag)
			SET @Var = @Var + ',' + @count
			FETCH NEXT FROM c1 into @FK_Taal
		END
		--print(@Var)
		close c1
		DEALLOCATE c1
	END
	IF @Teller = 1
	BEGIN
		DECLARE c1 cursor FOR select taalID from tblTaal
		
		open c1;
		SET @Var = 'Update tblVglTaal SET tag=''' + @Tag + ''''
		FETCH NEXT FROM c1 into @FK_Taal
		WHILE @@FETCH_STATUS = 0
		BEGIN		
			SET @Taal = (select Taal from tblTaal where TaalID = @FK_Taal)
			SET @Count = (select count(*) from tblArtikel where FK_Taal = @FK_Taal and substring(tag,4,50) = @Tag)
			SET @Var = @Var + ',' + @Taal + '=' + @count 
			FETCH NEXT FROM c1 into @FK_Taal
		END
		close c1
	SET @Var = @Var + 'tag=''' + @Tag + '''' 
	--print(@Var)
	END
GO
/****** Object:  StoredProcedure [dbo].[Manual_deleteArtikelbyID]    Script Date: 04/29/2010 13:02:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Manual_deleteArtikelbyID]
	@artikelID int
AS
BEGIN

	SET NOCOUNT ON;
--VERWIJDER EEN ARTIKEL MET DE OPGEGEVEN ID
    DELETE FROM tblArtikel Where artikelID=@artikelID
END
GO
/****** Object:  StoredProcedure [dbo].[Manual_updateArtikel]    Script Date: 04/29/2010 13:02:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Manual_updateArtikel]
	@artikelID int,
	@Titel nvarchar(1000),
	@FK_Categorie int,
	@FK_Taal int,
	@FK_Bedrijf int,
	@FK_Versie int,
	@Tekst nvarchar(max),
	@tag nvarchar(1000),
	@Is_final int
AS
BEGIN
	
	SET NOCOUNT ON;
--HIERMEE WORDT EEN ARTIKEL IN DE TABEL GEUPDATE
    update tblArtikel set Titel=@Titel, FK_Categorie=@FK_Categorie, FK_Taal=@FK_Taal, FK_Bedrijf=@FK_Bedrijf, FK_Versie=@FK_Versie, Tekst=@Tekst, Tag=@tag, Is_final=@Is_final WHERE artikelID=@ArtikelID
END
GO
/****** Object:  StoredProcedure [dbo].[Manual_GetArtikelByID]    Script Date: 04/29/2010 13:02:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Manual_GetArtikelByID] 
	@id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
--HAALT EEN ARTIKEL OP DMV ZIJN ID
    -- Insert statements for procedure here
	SELECT * from tblArtikel where ArtikelID = @id;
END
GO
/****** Object:  StoredProcedure [dbo].[Manual_getUitzonderingen]    Script Date: 04/29/2010 13:02:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Manual_getUitzonderingen] @FK_Taal int,@IDstring nvarchar(1000),@ID int output
AS

BEGIN
	SET NOCOUNT ON;
--DEZE STORED PROCEDURE WORDT NIET MEER GEBRUIKT
	Set @ID = (select ArtikelID from tblArtikel where FK_Taal = @FK_Taal and substring(tag,4,9) = @IDstring)
END
GO
/****** Object:  StoredProcedure [dbo].[Manual_GetArtikelByTag]    Script Date: 04/29/2010 13:02:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Manual_GetArtikelByTag] 
	@tag nvarchar(1000)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
--HAALT EEN ARTIKEL OP DMV ZIJN TAG
    -- Insert statements for procedure here
	SELECT * from tblArtikel where Tag = @tag;
END
GO
/****** Object:  StoredProcedure [dbo].[Check_ArtikelByTagByID]    Script Date: 04/29/2010 13:02:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Check_ArtikelByTagByID] 
	@tag nvarchar(1000),
	@versie int,
	@bedrijf int,
	@taal int,
	@ArtikelID int
AS
BEGIN
	
--HIER GAAN WE HETZELFDE DOEN ALS Check_ArtikelByID MAAR DAN MET DE TAG IN PLAATS VAN DE TITEL
SET NOCOUNT ON;
    SELECT * FROM tblArtikel WHERE Tag=@tag AND FK_bedrijf=@bedrijf AND FK_Versie=@versie AND FK_taal=@taal and ArtikelID<>@ArtikelID;
END
GO
/****** Object:  StoredProcedure [dbo].[Manual_getArtikelByTekst]    Script Date: 04/29/2010 13:02:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Manual_getArtikelByTekst] 
	@tekst as nvarchar(1000)	
AS
BEGIN
	
	SET NOCOUNT ON;
--DOET EEN FULLTEXT - SEARCH OP DE MEEGEGEVEN TEKST EN GEEFT ALLE ARTIKELS TERUG DIE DE MEEGEGEVEN TEKST BEVATTEN.
	SELECT * from tblArtikel where contains(tekst,@tekst);
END
GO
/****** Object:  StoredProcedure [dbo].[Check_versie]    Script Date: 04/29/2010 13:02:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Check_versie] 
	@versie nvarchar(1000)
AS
BEGIN
	
	SET NOCOUNT ON;
--BIJ EEN INSERT VAN EEN VERSIE GAAN NAKIJKEN OF DIE VERSIE AL BESTAAT OF NIET WANT WE WILLEN GEEN DUBBELE VERSIES
    select * from tblVersie where Versie=@versie
END
GO
/****** Object:  StoredProcedure [dbo].[Check_versieByID]    Script Date: 04/29/2010 13:02:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Check_versieByID] 
	@versie nvarchar(1000),
	@ID int
AS
BEGIN
	
	SET NOCOUNT ON;
--BIJ EEN UPDATE VAN EEN VERSIE GAAN WE KIJKEN OF ER GEEN ANDERE VERSIE IS MET DEZELFDE NAAM.
    select * from tblVersie where versie=@versie AND versieID!=@ID
END
GO
/****** Object:  StoredProcedure [dbo].[Manual_InsertVersie]    Script Date: 04/29/2010 13:02:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Manual_InsertVersie] 
	@versie nvarchar(1000)
AS
BEGIN
--INSERT EEN NIEUWE VERSIE IN tblVersie
	INSERT INTO tblVersie(Versie)
	VALUES( @versie);

	SELECT SCOPE_IDENTITY();

END
GO
/****** Object:  StoredProcedure [dbo].[Manual_GetAllVersie]    Script Date: 04/29/2010 13:02:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Manual_GetAllVersie]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
--HAAL ALLE VERSIES OP
	SELECT * FROM tblVersie;
END
GO
/****** Object:  StoredProcedure [dbo].[Manual_GetVersieByID]    Script Date: 04/29/2010 13:02:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Manual_GetVersieByID]
@id INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
--HAALT EEN VERSIE OP DMV HET ID
	SELECT * FROM tblVersie WHERE VersieID = @id;
END
GO
/****** Object:  StoredProcedure [dbo].[Manual_GetTaalByID]    Script Date: 04/29/2010 13:02:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Manual_GetTaalByID]
@id INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
--HAALT EEN TAAL OP DMV ZIJN ID
	SELECT * FROM tblTaal WHERE TaalID = @id;
END
GO
/****** Object:  StoredProcedure [dbo].[Manual_GetAllTaal]    Script Date: 04/29/2010 13:02:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Manual_GetAllTaal]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
--HAAL ALLE TALEN OP
	SELECT * FROM tblTaal;
END
GO
/****** Object:  StoredProcedure [dbo].[Manual_InsertTaal]    Script Date: 04/29/2010 13:02:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Manual_InsertTaal] 
	@taal nvarchar(1000),
	@taaltag nvarchar(1000)
AS
BEGIN
--INSERT EEN TAAL IN tblTaal	
	INSERT INTO tblTaal(Taal, TaalTag)
	VALUES( @taal, @taaltag);

	SELECT SCOPE_IDENTITY();

END
GO
/****** Object:  StoredProcedure [dbo].[Check_Taal]    Script Date: 04/29/2010 13:02:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Check_Taal] 
	@taal nvarchar(1000),
	@taaltag nvarchar(1000)
	
AS
BEGIN
	
	SET NOCOUNT ON;
--WE GAAN NAKIJKEN OF DIE TAAL AL BESTAAT ZODAT WE GEEN DUBBELE TALEN TEGENKOMEN
    select * from tblTaal where taal=@taal OR taaltag=@taaltag
END
GO
/****** Object:  StoredProcedure [dbo].[Check_TaalByID]    Script Date: 04/29/2010 13:02:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Check_TaalByID] 
	@taal nvarchar(1000),
	@taaltag nvarchar(1000),
	@ID int
	
AS
BEGIN
	
	SET NOCOUNT ON;
--DIT GEBRUIKEN WE BIJ EEN UPDATE OM TE CHECKEN OF ER AL EEN ANDERE TAAL DIE NAAM OF TAG HEEFT
    select * from tblTaal where (taal=@taal OR taaltag=@taaltag) AND taalID!=@ID
END
GO
/****** Object:  StoredProcedure [dbo].[Manual_getTaalByNaam]    Script Date: 04/29/2010 13:02:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Manual_getTaalByNaam] 
	@Taal nvarchar(1000)
AS
BEGIN
	SET NOCOUNT ON;

--HAALT EEN TAAL OP DMV DE NAAM VAN DIE TAAL
	SELECT * from tblTaal where Taal = @Taal
END
GO
/****** Object:  StoredProcedure [dbo].[Check_getBedrijfByNaam_Tag]    Script Date: 04/29/2010 13:02:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Check_getBedrijfByNaam_Tag]
	@naam nvarchar(1000),
	@tag nvarchar (1000)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
--WE GAAN NAKIJKEN OF ER AL EEN BEDRIJF MET DEZELFDE NAAM OF TAG BESTAAT? WANT ER MOGEN GEEN 2 BEDRIJVEN DEZELFDE NAAM OF TAG HEBBEN.
   select * from tblBedrijf where naam=@naam or tag=@tag
END
GO
/****** Object:  StoredProcedure [dbo].[Check_getBedrijfByNaam_Tag_ID]    Script Date: 04/29/2010 13:02:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Check_getBedrijfByNaam_Tag_ID]
	@naam nvarchar(1000),
	@tag nvarchar(1000),
	@ID int 

AS
BEGIN
	
	SET NOCOUNT ON;
--DIT WORDT UITGEVOERD BIJ EEN UPDATE OM NA TE GAAN OF ER AL EEN BEDRIJF MET DIE NAAM OF TAG BESTAAT AANGEZIEN WE GEEN DUBBELE MOGEN HEBBEN..
    select * from tblBedrijf where (naam=@naam or tag=@tag) AND bedrijfID != @ID ;
END
GO
/****** Object:  StoredProcedure [dbo].[Manual_InsertBedrijf]    Script Date: 04/29/2010 13:02:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Manual_InsertBedrijf] 
	@naam nvarchar(1000),
	@tag nvarchar(1000)
AS
BEGIN
--INSERT EEN BEDRIJF IN tblBedrijf
	INSERT INTO tblBedrijf(Naam, Tag)
	VALUES( @naam, @tag);

	SELECT SCOPE_IDENTITY();

END
GO
/****** Object:  StoredProcedure [dbo].[Manual_GetAllBedrijf]    Script Date: 04/29/2010 13:02:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Manual_GetAllBedrijf]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
--HAAL ALLE BEDRIJVEN OP UIT DE TABEL tblBedrijf
	SELECT * FROM tblBedrijf;
END
GO
/****** Object:  StoredProcedure [dbo].[Manual_GetBedrijfByID]    Script Date: 04/29/2010 13:02:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Manual_GetBedrijfByID]
@id INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
--HAAL EEN BEDRIJF OP DMV ZIJN ID
	SELECT * FROM tblBedrijf WHERE BedrijfID = @id;
END
GO
