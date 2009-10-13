CREATE PROCEDURE STORED_PROCEDURE_nieuwestudent
	@tempNaam VARCHAR(50), @tempVoornaam VARCHAR(50), @tempGSM VARCHAR(50),
	@tempSchoolmail VARCHAR(50), @tempPrivemail VARCHAR(50), @tempGebDat DATETIME, 
	@tempFinRek VARCHAR(20), @tempStudentID INT OUTPUT
AS
BEGIN
	SET DATEFORMAT dmy
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