-- 4. Write a SQL query to compute a list showing the number of substitutions that happened in various stages of play for the entire tournament.
SELECT
	COUNT(*) as subs
FROM
	euro_cup_2016.player_in_out
WHERE
	in_out = 'I';
    
