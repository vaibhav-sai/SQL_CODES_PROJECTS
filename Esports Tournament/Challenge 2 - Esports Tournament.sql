select * from Matches_EASPORTS;

select * from teams;

select * from players;

-- 1. What are the names of the players whose salary is greater than 100,000?

select * from players
where salary > 100000;

-- 2. What is the team name of the player with player_id = 3?
select t.team_name , p.player_id from 
teams as t
join players as p 
on t.team_id = p.team_id
where p.player_id = 3;

-- 3. What is the total number of players in each team?

select t.team_name , count(p.player_id) as player_count from 
teams as t
join players as p 
on t.team_id = p.team_id
group by t.team_name;

-- 4. What is the team name and captain name of the team with team_id = 2?

select t.team_name , p.player_name as captian_name
from teams as t
join players as p
on t.team_id = p.team_id and t.captain_id = p.player_Id
where t.team_id = 2;


-- 5. What are the player names and their roles in the team with team_id = 1?

select p.player_name,p.role,t.team_name from players as p
join teams as t 
on p.team_id = t.team_id
where t.team_id = 1;

-- 6. What are the team names and the number of matches they have won?
select t.team_name , count(*) as wins from teams as t 
join Matches_EASPORTS as m
on t.team_id = m.winner_id
group by t.team_name

-- 7. What is the average salary of players in the teams with country 'USA'?
select t.country , round(avg(p.salary),2) as avg_salary from teams as t
join players as p
on t.team_id = p.team_id
where t.country = 'USA'
group by t.country 

-- 8. Which team won the most matches?
select top 1 t.team_name , count(*) as wins from teams as t 
join Matches_EASPORTS as m
on t.team_id = m.winner_id
group by t.team_name
order by wins desc

-- 9. What are the team names and the number of players in each team whose salary is greater than 100,000?
select t.team_name , count(*) as player_count
from teams as t
join players as p 
on t.team_id = p.team_id 
where p.salary > 100000
group by  t.team_name;

-- 10. What is the date and the score of the match with match_id = 3?

select match_id,match_date , score_team1 , score_team2 , (score_team1 + score_team2) as total_score from Matches_EASPORTS
where match_id = 3