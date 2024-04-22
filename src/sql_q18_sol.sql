-- 18. Write a SQL query to find the highest number of foul cards given in one match.
WITH booking_counts AS
(SELECT
	match_no
    , COUNT(*) as bookings
FROM
	euro_cup_2016.player_booked
GROUP BY
	match_no)
    
SELECT
	MAX(bookings) AS highest_foul_count
FROM
	booking_counts;
    
