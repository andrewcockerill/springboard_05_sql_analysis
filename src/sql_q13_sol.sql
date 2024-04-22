-- 13. Write a SQL query to find all the defenders who scored a goal for their teams.
SELECT DISTINCT
    b.player_id
    , b.player_name
FROM
	euro_cup_2016.goal_details a
INNER JOIN 
	euro_cup_2016.player_mast b
    ON a.player_id = b.player_id
    AND a.team_id = b.team_id
    AND b.posi_to_play = 'DF';
    
