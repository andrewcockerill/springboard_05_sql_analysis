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
    
-- 10. Write a SQL query to find all available information about the players under contract to Liverpool F.C. playing for England in EURO Cup 2016.
SELECT
	a.*
FROM 
	euro_cup_2016.player_mast a 
INNER JOIN
	euro_cup_2016.soccer_country b
    ON a.team_id = b.country_id
    AND b.country_name = 'England'
WHERE 
	a.playing_club = 'Liverpool';
    
-- 11. Write a SQL query to find the players, their jersey number, and playing club who were the goalkeepers for England in EURO Cup 2016.
SELECT 
	a.player_id
    , a.player_name
    , a.jersey_no
    , a.playing_club
FROM
	euro_cup_2016.player_mast a 
INNER JOIN 
	euro_cup_2016.soccer_country b
    ON a.team_id = b.country_id
    AND b.country_name = 'England'
WHERE
	a.posi_to_play = 'GK';

-- 12. Write a SQL query that returns the total number of goals scored by each position on each country’s team. Do not include positions which scored no goals.
SELECT
    c.country_name
    , b.posi_to_play
    , COUNT(*) AS goals_scored
FROM
	euro_cup_2016.goal_details a
INNER JOIN 
	euro_cup_2016.player_mast b
    ON a.player_id = b.player_id
    AND a.team_id = b.team_id
INNER JOIN 
	euro_cup_2016.soccer_country c
    ON a.team_id = c.country_id
GROUP BY
    c.country_name
    , b.posi_to_play
ORDER BY
    c.country_name
    , b.posi_to_play;
    
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
    
-- 17. Write a SQL query to find the country where the most assistant referees come from, and the count of the assistant referees.
WITH country_counts AS
(SELECT
	a.country_id
    , a.country_name
    , COUNT(*) AS num_asst_refs
FROM
	euro_cup_2016.soccer_country a
INNER JOIN 
	euro_cup_2016.asst_referee_mast b
    ON a.country_id = b.country_id
GROUP BY 
	a.country_id
    , a.country_name),

country_counts_ranked AS
(SELECT 
	*
    , RANK() OVER (ORDER BY num_asst_refs DESC) as rn
FROM
	country_counts)
    
SELECT country_name, num_asst_refs FROM country_counts_ranked WHERE rn = 1;

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
    
-- 19. Write a SQL query to find the number of captains who were also goalkeepers.
SELECT
	COUNT(DISTINCT a.player_captain) as num_captain_gk
FROM
	euro_cup_2016.match_captain a
INNER JOIN 
	euro_cup_2016.player_mast b
    ON a.player_captain = b.player_id
    AND b.posi_to_play = 'GK';
    
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