-- 9. Write a SQL query to find the goalkeeper’s name and jersey number, playing for Germany, who played in Germany’s group stage matches.
SELECT DISTINCT
	a.player_gk
    , b.player_name
    , b.jersey_no
    , c.country_name
    , a.play_stage
FROM
	euro_cup_2016.match_details a
INNER JOIN 
	euro_cup_2016.player_mast b
    ON a.team_id = b.team_id
    AND a.player_gk = b.player_id
INNER JOIN 
	euro_cup_2016.soccer_country c
    ON a.team_id = c.country_id
    AND c.country_name = 'Germany'
WHERE 
	a.play_stage = 'G';
    
