USE [Reference_manual]
GO
/****** Object:  StoredProcedure [dbo].[Check_Categorie]    Script Date: 03/25/2010 09:50:27 ******/
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
	@FK_versie INT,
	@catID INT
AS
BEGIN
	
	INSERT INTO tblCategorie(Categorie,Diepte,Hoogte,FK_parent,FK_taal,FK_bedrijf,FK_versie)
	VALUES( @catnaam, @diepte, @hoogte, @fk_parent, @fk_taal, @fk_bedrijf, @fk_versie);

	SELECT SCOPE_IDENTITY();

END
