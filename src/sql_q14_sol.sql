-- 14. Write a SQL query to find referees and the number of bookings they made for the entire tournament. Sort your answer by the number of bookings in descending order.
SELECT
	a.referee_id
    , b.referee_name
    , COUNT(*) as num_bookings
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
    , b.referee_name
ORDER BY
	num_bookings DESC;
    
