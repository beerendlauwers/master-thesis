SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE STORED_PROCEDURE_nieuwesport
	@tempSport VARCHAR(50), @tempSportID INT OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	INSERT INTO tblSport(SportNaam) VALUES(@tempSport)
	SELECT @@IDENTITY AS [@@IDENTITY]
	SET @tempSportID = @@IDENTITY
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE STORED_PROCEDURE_updatesport
	@tempSport VARCHAR(50), @tempSportID INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	UPDATE tblSport SET SportNaam = @tempSport WHERE SportID = @tempSportID
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE STORED_PROCEDURE_verwijdersport
	@tempSportID INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DELETE FROM tblSport WHERE @tempSportID = SportID
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE STORED_PROCEDURE_verwijderstudent
	@tempStudentID INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DELETE FROM tblStudent WHERE @tempStudentID = StudentID
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
SET DATEFORMAT dmy
GO
CREATE PROCEDURE STORED_PROCEDURE_updatestudent
	@tempNaam VARCHAR(50), @tempVoornaam VARCHAR(50), @tempGSM VARCHAR(50),
	@tempSchoolmail VARCHAR(50), @tempPrivemail VARCHAR(50), @tempGebDat DATETIME, 
	@tempFinRek VARCHAR(20), @tempStudentID INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	UPDATE tblStudent
	SET StudentNaam = @tempNaam, StudentVoornaam = @tempVoornaam, StudentGSM = @tempGSM ,
	StudentSchoolEmail = @tempSchoolmail, StudentPriveEmail = @tempPrivemail,
	StudentGebDat = @tempGebDat, StudentFinRek = @tempFinRek
	WHERE StudentID = @tempStudentID
END
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE STORED_PROCEDURE_tblstudentinlezen
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT * FROM tblStudent
END
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE STORED_PROCEDURE_tblsportinlezen
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT * FROM tblSport
END
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE STORED_PROCEDURE_tblniveauinlezen
AS
BEGIN
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT * FROM tblNiveau
END
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE STORED_PROCEDURE_tbldoetsportinlezen
AS
BEGIN
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT * FROM tblDoetSport
END
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
SET DATEFORMAT dmy
GO
CREATE PROCEDURE STORED_PROCEDURE_nieuwestudent
	@tempNaam VARCHAR(50), @tempVoornaam VARCHAR(50), @tempGSM VARCHAR(50),
	@tempSchoolmail VARCHAR(50), @tempPrivemail VARCHAR(50), @tempGebDat DATETIME, 
	@tempFinRek VARCHAR(20), @tempStudentID INT OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	INSERT INTO tblStudent( StudentNaam , StudentVoornaam , StudentGSM ,
	StudentSchoolEmail , StudentPriveEmail, StudentGebDat, StudentFinRek )
	VALUES (@tempNaam, @tempVoornaam, @tempGSM, @tempSchoolmail, @tempPrivemail,
	@tempGebDat, @tempFinRek)

	SELECT @@IDENTITY AS [@@IDENTITY]
	SET @tempStudentID = @@IDENTITY
END
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE STORED_PROCEDURE_nieuwniveau 
	@tempNiveau VARCHAR(50), @tempNiveauID INT OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	INSERT INTO tblNiveau(Niveau) VALUES(@tempNiveau)
	SELECT @@IDENTITY AS [@@IDENTITY]
	SET @tempNiveauID = @@IDENTITY
END
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE STORED_PROCEDURE_nieuwedeelname
	-- Add the parameters for the stored procedure here
	@tempSportID INT, @tempStudentID  INT, @tempNiveauID INT
AS
BEGIN

	SET NOCOUNT ON;

	INSERT INTO tblDoetSport(SportID,LidID,NiveauID)
	SELECT A.SportID, B.StudentID, C.NiveauID
	FROM (SELECT SportID FROM tblSport WHERE SportID = @tempSportID) A,
	(SELECT StudentID FROM tblStudent WHERE StudentID = @tempStudentID) B,
	(SELECT NiveauID FROM tblNiveau WHERE NiveauID = @tempNiveauID) C
END
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE STORED_PROCEDURE_tbldoetsportdatagrid
	
AS
BEGIN
	
	SET NOCOUNT ON;
	SELECT StudentNaam, SportNaam, Niveau
	FROM tblDoetSport inner join tblStudent ON (tblDoetSport.LidID = tblStudent.StudentID) 
	inner join tblSport ON (tblDoetSport.SportID = tblSport.SportID) 
	inner join tblNiveau ON (tblDoetSport.NiveauID = tblNiveau.NiveauID);
  
END
GO


