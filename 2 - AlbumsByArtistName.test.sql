USE [Chinook]
GO
/****** Object:  StoredProcedure [MusicTests].[test AlbumsForArtistByName returns the albums for the given artist]    Script Date: 03/02/2015 12:28:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [MusicTests].[test AlbumsForArtistByName returns the albums for the given artist]
AS
BEGIN
	-- Arrange
	CREATE TABLE #actual (
		AlbumTitle NVARCHAR(160)
	);

	-- Act
	INSERT INTO #actual EXEC dbo.AlbumsForArtistByName @artistName = N'Guns N'' Roses';

	-- Assert
	CREATE TABLE #expected (
		AlbumTitle NVARCHAR(160)
	);

	INSERT INTO #expected (AlbumTitle) VALUES (N'Appetite for Destruction');
	INSERT INTO #expected (AlbumTitle) VALUES (N'Use Your Illusion I');
	INSERT INTO #expected (AlbumTitle) VALUES (N'Use Your Illusion II');

	EXEC tSQLt.AssertEqualsTable
		@Expected = '#expected',
	    @Actual = '#actual'
END;
