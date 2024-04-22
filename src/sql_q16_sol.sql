-- 16. Write a SQL query to find referees and the number of matches they worked in each venue.
SELECT
	a.referee_name
    , b.venue_name
    , SUM(CASE when c.match_no IS NOT NULL THEN 1 ELSE 0 END) AS match_count
FROM
	euro_cup_2016.referee_mast a
INNER JOIN
	euro_cup_2016.soccer_venue b
    ON 1=1
LEFT JOIN
	euro_cup_2016.match_mast c
    ON a.referee_id = c.referee_id
    AND b.venue_id = c.venue_id
GROUP BY
	a.referee_name
    , b.venue_name;
    
