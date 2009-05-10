CREATE PROCEDURE STORED_PROCEDURE_verwijderstudent
	@tempStudentID INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DELETE FROM tblStudent WHERE @tempStudentID = StudentID
END