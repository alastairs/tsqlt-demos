EXEC tsqlt.NewTestClass @ClassName = N'DoesItWork' -- nvarchar(max)
GO

CREATE PROCEDURE DoesItWork.[test tSQLt works properly]
AS
BEGIN
	CREATE TABLE [Album.Expected] (
		[AlbumId] [INT] IDENTITY(1,1) NOT NULL,
		[Title] [NVARCHAR](160) NOT NULL,
		[ArtistId] [INT] NOT NULL
	);

	EXEC tSQLt.AssertResultSetsHaveSameMetaData @expectedCommand = N'SELECT * FROM dbo.[Album.Expected]', -- nvarchar(max)
	    @actualCommand = N'SELECT * FROM dbo.Album' -- nvarchar(max)
END;
GO

EXEC tsqlt.RunTestClass @TestClassName = N'DoesItWork' -- nvarchar(max)
;