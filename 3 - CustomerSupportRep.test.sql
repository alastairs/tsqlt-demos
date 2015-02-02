EXEC tsqlt.NewTestClass @ClassName = N'CustomerSupport' -- nvarchar(max)
GO

CREATE PROCEDURE CustomerSupport.[test Support Rep Id can't be invalid]
AS
BEGIN
	DECLARE @errorThrown BIT; SET @errorThrown = 0;

	EXEC tSQLt.FakeTable @TableName = N'Customer',
	    @SchemaName = N'dbo';
	EXEC tSQLt.ApplyConstraint @TableName = N'Customer',
	    @ConstraintName = N'FK_CustomerSupportRepId',
	    @SchemaName = N'dbo';
	
	BEGIN TRY
		INSERT INTO dbo.Customer
		        ( FirstName ,
		          LastName ,
		          Company ,
		          Address ,
		          City ,
		          State ,
		          Country ,
		          PostalCode ,
		          Phone ,
		          Fax ,
		          Email ,
		          SupportRepId
		        )
		VALUES  ( N'Alastair' , -- FirstName - nvarchar(40)
		          N'Smith' , -- LastName - nvarchar(20)
		          N'Redgate' , -- Company - nvarchar(80)
		          N'123 Main Street' , -- Address - nvarchar(70)
		          N'Cambridge' , -- City - nvarchar(40)
		          NULL , -- State - nvarchar(40)
		          N'United Kingdom' , -- Country - nvarchar(40)
		          N'CB1 2AB' , -- PostalCode - nvarchar(10)
		          NULL , -- Phone - nvarchar(24)
		          NULL , -- Fax - nvarchar(24)
		          N'chinook@alastairsmith.me.uk' , -- Email - nvarchar(60)
		          0  -- SupportRepId - int
		        )
	END TRY
	BEGIN CATCH
		SET @errorThrown = 1
	END CATCH;

	IF (@errorThrown = 0)
		EXEC tSQLt.Fail @Message0 = N'INSERT succeeded: Should not be able to write a row with an invalid SupportRepId'
	
END;
GO

EXEC tsqlt.RunTestClass @TestClassName = N'CustomerSupport';