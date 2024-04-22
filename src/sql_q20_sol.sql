-- 20. Write a SQL query to find the substitute players who came into the field in the first half of play, within a normal play schedule.
SELECT DISTINCT 
	a.player_id
    , b.player_name
FROM
	euro_cup_2016.player_in_out a
INNER JOIN 
	euro_cup_2016.player_mast b
    ON a.player_id = b.player_id
WHERE
	a.in_out = 'I'
    AND a.play_schedule = 'NT'
    and a.play_half = 1;