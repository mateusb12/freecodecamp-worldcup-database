-- Create the worldcup database
CREATE DATABASE worldcup;

-- Connect to the worldcup database
\c worldcup;

-- Create the teams table
CREATE TABLE teams (
    team_id SERIAL PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL
);

-- Create the games table
CREATE TABLE games (
    game_id SERIAL PRIMARY KEY,
    year INT NOT NULL,
    round VARCHAR(50) NOT NULL,
    winner_id INT NOT NULL REFERENCES teams(team_id),
    opponent_id INT NOT NULL REFERENCES teams(team_id),
    winner_goals INT NOT NULL,
    opponent_goals INT NOT NULL
);

-- Ensure that the tables are created successfully
\dt

-- Ensure that the columns in the tables are created successfully
\d teams
\d games
