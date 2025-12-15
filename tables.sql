CREATE TABLE Tournament(
	TournamentId SERIAL PRIMARY KEY,
	Name VARCHAR(100),
	Year INT NOT NULL,
	Place VARCHAR(100),
	Finished BOOLEAN
);

ALTER TABLE Tournament
	ADD CONSTRAINT ValidYear CHECK(Year BETWEEN(2000, 2050));

CREATE TABLE Representative(
	RepresentativeId SERIAL PRIMARY KEY,
	Name VARCHAR(100),
	Surname VARCHAR(100)
);

CREATE TABLE Team(
	TeamId SERIAL PRIMARY KEY,
	RepresentativeId INT REFERENCES Representative(RepresentativeId),
	Name VARCHAR(100),
	Country VARCHAR(100),
	Contact VARCHAR(100)
);

CREATE TABLE TeamAtTournament(
	TeamAtTournamentId SERIAL PRIMARY KEY,
	TournamentId INT REFERENCES Tournament(TournamentId),
	TeamId INT REFERENCES Team(TeamId),
	NumberOfPoints INT,
	FinalPosition INT, 
	PhaseReached VARCHAR(20)
);

CREATE TABLE GameType(
	GameTypeId SERIAL PRIMARY KEY,
	TournamentId INT REFERENCES Tournament(TorunamentId),
	Name VARCHAR(100)
);

CREATE TABLE Referee(
	Referee SERIAL PRIMARY KEY,
	Name VARCHAR(100),
	Surname VARCHAR(100),
	DateOfBirth DATE
);

CREATE TABLE Game(
	GameId SERIAL PRIMARY KEY,
	Team1Id INT REFERENCES Team(TeamId),
	Team2Id INT REFERENCES Team(TeamId),
	GameTypeId INT REFERENCES GameType(GameTypeId),
	DateAndStartTime TIMESTAMP,
	Team1Score INT DEFAULT 0,
	Team2Score INT DEFAULT 0,
	RefereeId INT REFERENCES Referee(RefereeId)
);

CREATE TABLE Player(
	PlayerId SERIAL PRIMARY KEY,
	TeamId INT REFERENCES Team(TeamId),
	Name VARCHAR(100),
	Surname VARCHAR(100),
	DateOfBirth DATE,
	Position VARCHAR(100)
);

CREATE TABLE GameEventType(
	GameEventTypeId SERIAL PRIMARY KEY,
	Name VARCHAR(100)
);

CREATE TABLE GameEvent(
	GameEventId SERIAL PRIMARY KEY,
	GameEventTypeId INT REFERENCES GameEventType(GameEventTypeId)
	GameId INT REFERENCES Game(GameId),
	MinuteOfGame INT
);