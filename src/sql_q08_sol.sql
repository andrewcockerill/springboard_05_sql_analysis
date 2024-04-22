-- 8. Write a SQL query to find the match number for the game with the highest number of penalty shots, and which countries played that match.
WITH match_greatest AS
(SELECT 
	match_no
    , COUNT(*) as ps_total
FROM 
	euro_cup_2016.penalty_shootout
GROUP BY 
	match_no
ORDER BY
	ps_total DESC
LIMIT 1)

SELECT
	a.match_no
    , b.team_id
    , c.country_name
FROM
	match_greatest a 
INNER JOIN 
	euro_cup_2016.match_details b 
    ON a.match_no = b.match_no
INNER JOIN 
	euro_cup_2016.soccer_country c
    ON b.team_id = c.country_id;
    
