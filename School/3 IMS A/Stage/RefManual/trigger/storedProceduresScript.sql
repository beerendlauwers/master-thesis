USE [Reference_manual]
GO
/****** Object:  StoredProcedure [dbo].[Manual_getCategorieByParent]    Script Date: 04/28/2010 09:25:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Manual_getCategorieByParent]
	@FK_Parent int
AS
BEGIN
	
	SET NOCOUNT ON;

    select * from tblCategorie where FK_Parent=@FK_Parent
END
GO
/****** Object:  StoredProcedure [dbo].[Manual_getCategorieZonderRoot]    Script Date: 04/28/2010 09:25:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Manual_getCategorieZonderRoot] 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    select * from tblCategorie where Categorie!='root_node'
END
GO
/****** Object:  StoredProcedure [dbo].[Check_CategorieByID]    Script Date: 04/28/2010 09:24:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Check_CategorieByID] 
	@catnaam VARCHAR(255),
	@versie INT,
	@bedrijf INT, 
	@taal INT,
	@ID INT
AS
BEGIN
	
	SET NOCOUNT ON;

    SELECT * FROM tblCategorie
	WHERE Categorie = @catnaam AND FK_versie = @versie AND FK_bedrijf = @bedrijf AND FK_taal = @taal AND CategorieID! = @ID;
END
GO
/****** Object:  StoredProcedure [dbo].[Manual_getVideoByID]    Script Date: 04/28/2010 09:25:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Manual_getVideoByID]
@videoID int
AS
BEGIN
	
	SET NOCOUNT ON;

    select * from tblVideo where VideoID=@VideoID
END
GO
/****** Object:  StoredProcedure [dbo].[Manual_InsertCategorie]    Script Date: 04/28/2010 09:25:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Manual_InsertCategorie] 
	@catnaam VARCHAR(255),
	@diepte INT,
	@hoogte INT,
	@FK_parent INT,
	@FK_taal INT,
	@FK_bedrijf INT,
	@FK_versie INT
AS
BEGIN
	
	INSERT INTO tblCategorie(Categorie,Diepte,Hoogte,FK_parent,FK_taal,FK_bedrijf,FK_versie)
	VALUES( @catnaam, @diepte, @hoogte, @fk_parent, @fk_taal, @fk_bedrijf, @fk_versie);

	SELECT SCOPE_IDENTITY();

END
GO
/****** Object:  StoredProcedure [dbo].[Manual_GetAllTaal]    Script Date: 04/28/2010 09:24:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Manual_GetAllTaal]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT * FROM tblTaal;
END
GO
/****** Object:  StoredProcedure [dbo].[Manual_GetAllVersie]    Script Date: 04/28/2010 09:24:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Manual_GetAllVersie]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT * FROM tblVersie;
END
GO
/****** Object:  StoredProcedure [dbo].[Manual_GetAllBedrijf]    Script Date: 04/28/2010 09:24:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Manual_GetAllBedrijf]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT * FROM tblBedrijf;
END
GO
/****** Object:  StoredProcedure [dbo].[Manual_GetAllCategorieBy]    Script Date: 04/28/2010 09:24:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Manual_GetAllCategorieBy]
	@taal INT, @bedrijf INT, @versie INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

SELECT * FROM tblCategorie WHERE (FK_Taal = @taal AND FK_Versie = @versie AND FK_Bedrijf = @bedrijf) OR Categorie = 'root_node';
END
GO
/****** Object:  StoredProcedure [dbo].[Manual_GetArtikelsByParent]    Script Date: 04/28/2010 09:24:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Manual_GetArtikelsByParent]
	@categorieID INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT * FROM tblArtikel WHERE FK_categorie = @categorieID
END
GO
/****** Object:  StoredProcedure [dbo].[Util_SplitString]    Script Date: 04/28/2010 09:25:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Util_SplitString]
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
/****** Object:  StoredProcedure [dbo].[Manual_getHoogte]    Script Date: 04/28/2010 09:25:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Manual_getHoogte] 
	@categorieID int, @bedrijfID int, @versieID int, @taalID int
AS
BEGIN
	
	SET NOCOUNT ON;

    
	SELECT * from tblCategorie where FK_parent=@categorieID AND FK_taal = @taalID AND FK_bedrijf = @bedrijfID AND FK_versie = @versieID AND hoogte >= (select max(hoogte) from tblCategorie where FK_Parent=@CategorieID AND FK_taal = @taalID AND FK_bedrijf = @bedrijfID AND FK_versie = @versieID)
END
GO
/****** Object:  StoredProcedure [dbo].[Manual_getCategorieByID]    Script Date: 04/28/2010 09:25:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Manual_getCategorieByID]
	@categorieID int
AS
BEGIN
	
	SET NOCOUNT ON;
	select * from tblCategorie where CategorieID=@CategorieID
END
GO
/****** Object:  StoredProcedure [dbo].[Manual_GetBedrijfByID]    Script Date: 04/28/2010 09:25:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Manual_GetBedrijfByID]
@id INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT * FROM tblBedrijf WHERE BedrijfID = @id;
END
GO
/****** Object:  StoredProcedure [dbo].[Manual_updateHoogte]    Script Date: 04/28/2010 09:25:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Manual_updateHoogte]
	@FK_parent int,
	@hoogte int
AS
BEGIN

	SET NOCOUNT ON;

    UPDATE tblCategorie set hoogte= hoogte + 1 where FK_parent=@FK_parent AND hoogte>=@hoogte
END
GO
/****** Object:  StoredProcedure [dbo].[Manual_GetVersieByID]    Script Date: 04/28/2010 09:25:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Manual_GetVersieByID]
@id INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT * FROM tblVersie WHERE VersieID = @id;
END
GO
/****** Object:  StoredProcedure [dbo].[Manual_GetTaalByID]    Script Date: 04/28/2010 09:25:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Manual_GetTaalByID]
@id INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT * FROM tblTaal WHERE TaalID = @id;
END
GO
/****** Object:  StoredProcedure [dbo].[Check_Module]    Script Date: 04/28/2010 09:24:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Check_Module] 
	@module varchar(50)
	
AS
BEGIN
	
	SET NOCOUNT ON;

    select * from tblModule where module = @module;
END
GO
/****** Object:  StoredProcedure [dbo].[Check_ModuleByID]    Script Date: 04/28/2010 09:24:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Check_ModuleByID] 
	@module varchar(50),
	@id INT
	
AS
BEGIN
	
	SET NOCOUNT ON;

    select * from tblModule where module = @module AND moduleID! = @id;
END
GO
/****** Object:  StoredProcedure [dbo].[Manual_GetModuleByID]    Script Date: 04/28/2010 09:25:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Manual_GetModuleByID] 
	@id INT
AS
BEGIN
	
	SET NOCOUNT ON;

    select * from tblModule where moduleID = @id;
END
GO
/****** Object:  StoredProcedure [dbo].[Manual_getAllModules]    Script Date: 04/28/2010 09:24:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Manual_getAllModules]
AS


BEGIN
	
	SET NOCOUNT ON;
  
	SELECT module AS tag from tblModule ORDER by module
END
GO
/****** Object:  StoredProcedure [dbo].[Check_ArtikelsbyModule]    Script Date: 04/28/2010 09:24:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Check_ArtikelsbyModule] 
	@ModuleID int
AS
DECLARE @Module Varchar(50)
BEGIN
	SET NOCOUNT ON;
SET @Module = (select Module from tblModule where ModuleID=@ModuleID)
    
	SELECT * from tblArtikel where dbo.getModule(tag)=@Module
END
GO
/****** Object:  StoredProcedure [dbo].[onUpdateModule]    Script Date: 04/28/2010 09:25:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[onUpdateModule]
	@oudeModule Varchar(50),
	@nieuweModule Varchar(50)
AS
DECLARE @NieuweTag varchar(100)
DECLARE @oudeTag Varchar(100)
DECLARE @Var varchar(255)
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
/****** Object:  StoredProcedure [dbo].[onUpdateBedrijf]    Script Date: 04/28/2010 09:25:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[onUpdateBedrijf]
	@oudBedrijf Varchar(50),
	@nieuwBedrijf Varchar(50)
AS
DECLARE @NieuweTag varchar(100)
DECLARE @oudeTag Varchar(100)
DECLARE @Var varchar(255)
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
/****** Object:  StoredProcedure [dbo].[onUpdateVersie]    Script Date: 04/28/2010 09:25:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[onUpdateVersie]
	@oudeVersie Varchar(50),
	@nieuweVersie Varchar(50)
AS
DECLARE @NieuweTag varchar(100)
DECLARE @oudeTag Varchar(100)
DECLARE @Var varchar(255)
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
/****** Object:  StoredProcedure [dbo].[onUpdateTaalTag]    Script Date: 04/28/2010 09:25:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[onUpdateTaalTag]
	@oudeTaalTag Varchar(50),
	@nieuweTaalTag Varchar(50)
AS
DECLARE @NieuweTag varchar(100)
DECLARE @oudeTag Varchar(100)
DECLARE @Var varchar(255)
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
/****** Object:  StoredProcedure [dbo].[Manual_getVideoByNaam]    Script Date: 04/28/2010 09:25:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Manual_getVideoByNaam]
	@videoNaam varchar(255)
AS
BEGIN
	
	SET NOCOUNT ON;

    select * from tblVideo where videoNaam=@videoNaam
END
GO
/****** Object:  StoredProcedure [dbo].[Manual_getAllVideos]    Script Date: 04/28/2010 09:24:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Manual_getAllVideos]
AS
BEGIN
	
	SET NOCOUNT ON;

    SELECT * FROM tblVideo;
END
GO
/****** Object:  StoredProcedure [dbo].[Manual_getArtikelsByModule]    Script Date: 04/28/2010 09:24:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Manual_getArtikelsByModule]
	@Module Varchar(50),
	@FK_taal int,
	@FK_versie int,
	@FK_Bedrijf int
AS
BEGIN
	
	SET NOCOUNT ON;

	SELECT * from tblArtikel where dbo.getModule(tag) = @Module and FK_Versie = @FK_versie and FK_taal=@FK_taal and FK_Bedrijf=@FK_Bedrijf ORDER BY titel

END
GO
/****** Object:  StoredProcedure [dbo].[Manual_getModulesMetArtikels]    Script Date: 04/28/2010 09:25:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Manual_getModulesMetArtikels]
	@FK_taal int,
	@FK_Versie int,
	@FK_Bedrijf int
AS


BEGIN
	
	SET NOCOUNT ON;

    
	SELECT DISTINCT dbo.getModule(tag) AS tag from tblArtikel where  FK_Taal=@FK_Taal and FK_Versie = @FK_Versie and FK_Bedrijf=@FK_Bedrijf 
END
GO
/****** Object:  StoredProcedure [dbo].[Manual_GetRootNode]    Script Date: 04/28/2010 09:25:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Manual_GetRootNode] 
AS
BEGIN
	
	SET NOCOUNT ON;

    SELECT * from tblCategorie WHERE categorie = 'root_node';
END
GO
/****** Object:  StoredProcedure [dbo].[Check_CategorieByTaal]    Script Date: 04/28/2010 09:24:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Check_CategorieByTaal] 
	@taal INT
AS
BEGIN
	
	SET NOCOUNT ON;

    SELECT * FROM tblCategorie WHERE FK_taal=@taal;
END
GO
/****** Object:  StoredProcedure [dbo].[Check_CategorieByBedrijf]    Script Date: 04/28/2010 09:24:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Check_CategorieByBedrijf]
	@bedrijf INT
AS
BEGIN
	
	SET NOCOUNT ON;

    SELECT * FROM tblCategorie WHERE FK_bedrijf=@bedrijf;
END
GO
/****** Object:  StoredProcedure [dbo].[Manual_GetCategorieByVersie]    Script Date: 04/28/2010 09:25:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Manual_GetCategorieByVersie] 
	@versie int
AS
BEGIN
	
	SET NOCOUNT ON;

    SELECT * FROM tblCategorie WHERE FK_Versie=@versie;
END
GO
/****** Object:  StoredProcedure [dbo].[Check_Categorie]    Script Date: 04/28/2010 09:24:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Check_Categorie] 
	@catnaam varchar(255),
	@versie int,
	@bedrijf int,
	@taal INT
AS
BEGIN
	
	SET NOCOUNT ON;

    SELECT * FROM tblCategorie WHERE Categorie=@catnaam AND FK_bedrijf=@bedrijf AND FK_Versie=@versie AND FK_taal=@taal;
END
GO
/****** Object:  StoredProcedure [dbo].[Manual_getTitelByTag]    Script Date: 04/28/2010 09:25:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Manual_getTitelByTag]
	@Tag varchar(50)
AS
Declare @TaalID int
DECLARE @TITEL AS VARCHAR(50)
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
/****** Object:  StoredProcedure [dbo].[Manual_UpdateTagTalen]    Script Date: 04/28/2010 09:25:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Manual_UpdateTagTalen]
	@NieuweTag Varchar(50),
	@OudeTag Varchar(50),
	@Versie int,
	@Bedrijf int
	
AS
DECLARE @VersieID int
DECLARE @BedrijfID int
DECLARE @Versienaam varchar(50)
DECLARE @bedrijfnaam varchar(50)
DECLARE @InTag Varchar(50)
DECLARE @FK_Taal int
DECLARE	@Taal varchar(50)
DECLARE @ID int
DECLARE @Tag varchar(50)

IF @Bedrijf=-1 AND @Versie=-1 
BEGIN
DECLARE c1 cursor FOR select ArtikelID,tag,FK_Taal,FK_Versie,FK_Bedrijf from tblArtikel where dbo.getSimpleTag(tag) = dbo.getSimpleTag(@OudeTag)
open c1;
FETCH NEXT FROM c1 into	@ID,@Tag,@FK_Taal,@VersieID,@BedrijfID
WHILE @@FETCH_STATUS = 0
BEGIN
SET @Taal = (select taalTag from tblTaal where TaalID=@FK_Taal)
SET @Versienaam = (select versie from tblVersie where VersieID=@VersieID)
SET @bedrijfnaam=(select naam from tblBedrijf where BedrijfID=@BedrijfID)
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
SET @bedrijfnaam=(select naam from tblBedrijf where BedrijfID=@BedrijfID)
SET @InTag = @Versienaam + '_' + @Taal + '_' + @bedrijfnaam + '_' + dbo.getSimpleTag(@NieuweTag)
UPDATE tblArtikel SET tag = @InTag WHERE artikelID=@ID
FETCH NEXT FROM c1 into @ID,@Tag,@FK_Taal,@VersieID,@BedrijfID
END

END
GO
/****** Object:  StoredProcedure [dbo].[Manual_MaakTalenTabel]    Script Date: 04/28/2010 09:25:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Manual_MaakTalenTabel]
	
AS
DECLARE @FK_Taal int
DECLARE @ArtikelID int
DECLARE @Teller int
DECLARE @Tag Varchar(50)
DECLARE @BedrijfID VARCHAR(600)
DECLARE @VersieID VARCHAR(600)
DECLARE @Taal Varchar(50)
DECLARE @Var NVarchar(1000)
DECLARE @TaalCount VARCHAR(50)
DECLARE @TaalFetch VARCHAR(600)

BEGIN

DROP TABLE tblVglTaal
CREATE TABLE tblVglTaal(VersieID int,BedrijfID int,Tag Varchar(50))

--tblVglTaal AANMAKEN

DECLARE cTalen cursor FOR select TaalID from tblTaal
open cTalen;
FETCH NEXT FROM cTalen into @FK_Taal
WHILE @@FETCH_STATUS = 0
BEGIN
SET @Taal = (select Taal from tblTaal where Taalid=@FK_Taal)
SET @Var = 'ALTER TABLE tblVglTaal ADD ' + @Taal + ' int;'
EXEC(@Var)
FETCH NEXT FROM cTalen into @FK_Taal
END
close cTalen
DEALLOCATE cTalen
DELETE FROM tblVglTaal

--tblVglTaal VULLEN


SET NOCOUNT ON;
DECLARE cVersie cursor for select versieID from tblVersie
open cVersie;
FETCH NEXT FROM cVersie into @VersieID
WHILE @@FETCH_STATUS = 0
BEGIN
if @VersieID>0
BEGIN
	print(@VersieID)
END
DECLARE cBedrijf cursor for select BedrijfID from tblBedrijf
open cBedrijf;
FETCH NEXT FROM cBedrijf into @BedrijfID
WHILE @@FETCH_STATUS=0
BEGIN
	DECLARE cTalen cursor FOR select TaalID from tblTaal
	open cTalen;
	FETCH NEXT FROM cTalen into @FK_Taal
	WHILE @@FETCH_STATUS = 0
	BEGIN
		DECLARE c1 cursor FOR select dbo.getSimpleTag(tag) from tblArtikel where FK_Taal = @FK_Taal and FK_Bedrijf=@BedrijfID and FK_Versie=@VersieID
		open c1;
		FETCH NEXT FROM c1 into @Tag	
		WHILE @@FETCH_STATUS = 0
		BEGIN
			SET @Teller = (select count(*) from tblVglTaal where tag = @Tag and versieID=@VersieID and BedrijfID=@BedrijfID)
			--if @Teller>0 
			--BEGIN
			--	print(@Tag)
			--	print(@VersieID)
			--	print(@BedrijfID)
			--END
			if @Teller = 0
			BEGIN
			DECLARE cTalen1 cursor FOR select taalID from tblTaal
			SET @Var = 'INSERT INTO tblVglTaal VALUES(' + @VersieID + ',' + @BedrijfID + ',''' + @Tag + ''''
			open cTalen1;
			FETCH NEXT FROM cTalen1 into @FK_Taal
			WHILE @@FETCH_STATUS = 0
			BEGIN
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
/****** Object:  StoredProcedure [dbo].[Manual_GetArtikelByID]    Script Date: 04/28/2010 09:24:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Manual_GetArtikelByID] 
	@id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT * from tblArtikel where ArtikelID = @id;
END
GO
/****** Object:  StoredProcedure [dbo].[Manual_deleteArtikelbyID]    Script Date: 04/28/2010 09:24:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Manual_deleteArtikelbyID]
	@artikelID int
AS
BEGIN

	SET NOCOUNT ON;

    DELETE FROM tblArtikel Where artikelID=@artikelID
END
GO
/****** Object:  StoredProcedure [dbo].[Manual_updateArtikel]    Script Date: 04/28/2010 09:25:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Manual_updateArtikel]
	@artikelID int,
	@Titel varchar(255),
	@FK_Categorie int,
	@FK_Taal int,
	@FK_Bedrijf int,
	@FK_Versie int,
	@Tekst nvarchar(max),
	@tag varchar(255),
	@Is_final int
AS
BEGIN
	
	SET NOCOUNT ON;

    update tblArtikel set Titel=@Titel, FK_Categorie=@FK_Categorie, FK_Taal=@FK_Taal, FK_Bedrijf=@FK_Bedrijf, FK_Versie=@FK_Versie, Tekst=@Tekst, Tag=@tag, Is_final=@Is_final WHERE artikelID=@ArtikelID
END
GO
/****** Object:  StoredProcedure [dbo].[Manual_GetArtikelByTag]    Script Date: 04/28/2010 09:24:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Manual_GetArtikelByTag] 
	@tag varchar(255)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT * from tblArtikel where Tag = @tag;
END
GO
/****** Object:  StoredProcedure [dbo].[Check_ArtikelByTagByID]    Script Date: 04/28/2010 09:24:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Check_ArtikelByTagByID] 
	@tag VARCHAR(255),
	@versie int,
	@bedrijf int,
	@taal int,
	@ArtikelID int
AS
BEGIN
	
	SET NOCOUNT ON;

    SELECT * FROM tblArtikel WHERE Tag=@tag AND FK_bedrijf=@bedrijf AND FK_Versie=@versie AND FK_taal=@taal and ArtikelID<>@ArtikelID;
END
GO
/****** Object:  StoredProcedure [dbo].[Manual_getArtikelByTekst]    Script Date: 04/28/2010 09:24:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Manual_getArtikelByTekst] 
	@tekst as varchar(255)	
AS
BEGIN
	
	SET NOCOUNT ON;

	SELECT * from tblArtikel where contains(tekst,@tekst);
END
GO
/****** Object:  StoredProcedure [dbo].[Manual_getArtikelsByVersie]    Script Date: 04/28/2010 09:25:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Manual_getArtikelsByVersie]
	@VersieID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	select * from tblArtikel Where FK_Versie=@VersieID
END
GO
/****** Object:  StoredProcedure [dbo].[Manual_getArtikelsByTaal]    Script Date: 04/28/2010 09:24:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Manual_getArtikelsByTaal]
	@TaalID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    select * from tblArtikel where FK_Taal = @TaalID
END
GO
/****** Object:  StoredProcedure [dbo].[Manual_getArtikelsByBedrijf]    Script Date: 04/28/2010 09:24:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Manual_getArtikelsByBedrijf]
	@BedrijfID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    select * from tblArtikel where FK_Bedrijf=@BedrijfID
END
GO
/****** Object:  StoredProcedure [dbo].[Manual_GetArtikelGegevensByTag]    Script Date: 04/28/2010 09:24:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Manual_GetArtikelGegevensByTag] 
	@tag VARCHAR(255),
	@isfinal VARCHAR(255),
	@versies VARCHAR(255),
	@bedrijven VARCHAR(255),
	@talen VARCHAR(255)
AS
BEGIN
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
/****** Object:  StoredProcedure [dbo].[Manual_GetArtikelGegevensByTitel]    Script Date: 04/28/2010 09:24:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Manual_GetArtikelGegevensByTitel] 
	@titel VARCHAR(255),
	@isfinal VARCHAR(255),
	@versies VARCHAR(255),
	@bedrijven VARCHAR(255),
	@talen VARCHAR(255)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

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
/****** Object:  StoredProcedure [dbo].[Manual_GetArtikelsByTitel_Versie_Bedrijf_Taal]    Script Date: 04/28/2010 09:24:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Manual_GetArtikelsByTitel_Versie_Bedrijf_Taal] 
	@titel VARCHAR(255), @versie INT, @bedrijf INT, @taal INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT * from tblArtikel where FK_versie = @versie AND FK_bedrijf = @bedrijf AND FK_TAAL = @taal AND titel LIKE @titel;
END
GO
/****** Object:  StoredProcedure [dbo].[Manual_getArtikelByTekst_Versie_Bedrijf_Taal]    Script Date: 04/28/2010 09:24:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Manual_getArtikelByTekst_Versie_Bedrijf_Taal] 
	@tekst NVARCHAR(2048), @versie INT, @bedrijf INT, @taal INT
AS
BEGIN
	
	SET NOCOUNT ON;

	SELECT * FROM tblArtikel WHERE CONTAINS(tekst,@tekst) AND FK_versie = @versie AND FK_bedrijf = @bedrijf AND FK_taal = @taal;
END
GO
/****** Object:  StoredProcedure [dbo].[Manual_GetArtikelGegevensByTekst]    Script Date: 04/28/2010 09:24:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Manual_GetArtikelGegevensByTekst] 
	@tekst VARCHAR(2048),
	@isfinal VARCHAR(255),
	@versies VARCHAR(255),
	@bedrijven VARCHAR(255),
	@talen VARCHAR(255)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

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
/****** Object:  StoredProcedure [dbo].[Manual_UpdateTag]    Script Date: 04/28/2010 09:25:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Manual_UpdateTag] 
@FK_Taal int
AS
DECLARE @Teller int
DECLARE @Tag Varchar(100)
DECLARE @String NVarchar(100)
DECLARE @ArtikelID int
DECLARE @ArtikelID2 int
DECLARE @ID1 int
DECLARE @ID2 int
declare @idstring varchar(50)
set @idstring = 'DTA/FINAN'
declare @idstring2 varchar(50)
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
/****** Object:  StoredProcedure [dbo].[Manual_getUitzonderingen]    Script Date: 04/28/2010 09:25:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Manual_getUitzonderingen] @FK_Taal int,@IDstring varchar(50),@ID int output
AS

BEGIN
	SET NOCOUNT ON;
	Set @ID = (select ArtikelID from tblArtikel where FK_Taal = @FK_Taal and substring(tag,4,9) = @IDstring)
END
GO
/****** Object:  StoredProcedure [dbo].[Manual_getArtikelsByTitel]    Script Date: 04/28/2010 09:24:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Manual_getArtikelsByTitel] 
	@titel varchar(255)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT * from tblArtikel where titel LIKE @titel;
END
GO
/****** Object:  StoredProcedure [dbo].[Check_Artikel]    Script Date: 04/28/2010 09:24:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Check_Artikel] 
	@titel varchar(255),
	@versie int,
	@bedrijf int,
	@taal INT
AS
BEGIN
	
	SET NOCOUNT ON;

    SELECT * FROM tblArtikel WHERE Titel=@titel AND FK_bedrijf=@bedrijf AND FK_Versie=@versie AND FK_taal=@taal;
END
GO
/****** Object:  StoredProcedure [dbo].[Check_ArtikelByID]    Script Date: 04/28/2010 09:24:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Check_ArtikelByID] 
	@titel varchar(255),
	@versie int,
	@bedrijf int,
	@taal INT,
	@ID INT
AS
BEGIN
	
	SET NOCOUNT ON;

    SELECT * FROM tblArtikel WHERE Titel=@titel AND FK_bedrijf=@bedrijf AND FK_Versie=@versie AND FK_taal=@taal AND ArtikelID! = @ID;
END
GO
/****** Object:  StoredProcedure [dbo].[Check_ArtikelByTag]    Script Date: 04/28/2010 09:24:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Check_ArtikelByTag] 
	@tag VARCHAR(255),
	@versie int,
	@bedrijf int,
	@taal INT
AS
BEGIN
	
	SET NOCOUNT ON;

    SELECT * FROM tblArtikel WHERE Tag=@tag AND FK_bedrijf=@bedrijf AND FK_Versie=@versie AND FK_taal=@taal;
END
GO
/****** Object:  StoredProcedure [dbo].[Manual_getArtikelTekst]    Script Date: 04/28/2010 09:25:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Manual_getArtikelTekst]
	@zoekterm VARCHAR(50),
	@tag VARCHAR(50)
AS
DECLARE @ArtikelTekst NVARCHAR(max)
DECLARE @WeergaveTekst Varchar(255)
--DECLARE @index int
BEGIN
	
	SET NOCOUNT ON;
	SET @ArtikelTekst = (SELECT tekst from tblArtikel where tag= @Tag)

	SET @weergaveTekst = (select substring(Tekst,charindex(@Zoekterm,@ArtikelTekst,60),150) from tblArtikel where tag=@tag)
SELECT @weergaveTekst
END
GO
/****** Object:  StoredProcedure [dbo].[Manual_theUltimateGet]    Script Date: 04/28/2010 09:25:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Manual_theUltimateGet] 
	@bedrijfID int,
	@versieID int,
	@TaalID int,
	@tekst varchar(255)


	
AS
DECLARE @find varchar(30);
BEGIN

	SET NOCOUNT ON;
	SET @find = '"*' + @tekst + '*"'
   select A.titel,A.tag,A.Tekst,V.Versie,T.taal 
   from tblArtikel A, tblVersie V, tblTaal T 
   where (contains(tekst, @find)OR titel LIKE '%' + @tekst +'%') AND (FK_Bedrijf=0 or FK_Bedrijf=@bedrijfID) AND (FK_Versie=@VersieID) AND (FK_Taal=@TaalID)
	AND A.FK_Versie=V.VersieID AND A.FK_Taal=T.TaalID
END
GO
/****** Object:  StoredProcedure [dbo].[Check_versie]    Script Date: 04/28/2010 09:24:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Check_versie] 
	@versie varchar(50)
AS
BEGIN
	
	SET NOCOUNT ON;

    select * from tblVersie where Versie=@versie
END
GO
/****** Object:  StoredProcedure [dbo].[Check_versieByID]    Script Date: 04/28/2010 09:24:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Check_versieByID] 
	@versie varchar(50),
	@ID int
AS
BEGIN
	
	SET NOCOUNT ON;

    select * from tblVersie where versie=@versie AND versieID!=@ID
END
GO
/****** Object:  StoredProcedure [dbo].[Manual_InsertVersie]    Script Date: 04/28/2010 09:25:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Manual_InsertVersie] 
	@versie VARCHAR(50)
AS
BEGIN
	
	INSERT INTO tblVersie(Versie)
	VALUES( @versie);

	SELECT SCOPE_IDENTITY();

END
GO
/****** Object:  StoredProcedure [dbo].[Manual_InsertTaal]    Script Date: 04/28/2010 09:25:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Manual_InsertTaal] 
	@taal VARCHAR(50),
	@taaltag VARCHAR(50)
AS
BEGIN
	
	INSERT INTO tblTaal(Taal, TaalTag)
	VALUES( @taal, @taaltag);

	SELECT SCOPE_IDENTITY();

END
GO
/****** Object:  StoredProcedure [dbo].[Check_Taal]    Script Date: 04/28/2010 09:24:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Check_Taal] 
	@taal varchar(50),
	@taaltag varchar(50)
	
AS
BEGIN
	
	SET NOCOUNT ON;

    select * from tblTaal where taal=@taal OR taaltag=@taaltag
END
GO
/****** Object:  StoredProcedure [dbo].[Check_TaalByID]    Script Date: 04/28/2010 09:24:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Check_TaalByID] 
	@taal varchar(50),
	@taaltag varchar(50),
	@ID int
	
AS
BEGIN
	
	SET NOCOUNT ON;

    select * from tblTaal where (taal=@taal OR taaltag=@taaltag) AND taalID!=@ID
END
GO
/****** Object:  StoredProcedure [dbo].[Manual_getTaalByNaam]    Script Date: 04/28/2010 09:25:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Manual_getTaalByNaam] 
	@Taal Varchar(50)
AS
BEGIN
	SET NOCOUNT ON;

   
	SELECT * from tblTaal where Taal = @Taal
END
GO
/****** Object:  StoredProcedure [dbo].[Check_getBedrijfByNaam_Tag]    Script Date: 04/28/2010 09:24:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Check_getBedrijfByNaam_Tag]
	@naam varchar(50),
	@tag varchar (50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   select * from tblBedrijf where naam=@naam or tag=@tag
END
GO
/****** Object:  StoredProcedure [dbo].[Check_getBedrijfByNaam_Tag_ID]    Script Date: 04/28/2010 09:24:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Check_getBedrijfByNaam_Tag_ID]
	@naam varchar(50),
	@tag varchar(50),
	@ID int 

AS
BEGIN
	
	SET NOCOUNT ON;

    select * from tblBedrijf where (naam=@naam or tag=@tag) AND bedrijfID != @ID ;
END
GO
/****** Object:  StoredProcedure [dbo].[Manual_InsertBedrijf]    Script Date: 04/28/2010 09:25:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Manual_InsertBedrijf] 
	@naam VARCHAR(255),
	@tag VARCHAR(255)
AS
BEGIN
	
	INSERT INTO tblBedrijf(Naam, Tag)
	VALUES( @naam, @tag);

	SELECT SCOPE_IDENTITY();

END
GO
