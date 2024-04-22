-- 6. Write a SQL query to find the number of matches that were won by a single point, but do not include matches decided by penalty shootout.
SELECT
	COUNT(*) AS matches_won_by_one
FROM 
	euro_cup_2016.match_mast
WHERE 
	decided_by = 'N'
    AND ABS(
		CAST(REGEXP_REPLACE(goal_score, '-.*', '') AS SIGNED INTEGER) -
		CAST(REGEXP_REPLACE(goal_score, '^\\d+-', '') AS SIGNED INTEGER)
        ) = 1;
        
