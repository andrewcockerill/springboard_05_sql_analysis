-- 1. Write a SQL query to find the date EURO Cup 2016 started on.
SELECT 
	MIN(play_date) AS start_date
FROM
	euro_cup_2016.match_mast;
    
-- 2. Write a SQL query to find the number of matches that were won by penalty shootout.
SELECT
	COUNT(match_no) AS win_count
FROM
	euro_cup_2016.match_mast
WHERE
	decided_by = 'P';
    
-- 3. Write a SQL query to find the match number, date, and score for matches in which no stoppage time was added in the 1st half.
SELECT
	match_no
    , play_date
    , goal_score
FROM 
	euro_cup_2016.match_mast
WHERE
	stop1_sec = 0;
    
-- 4. Write a SQL query to compute a list showing the number of substitutions that happened in various stages of play for the entire tournament.
SELECT
	COUNT(*) as subs
FROM
	euro_cup_2016.player_in_out
WHERE
	in_out = 'I';
    
-- 5. Write a SQL query to find the number of bookings that happened in stoppage time.
SELECT
	COUNT(*) AS bookings
FROM 
	euro_cup_2016.player_booked
WHERE
	play_schedule = 'ST';
    
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
    
-- 8. Write a SQL query to find the match number for the game with the highest number of penalty shots, and which countries played that match.
WITH match_greatest AS
(SELECT 
	match_no
    , COUNT(*) as ps_total
FROM 
	euro_cup_2016.penalty_shootout
GROUP BY 
	match_no
ORDER BY
	ps_total DESC
LIMIT 1)

SELECT
	a.match_no
    , b.team_id
    , c.country_name
FROM
	match_greatest a 
INNER JOIN 
	euro_cup_2016.match_details b 
    ON a.match_no = b.match_no
INNER JOIN 
	euro_cup_2016.soccer_country c
    ON b.team_id = c.country_id;
    
-- 9. Write a SQL query to find the goalkeeper’s name and jersey number, playing for Germany, who played in Germany’s group stage matches.
SELECT DISTINCT
	a.player_gk
    , b.player_name
    , b.jersey_no
    , c.country_name
    , a.play_stage
FROM
	euro_cup_2016.match_details a
INNER JOIN 
	euro_cup_2016.player_mast b
    ON a.team_id = b.team_id
    AND a.player_gk = b.player_id
INNER JOIN 
	euro_cup_2016.soccer_country c
    ON a.team_id = c.country_id
    AND c.country_name = 'Germany'
WHERE 
	a.play_stage = 'G';