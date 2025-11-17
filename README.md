# Netflix Movies and TV Shows Data Analysis using SQL
![](https://github.com/DeekshaVShenoy/Netflix_SQL_Project/blob/main/logo.png)
## Overview
This project involves a comprehensive analysis of Netflix's movies and TV shows data using SQL. 
The goal is to extract valuable insights and answer various business questions based on the dataset.
The following README provides a detailed account of the project's objectives, business problems, solutions, findings, and conclusions.

## Objectives

- Analyze the distribution of content types (movies vs TV shows).
- Identify the most common ratings for movies and TV shows.
- List and analyze content based on release years, countries, and durations.
- Explore and categorize content based on specific criteria and keywords.

## Dataset

The data for this project is sourced from the Kaggle dataset:

- **Dataset Link:** [Movies Dataset](https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download)

## Schema
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


## Business Problems and Solutions

### 1. Count the Number of Movies vs TV Shows

      select * from movies
      select type[Type],count(*)[Total] from movies
      group by type

**Objective:** Determine the distribution of content types on Netflix.

### 2. Find the Most Common Rating for Movies and TV Shows
      select
      type,
      rating,
      Counts
      from
      (
      	select 
      	type,
      	rating,
      	count(rating)[Counts],
      	rank()over(partition by type order by count(rating) desc)as ranking
      from movies
      group by type,rating
      )as ranked
      where ranking=1

**Objective:** Identify the most frequently occurring rating for each type of content.

### 3. List All Movies Released in a Specific Year (e.g., 2020)

    select * from movies
    where release_year=2020 and type='Movie'

**Objective:** Retrieve all movies released in a specific year.

### 4. Find the Top 5 Countries with the Most Content on Netflix

      select TOP 5 LTRIM(RTRIM(NEWCOUNTRY.VALUE))[Country],Count(*)[Total] from movies m
      cross apply string_split(m.country,',')[newcountry]
      group by LTRIM(RTRIM(newcountry.value))
      order by Total desc;

**Objective:** Identify the top 5 countries with the highest number of content items.

### 5. Identify the Longest Movie

      select top 1 m.* from Movies m
      cross apply string_split(m.duration,' ',1)[newduration]
      where m.type='Movie' and newduration.ordinal=1
      order by cast(ltrim(rtrim(newduration.value))as int) desc

**Objective:** Find the movie with the longest duration.

### 6. Find Content Added in the Last 5 Years
  	select * from Movies 
  	where date_added>=DATEADD(Year,-5,getdate())

**Objective:** Retrieve content added to Netflix in the last 5 years.

### 7. Find All Movies/TV Shows by Director 'Rajiv Chilaka'
    select * from movies m
    cross apply string_split(m.director,',')[d]
    where ltrim(rtrim(d.value))='Rajiv Chilaka'
    --or 
    select * from movies
    where director like '%Rajiv Chilaka%'


**Objective:** List all content directed by 'Rajiv Chilaka'.

### 8. List All TV Shows with More Than 5 Seasons
  	select * from movies m
  	cross apply string_split(m.duration, ' ',1) [d]
  	where m.type='TV Show' and d.ordinal=1 and try_cast(d.value as int)> 5 
  
**Objective:** Identify TV shows with more than 5 seasons.

### 9. Count the Number of Content Items in Each Genre

    select ltrim(rtrim(g.value))[Genre],count(show_id)[Total]  from movies m
    cross apply string_split(m.listed_in,',')[g]
    group by ltrim(rtrim(g.value))

**Objective:** Count the number of content items in each genre.

### 10.Find each year and the average numbers of content release in India on netflix. 
return top 5 year with highest avg content release!
  select TOP 5 release_year[Year],
  count(*)[Total] from movies 
  cross apply string_split(country,',')[nc]
  where ltrim(rtrim(nc.value))='India'
  group by release_year
  order by Total desc

**Objective:** Calculate and rank years by the average number of content releases by India.

### 11. List All Movies that are Documentaries
	select * from movies
	where listed_in like '%documentaries%' and type='Movie'
  
**Objective:** Retrieve all movies classified as documentaries.

### 12. Find All Content Without a Director
	select * from movies
	where director is null

**Objective:** List content that does not have a director.

### 15. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords
 select category,count(*)[Total]
  from 
  	(
  		select *,
  		case 
  			when description like '%kill%' or description like '%violence%' then 'bad'
  			else 'good'
  		end as category 
  		from movies
  	) as c
  group by category
  order by Total desc
  
**Objective:** Categorize content as 'Bad' if it contains 'kill' or 'violence' and 'Good' otherwise. Count the number of items in each category.

## Findings and Conclusion

- **Content Distribution:** The dataset contains a diverse range of movies and TV shows with varying ratings and genres.
- **Common Ratings:** Insights into the most common ratings provide an understanding of the content's target audience.
- **Geographical Insights:** The top countries and the average content releases by India highlight regional content distribution.
- **Content Categorization:** Categorizing content based on specific keywords helps in understanding the nature of content available on Netflix.

This analysis provides a comprehensive view of Netflix's content and can help inform content strategy and decision-making.



## Author - Deeksha Shenoy

This project is part of my portfolio, showcasing the SQL skills essential for data analyst roles. If you have any questions, feedback, or would like to collaborate, feel free to get in touch!
