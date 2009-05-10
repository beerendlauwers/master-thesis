CREATE PROCEDURE STORED_PROCEDURE_updatestudent
	@tempNaam VARCHAR(50), @tempVoornaam VARCHAR(50), @tempGSM VARCHAR(50),
	@tempSchoolmail VARCHAR(50), @tempPrivemail VARCHAR(50), @tempGebDat DATETIME, 
	@tempFinRek VARCHAR(20), @tempStudentID INT
AS
BEGIN
	SET DATEFORMAT dmy
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	UPDATE tblStudent
	SET StudentNaam = @tempNaam, StudentVoornaam = @tempVoornaam, StudentGSM = @tempGSM ,
	StudentSchoolEmail = @tempSchoolmail, StudentPriveEmail = @tempPrivemail,
	StudentGebDat = @tempGebDat, StudentFinRek = @tempFinRek
	WHERE StudentID = @tempStudentID
END