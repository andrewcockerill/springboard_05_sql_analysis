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

