-- 12. Write a SQL query that returns the total number of goals scored by each position on each country’s team. Do not include positions which scored no goals.
SELECT
    c.country_name
    , b.posi_to_play
    , COUNT(*) AS goals_scored
FROM
	euro_cup_2016.goal_details a
INNER JOIN 
	euro_cup_2016.player_mast b
    ON a.player_id = b.player_id
    AND a.team_id = b.team_id
INNER JOIN 
	euro_cup_2016.soccer_country c
    ON a.team_id = c.country_id
GROUP BY
    c.country_name
    , b.posi_to_play
ORDER BY
    c.country_name
    , b.posi_to_play;
    
