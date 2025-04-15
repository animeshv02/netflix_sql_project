-- Netflix Project

DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix
(
	show_id   	    VARCHAR(6),
	type 		    VARCHAR(10),
	title 		    VARCHAR(150),
	director        VARCHAR(300),
	casts           VARCHAR(1000),
	country         VARCHAR(150),
	date_added      VARCHAR(50),
	release_year    INT,
	rating  	    VARCHAR(10),
	duration        VARCHAR(15),
	listed_in       VARCHAR(100),
	description     VARCHAR(250)
);

SELECT * FROM netflix;



-- 15 Business Problems

-- 1. Count the number of Movies vs TV Shows

SELECT
	COUNT(*) as total_content,
	type
FROM netflix
GROUP BY type;



-- 2. Find the most common rating for movies and TV shows

WITH CTE AS 
(
	SELECT
		type,
		rating,
		COUNT(*),
		RANK() OVER(PARTITION BY type ORDER BY COUNT(*) DESC) as rn
	FROM netflix
	GROUP BY type, rating
)
SELECT 
	type, 
	rating
	FROM CTE 
WHERE rn = 1



-- 3. List all movies released in a specific year (eg 2020)

SELECT 
*
FROM netflix
WHERE type = 'Movie' AND release_year = 2020



-- 4. Find the top 5 countries with the most content on Netflix

SELECT 
	UNNEST(STRING_TO_ARRAY(country, ',')) as new_country,
	count(show_id) as total_content
FROM netflix
GROUP BY new_country
ORDER BY total_content DESC
LIMIT 5



-- 5. Find content added in the last 5 years

select * from netflix

SELECT 
	*
FROM netflix
WHERE 
	TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years'


 
-- 6. Find all the movies/TV shows by director 'Rajiv Chilaka'

SELECT 
*
FROM netflix
	WHERE director ILIKE '%Rajiv Chilaka%'



-- 7. List all TV shows with more htan 5 seasons

SELECT 
*
FROM netflix
	WHERE type = 'TV Show' 
	AND 
	SPLIT_PART(duration, ' ', 1)::NUMERIC > 5



-- 8. Count the number of content items in each genre

SELECT
UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS genre_list,
COUNT(*)
FROM netflix 
GROUP BY UNNEST(STRING_TO_ARRAY(listed_in, ','))



-- 9. Find each year and the average numbers of content release by India on Netflix.
--    return top 5 year with highest avg content release


SELECT
	EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) AS date,
	COUNT(*),
	ROUND(
	COUNT(*)::numeric / (SELECT COUNT(*) FROM netflix WHERE country = 'India') * 100
	,2) AS avg_content_per_year
FROM netflix
WHERE country = 'India'
	GROUP BY 1



-- 10. List all movies that are documentaries

SELECT 
*
FROM netflix
WHERE type = 'Movie' AND listed_in ILIKE '%Documentaries%'



-- 11. Find all content without a director

SELECT 
*
FROM netflix
WHERE director IS NULL



-- 12. Find how many movies actor 'Salman Khan' appreared in last 10 years

SELECT 
*
FROM netflix
WHERE 
	casts ILIKE '%Salman Khan%'
	AND 
	release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10



-- 13. Find the top 10 actors who have appeared in the highest number of movies produced in India

SELECT
UNNEST(STRING_TO_ARRAY(casts, ',')) AS actors,
COUNT(*) AS total_content
FROM netflix
WHERE country ILIKE '%India%'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10



-- 14. Categorize the content based on the presence of the keywords 'kill' and 'violence' in
--     the description field. Label content containing these keywords as 'Bad' and all other
--     content as 'Good'. Count how many items fall into each category.

WITH new_table AS
(
SELECT 
*,
	CASE 
	WHEN description ILIKE '%kill%' OR
	     description ILIKE '%violence%' THEN 'Bad_Content'
		 ELSE 'Good Content'	
	END Category
FROM netflix
) 
SELECT 
	category,
	COUNT(*) AS total_content 
FROM new_table
GROUP BY 1















	












