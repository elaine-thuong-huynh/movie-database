-- The idea of this SP is to recommend similar movies based on keywords and genres (either input is okay), sort by vote_average
-- then popularity

Use tmdbMovies
GO

CREATE OR ALTER PROC spFilmRec (@keywords AS NVARCHAR(MAX) = NULL, @genres AS NVARCHAR(MAX) = NULL)
AS
BEGIN
	SELECT DISTINCT Title, Release_date, Overview, Vote_average, Popularity
	FROM film f
	LEFT JOIN film_genres fg ON f.FilmID = fg.FilmId
	LEFT JOIN genres g ON fg.GenreId = g.GenreID
	LEFT JOIN film_keywords fk ON f.FilmID = fk.FilmId
	LEFT JOIN keywords k ON k.KeywordID = fk.KeywordId
	WHERE (g.Genre IN (SELECT value FROM string_split(@genres, ',')) OR g.Genre IS NULL)
	AND (k.Keyword IN (SELECT value FROM string_split(@keywords, ',')) OR k.Keyword IS NULL)
	GROUP BY Title, Release_date, Overview, Vote_average, Popularity
	ORDER BY Vote_average DESC, Popularity DESC

END
GO
EXEC spFilmRec @keywords = 'murder,detective,case', @genres = 'thriller,drama,horror'
GO


-- The idea of the trigger is that if a genre exists, a genre with similar names cannot be inserted. Repeat for other dim tables

CREATE OR ALTER TRIGGER trgDupGenre
ON genres
AFTER INSERT
AS 
BEGIN
	DECLARE @count INT

	SET @count = (SELECT COUNT(g.genre) 
	FROM genres g INNER JOIN inserted i
	ON g.Genre = i.Genre)

	IF @count > 1
	BEGIN
		RAISERROR('Value already exists in the table.',16,1)
		ROLLBACK TRANSACTION
	END
END
GO

INSERT INTO genres(genre)
VALUES ('arthouse')

DELETE FROM genres WHERE genre = 'arthouse'

INSERT INTO genres(genre)
VALUES ('comedy')
SELECT * from genres

-- The idea of this is to find the top 5 films with the highest rating/popularity in each production country
CREATE OR ALTER PROC spRankingCriteria(@ColName VARCHAR(50), @top INT)
AS
BEGIN
	DECLARE @sql NVARCHAR(MAX)

	SET @sql = N'SELECT Title, ' + Quotename(@ColName) + ' , Production_country
	FROM 
	(SELECT Title, ' + Quotename(@ColName) + ' , Production_country,
		DENSE_RANK() OVER(PARTITION BY Production_country ORDER BY ' + Quotename(@ColName) + ' DESC) AS Ranking
	FROM film f 
	LEFT JOIN film_production_countries fpc ON f.FilmID = fpc.FilmId
	LEFT JOIN production_countries pc ON fpc.Production_countryId = pc.Production_countryID
	WHERE Production_country IS NOT NULL) AS t
	WHERE t.Ranking <= @top'

	IF @ColName in ('Release_date', 'Runtime', 'Revenue', 'Budget', 'Vote_average', 'Popularity')
		EXEC sp_executesql @sql, N'@ColName VARCHAR(50), @top INT', @ColName = @ColName, @top = @top
	ELSE PRINT 'Please choose a valid column'
END

GO

EXEC spRankingCriteria @ColName = 'Overview', @top = 10


-- Find the top 5 rated films in a year for all categories

SELECT * FROM
	(SELECT *, DENSE_RANK() OVER(PARTITION BY Genre ORDER BY Vote_average DESC) as Rank FROM film f
	LEFT JOIN film_genres fg
	ON f.FilmID = fg.FilmId) as t
WHERE t.Rank <= 5
AND YEAR(Release_date) = '1980'

