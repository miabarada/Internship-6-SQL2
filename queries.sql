SELECT Tournament.Name AS Name
     , Year
	 , Place
	 , Team.Name AS Winner
  FROM Tournament
  LEFT JOIN TeamAtTournament USING (TournamentId)
  JOIN Team USING (TeamId)
 WHERE FinalPosition = 1;

SELECT Team.Name AS TeamName
     , Representative.Name || ' ' || Representative.Surname AS Representative
  FROM Team
  JOIN Representative USING (RepresentativeId)
  JOIN TeamAtTournament USING (TeamId)
  JOIN Tournament USING (TournamentId)
 WHERE Tournament.Name = 'Super Bowl'
   AND Tournament.Year = 2009;

SELECT Name
     , Surname
	 , DateOfBirth
	 , PlayerPosition
  FROM Player
 WHERE TeamId = 8;

SELECT DateAndStartTime
	 , Team1.Name || ' : ' || Team2.Name AS Opponents
	 , GameType.Name AS GameType
	 , Team1Score || ' : ' || Team2Score AS Score
  FROM Game
  JOIN Team Team1 ON Game.Team1Id = Team1.TeamId
  JOIN Team Team2 ON Game.Team2Id = Team2.TeamId
  JOIN GameType USING (GameTypeId)
  JOIN Tournament USING (TournamentId)
 WHERE Tournament.Name = 'Super Bowl'
   AND Tournament.Year = 2009;

SELECT Tournament.Name
     , DateAndStartTime
	 , Team1.Name || ' : ' || Team2.Name AS Opponents
	 , GameType.Name AS GameType
	 , Team1Score || ' : ' || Team2Score AS Score
  FROM Game
  JOIN Team Team1 ON Game.Team1Id = Team1.TeamId
  JOIN Team Team2 ON Game.Team2Id = Team2.TeamId
  JOIN GameType USING (GameTypeId)
  JOIN Tournament USING (TournamentId)
 WHERE Team1Id = 8
    OR Team2Id = 8;

Select GameEventType.Name AS Name
	 , Player.Name AS PlayerName
  FROM GameEvent
  JOIN GameEventType USING (GameEventTypeId)
  JOIN Player USING (PlayerId)
 WHERE GameId = 5;

SELECT Player.Name || ' ' || Player.Surname AS Player
	 , PTeam.Name AS Team
     , Team1.Name || ':' || Team2.Name AS Game
	 , MinuteOfGame
	 , GameEventType.Name AS Card
  FROM GameEvent
  JOIN GameEventType USING (GameEventTypeid)
  JOIN Game USING (GameId)
  JOIN Team Team1 ON Game.Team1Id = Team1.TeamId
  JOIN Team Team2 ON Game.Team2Id = Team2.TeamId
  JOIN Player USING (PlayerId)
  JOIN Team PTeam ON Player.TeamId = PTeam.TeamId
 WHERE GameEventTypeId = 2
	OR GameEventTypeId = 4
	OR GameEventTypeId = 5;

SELECT Player.Name || ' ' || Player.Surname AS Player
     , COUNT(GameEventId) AS NumberOfGoals
	 , Team.Name AS Team
  FROM GameEvent
  JOIN GameEventType USING (GameEventTypeId)
  JOIN Player USING (PlayerId)
  JOIN Team USING (TeamId)
  JOIN Game USING (GameId)
  JOIN GameType USING (GameTypeId)
  JOIN Tournament USING (TournamentId)
 WHERE GameEventTypeId = 1
 GROUP BY PlayerId, Player.Name, Player.Surname, Team.Name;

SELECT Team.Name AS Team
	 , SUM(CASE 
	 		WHEN Team1Id = TeamId THEN Team1Score - Team2Score
            WHEN Team2Id = TeamId THEN Team2Score - Team1Score
           END) AS GoalDifference
	 , NumberOfPoints
	 , FinalPosition
  FROM Team
  JOIN TeamAtTournament USING (TeamId)
  JOIN Tournament USING (TournamentId)
  LEFT JOIN GAME ON (Game.Team1Id = Team.TeamId OR Game.Team2Id = Team.teamId)
  WHERE Tournament.Name = 'Super Bowl'
   AND Tournament.Year = 2009
  GROUP BY Team.TeamId, Team.Name, TeamAtTournament.NumberOfPoints, TeamAtTournament.FinalPosition
  ORDER BY TeamAtTournament.NumberOfPoints DESC, GoalDifference DESC;

SELECT Team1.Name || ':' || Team2.Name AS Game
     , CASE 
	 	  WHEN Team1Score > Team2Score THEN Team1.Name
          WHEN Team1Score < Team2Score THEN Team2.Name
		  WHEN Team1Score = Team2Score THEN 'Tie'
	   END AS Winner
  FROM Game
  JOIN Team Team1 ON Game.Team1Id = Team1.TeamId
  JOIN Team Team2 ON Game.Team2Id = Team2.TeamId
  JOIN GameType USING (GameTypeId)
 WHERE GameType.Name = 'Final';

SELECT GameType.Name AS Type
     , COUNT(GameId) AS NumberOfGames
  FROM GameType
  LEFT JOIN Game USING (GameTypeId)
 GROUP BY Name;

SELECT Team1.Name || ':' || Team2.Name AS Game
     , GameType.Name
	 , Team1Score || ' : ' || Team2Score AS Score
  FROM Game
  JOIN Team Team1 ON Game.Team1Id = Team1.TeamId
  JOIN Team Team2 ON Game.Team2Id = Team2.TeamId
  JOIN GameType USING (GameTypeId)
 WHERE DATE(DateAndStartTime) = '2005-01-15';

SELECT Player.Name || ' ' || Player.Surname AS Player
     , COUNT(GameEventId) AS NumberOfGoals
	 , Team.Name AS Team
  FROM GameEvent
  JOIN GameEventType USING (GameEventTypeId)
  JOIN Player USING (PlayerId)
  JOIN Team USING (TeamId)
  JOIN Game USING (GameId)
  JOIN GameType USING (GameTypeId)
  JOIN Tournament USING (TournamentId)
 WHERE GameEventTypeId = 1
   AND Tournament.Name = 'Super Bowl'
 GROUP BY PlayerId, Player.Name, Player.Surname, Team.Name
 ORDER BY NumberOfGoals DESC;

SELECT Tournament.Name
     , Year
     , FinalPosition
  FROM TeamAtTournament
  JOIN Tournament USING (TournamentId)
 WHERE TeamAtTournament.TeamId = 420;

SELECT Team.Name AS Name
     , TeamAtTournament.NumberOfPoints
  FROM TeamAtTournament
  JOIN Team USING (TeamId)
  JOIN Tournament USING (TournamentId)
 WHERE TournamentId = 79
 ORDER BY NumberOfPoints DESC
 LIMIT 1;

SELECT Tournament.Name AS Name
     , COUNT (DISTINCT TeamAtTournament.TeamId) AS NumberOfTeams
	 , COUNT (DISTINCT PlayerId) AS NumberOfPlayers
  FROM Tournament
  JOIN TeamAtTournament USING (TournamentId)
  JOIN Team USING (TeamId)
  JOIN Player USING (TeamId)
 GROUP BY TournamentId, Tournament.Name;


SELECT Team.Name AS TeamName
     , Player.Name || ' ' || Player.Surname AS Player
	 , COUNT(GameEventId) AS Goals
  FROM Player
  JOIN Team USING (TeamId)
  JOIN GameEvent USING (PlayerId)
  JOIN GameEventType USING (GameEventTypeId)
 WHERE GameEventType.Name = 'Goal'
 GROUP BY TeamId, Team.Name, PlayerId, Player.Name, Player.Surname
HAVING COUNT(GameEventId) = (
	SELECT MAX(GoalCount)
	FROM (
		SELECT COUNT(GameEventId) AS GoalCount
		FROM Player
		JOIN GameEvent USING (PlayerId)
		JOIN GameEventType USING (GameEventTypeId)
		WHERE GameEventType.Name = 'Goal' AND Player.TeamId = TeamId
		GROUP BY PlayerId
	) AS TeamGoals
);

SELECT Team1.Name || ':' || Team2.Name AS Game
	 , Team1Score || ' : ' || Team2Score AS Score
  FROM Game
  JOIN Team Team1 ON Team1Id = Team1.TeamId
  JOIN Team Team2 ON Team2Id = Team2.TeamId
 WHERE RefereeId = 3;
