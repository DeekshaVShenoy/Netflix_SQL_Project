-----Create a database
create database Netflix
use Netflix

-----Create a table
CREATE TABLE dbo.Movies (
    show_id NVARCHAR(50),
    type NVARCHAR(50),
    title NVARCHAR(255),
    director NVARCHAR(255),
    country NVARCHAR(255),
    date_added DATE NULL,
    release_year INT NULL,
    rating NVARCHAR(50),
    duration NVARCHAR(50),
    listed_in NVARCHAR(255),
    description NVARCHAR(MAX)
);

--Bulk Upload into table 
BULK INSERT dbo.Movies
FROM 'C:\movies.csv'
WITH (
    FORMAT = 'CSV',
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIELDQUOTE = '"',
    FIRSTROW = 2
);