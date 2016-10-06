USE [Reference_manual]
GO
/****** Object:  StoredProcedure [dbo].[Check_Categorie]    Script Date: 03/25/2010 09:50:27 ******/
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
