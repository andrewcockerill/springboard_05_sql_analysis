-- 19. Write a SQL query to find the number of captains who were also goalkeepers.
SELECT
	COUNT(DISTINCT a.player_captain) as num_captain_gk
FROM
	euro_cup_2016.match_captain a
INNER JOIN 
	euro_cup_2016.player_mast b
    ON a.player_captain = b.player_id
    AND b.posi_to_play = 'GK';
    
