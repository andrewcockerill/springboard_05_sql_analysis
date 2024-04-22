-- 17. Write a SQL query to find the country where the most assistant referees come from, and the count of the assistant referees.
WITH country_counts AS
(SELECT
	a.country_id
    , a.country_name
    , COUNT(*) AS num_asst_refs
FROM
	euro_cup_2016.soccer_country a
INNER JOIN 
	euro_cup_2016.asst_referee_mast b
    ON a.country_id = b.country_id
GROUP BY 
	a.country_id
    , a.country_name),

country_counts_ranked AS
(SELECT 
	*
    , RANK() OVER (ORDER BY num_asst_refs DESC) as rn
FROM
	country_counts)
    
SELECT country_name, num_asst_refs FROM country_counts_ranked WHERE rn = 1;

