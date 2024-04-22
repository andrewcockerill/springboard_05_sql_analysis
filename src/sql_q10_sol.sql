-- 10. Write a SQL query to find all available information about the players under contract to Liverpool F.C. playing for England in EURO Cup 2016.
SELECT
	a.*
FROM 
	euro_cup_2016.player_mast a 
INNER JOIN
	euro_cup_2016.soccer_country b
    ON a.team_id = b.country_id
    AND b.country_name = 'England'
WHERE 
	a.playing_club = 'Liverpool';
    
