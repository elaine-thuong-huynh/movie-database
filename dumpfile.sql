-- Create database and tables
CREATE DATABASE tmdbMovies;

USE tmdbMovies
GO

CREATE TABLE film (
Title NVARCHAR(200),
Original_language VARCHAR(5),
Release_date DATE,
Runtime INT,
Revenue BIGINT,
Budget BIGINT,
Vote_average DECIMAL (4,2),
Popularity DECIMAL(6,2),
Overview NVARCHAR(MAX)
);

CREATE TABLE film_genres (
 FilmId INT,
 Genre VARCHAR(50),
 GenreId INT);

CREATE TABLE genres (
 Genre VARCHAR(50));

CREATE TABLE film_keywords (
 FilmId INT,
 Keyword VARCHAR(100),
 KeywordId INT);

 CREATE TABLE keywords (
 Keyword VARCHAR(50));

 CREATE TABLE film_production_companies (
 FilmId INT,
 Production_company VARCHAR(100),
 Production_companyId INT);

 CREATE TABLE production_companies (
 Production_company VARCHAR(100));

 CREATE TABLE production_countries (
 Production_country VARCHAR(100));

 CREATE TABLE film_production_countries (
 FilmId INT,
 Production_country VARCHAR(100),
 Production_countryId INT);

 CREATE TABLE spoken_languages(
 Spoken_language VARCHAR(100));

 CREATE TABLE film_spoken_languages (
 FilmId INT,
 Spoken_language VARCHAR(100),
 Spoken_languageId INT)



 -- Create primary keys
ALTER TABLE film ADD FilmID INT IDENTITY(1,1);
ALTER TABLE genres ADD GenreID INT IDENTITY(1,1);
ALTER TABLE keywords ADD KeywordID INT IDENTITY(1,1);
ALTER TABLE production_companies ADD Production_companyID INT IDENTITY(1,1);
ALTER TABLE production_countries ADD Production_countryID INT IDENTITY(1,1);
ALTER TABLE spoken_languages ADD Spoken_languageID INT IDENTITY(1,1);

ALTER TABLE film ADD PRIMARY KEY (FilmID);
ALTER TABLE genres ADD PRIMARY KEY (GenreID);
ALTER TABLE keywords ADD PRIMARY KEY (KeywordID);
ALTER TABLE production_companies ADD PRIMARY KEY (Production_companyID);
ALTER TABLE production_countries ADD PRIMARY KEY (Production_countryID);
ALTER TABLE spoken_languages ADD PRIMARY KEY (Spoken_languageID);

-- Create FK constraints
ALTER TABLE film_genres
ADD FOREIGN KEY (FilmID) REFERENCES film(FilmID)
ON UPDATE CASCADE
ON DELETE CASCADE;

ALTER TABLE film_keywords
ADD FOREIGN KEY (FilmID) REFERENCES film(FilmID)
ON UPDATE CASCADE
ON DELETE CASCADE;

ALTER TABLE film_production_companies
ADD FOREIGN KEY (FilmID) REFERENCES film(FilmID)
ON UPDATE CASCADE
ON DELETE CASCADE;

ALTER TABLE film_production_countries
ADD FOREIGN KEY (FilmID) REFERENCES film(FilmID)
ON UPDATE CASCADE
ON DELETE CASCADE;

ALTER TABLE film_spoken_languages
ADD FOREIGN KEY (FilmID) REFERENCES film(FilmID)
ON UPDATE CASCADE
ON DELETE CASCADE;

ALTER TABLE film_genres
ADD FOREIGN KEY (GenreID) REFERENCES genres(GenreID)
ON UPDATE CASCADE
ON DELETE CASCADE;

ALTER TABLE film_keywords
ADD FOREIGN KEY (KeywordID) REFERENCES keywords(KeywordId)
ON UPDATE CASCADE
ON DELETE CASCADE;

ALTER TABLE film_production_companies
ADD FOREIGN KEY (Production_companyID) REFERENCES production_companies(Production_companyId)
ON UPDATE CASCADE
ON DELETE CASCADE;

ALTER TABLE film_production_countries
ADD FOREIGN KEY (Production_countryID) REFERENCES production_countries(Production_countryId)
ON UPDATE CASCADE
ON DELETE CASCADE;

ALTER TABLE film_spoken_languages
ADD FOREIGN KEY (Spoken_languageID) REFERENCES spoken_languages(Spoken_languageID)
ON UPDATE CASCADE
ON DELETE CASCADE;



