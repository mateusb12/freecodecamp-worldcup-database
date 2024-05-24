#!/bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

# Clear existing data
$PSQL "TRUNCATE TABLE games, teams RESTART IDENTITY"

# Insert unique teams from games.csv
echo "Inserting teams data..."
cat games.csv | while IFS=',' read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $WINNER != 'winner' ]]
  then
    # Insert winner team
    $PSQL "INSERT INTO teams(name) VALUES('$WINNER') ON CONFLICT (name) DO NOTHING;"

    # Insert opponent team
    $PSQL "INSERT INTO teams(name) VALUES('$OPPONENT') ON CONFLICT (name) DO NOTHING;"
  fi
done

# Insert games data
echo "Inserting games data..."
cat games.csv | while IFS=',' read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != 'year' ]]
  then
    # Get team ids
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

    # Insert game into games table
    GAME_INSERT_RESULT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
    if [[ $GAME_INSERT_RESULT == "INSERT 0 1" ]]
    then
      echo "Inserted into games: $YEAR $ROUND $WINNER vs $OPPONENT"
    else
      echo "Error inserting into games: $YEAR $ROUND $WINNER vs $OPPONENT"
    fi
  fi
done

# Verify final results
echo "Verifying final games data..."
$PSQL "SELECT * FROM games LIMIT 5"
