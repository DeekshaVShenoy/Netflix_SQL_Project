-- 15 Business Problems & Solutions

--1. Count the number of Movies vs TV Shows
	select * from movies
	select type[Type],count(*)[Total] from movies
	group by type

--2. Find the most common rating for movies and TV shows
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

--3. List all movies released in a specific year (e.g., 2020)
	select * from movies
	where release_year=2020 and type='Movie'

--4. Find the top 5 countries with the most content on Netflix
	select TOP 5 LTRIM(RTRIM(NEWCOUNTRY.VALUE))[Country],Count(*)[Total] from movies m
	cross apply string_split(m.country,',')[newcountry]
	group by LTRIM(RTRIM(newcountry.value))
	order by Total desc;

--5. Identify the longest movie
	select top 1 m.* from Movies m
	cross apply string_split(m.duration,' ',1)[newduration]
	where m.type='Movie' and newduration.ordinal=1
	order by cast(ltrim(rtrim(newduration.value))as int) desc

--6. Find content added in the last 5 years
	select * from Movies 
	where date_added>=DATEADD(Year,-5,getdate())

--7. Find all the movies/TV shows by director 'Rajiv Chilaka'!
	select * from movies m
	cross apply string_split(m.director,',')[d]
	where ltrim(rtrim(d.value))='Rajiv Chilaka'
	--or 
	select * from movies
	where director like '%Rajiv Chilaka%'

--8. List all TV shows with more than 5 seasons
	select * from movies m
	cross apply string_split(m.duration, ' ',1) [d]
	where m.type='TV Show' and d.ordinal=1 and try_cast(d.value as int)> 5 

--9. Count the number of content items in each genre
	select ltrim(rtrim(g.value))[Genre],count(show_id)[Total]  from movies m
	cross apply string_split(m.listed_in,',')[g]
	group by ltrim(rtrim(g.value))

--10. Find all content without a director
	select * from movies
	where director is null

--11. List all movies that are documentaries
	select * from movies
	where listed_in like '%documentaries%' and type='Movie'

--12.Find each year and the average numbers of content release in India on netflix. 
--return top 5 year with highest avg content release!
	select TOP 5 release_year[Year],
	count(*)[Total] from movies 
	cross apply string_split(country,',')[nc]
	where ltrim(rtrim(nc.value))='India'
	group by release_year
	order by Total desc

--13.Categorize the content based on the presence of the keywords 'kill' and 'violence' in the description field. Label content containing these keywords as 'Bad' and all other content as 'Good'. Count how many items fall into each category.

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