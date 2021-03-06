IF NOT EXISTS (
	SELECT  schema_name
	FROM    information_schema.schemata
	WHERE   schema_name = 'TestDataBuilder'
)
BEGIN
	EXEC sys.sp_executesql N'CREATE SCHEMA [TestDataBuilder]'
END
GO

CREATE PROCEDURE [TestDataBuilder].[CustomerBuilder]
(
	@FirstName NVARCHAR(40) = N'',
	@LastName NVARCHAR(20) = N'',
	@Company NVARCHAR(80) = N'',
	@Address NVARCHAR(70) = N'',
	@City NVARCHAR(40) = N'',
	@State NVARCHAR(40) = N'',
	@Country NVARCHAR(40) = N'',
	@PostalCode NVARCHAR(10) = N'',
	@Phone NVARCHAR(24) = N'',
	@Fax NVARCHAR(24) = N'',
	@Email NVARCHAR(60) = N'',
	@SupportRepId INT = 0,
	@CustomerId INT = 0 OUT
)
AS
BEGIN
	DECLARE @returnValue INT = 0;
	BEGIN TRY
		IF OBJECTPROPERTY(OBJECT_ID(N'[dbo].[Customer]'), N'TableHasIdentity') = 1
			BEGIN
				-- If we're using the real table, we have to gather the IDENTITY value to
				-- output it from the SPROC.
				INSERT INTO [dbo].[Customer] (
					[FirstName],
					[LastName],
					[Company],
					[Address],
					[City],
					[State],
					[Country],
					[PostalCode],
					[Phone],
					[Fax],
					[Email]
				) VALUES (
					@FirstName,
					@LastName,
					@Company,
					@Address,
					@City,
					@State,
					@Country,
					@PostalCode,
					@Phone,
					@Fax,
					@Email
				)

				SET @CustomerId = SCOPE_IDENTITY();
			END
		ELSE
			BEGIN
				-- If we're using a fake table, it may not have IDENTITY set so we need
				-- to generate a new ID and output it
				SET @CustomerId = COALESCE(@CustomerId, (SELECT MAX(CustomerId) FROM [dbo].[Customer]) + 1, 1);

				INSERT INTO [dbo].[Customer] (
					[FirstName],
					[LastName],
					[Company],
					[Address],
					[City],
					[State],
					[Country],
					[PostalCode],
					[Phone],
					[Fax],
					[Email]
				) VALUES (
					@FirstName,
					@LastName,
					@Company,
					@Address,
					@City,
					@State,
					@Country,
					@PostalCode,
					@Phone,
					@Fax,
					@Email
				)
			END
	END TRY
	BEGIN CATCH
		-- Report any errors via a tSQLt failure.
		DECLARE @ErrorMessage nvarchar(2000) = '[TestDataBuilder].[CustomerBuilder] - ERROR: ' + ERROR_MESSAGE();
        SET @ReturnValue = ERROR_NUMBER()
 
        EXEC tSQLt.Fail @ErrorMessage;
	END CATCH

	RETURN @returnValue;
END;

EXEC TestDataBuilder.CustomerBuilder @FirstName = N'Joe';
GO
