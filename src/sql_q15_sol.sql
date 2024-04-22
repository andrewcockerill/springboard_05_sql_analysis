-- 15. Write a SQL query to find the referees who booked the most number of players.
WITH booking_counts AS
(SELECT
	a.referee_id
    , b.referee_name
    , COUNT(DISTINCT c.player_id) as num_bookings
FROM
	euro_cup_2016.match_mast a
INNER JOIN 
	euro_cup_2016.referee_mast b
    ON a.referee_id = b.referee_id
INNER JOIN 
	euro_cup_2016.player_booked c
    ON a.match_no = c.match_no
GROUP BY 
	a.referee_id
    , b.referee_name),
    
refs_ranked AS
(SELECT
	referee_id
    , referee_name
    , RANK() OVER (ORDER BY num_bookings DESC) AS rn
FROM
	booking_counts)

SELECT referee_id, referee_name FROM refs_ranked WHERE rn = 1;

