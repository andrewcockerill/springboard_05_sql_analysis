-- 7. Write a SQL query to find all the venues where matches with penalty shootouts were played.
SELECT DISTINCT
	a.venue_id
    , a.venue_name
FROM
	euro_cup_2016.soccer_venue a
INNER JOIN 
	euro_cup_2016.match_mast b
    ON a.venue_id = b.venue_id
    AND b.decided_by = 'P';
    
