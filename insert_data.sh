#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
$PSQL "TRUNCATE TABLE games, teams;"

cat games.csv | while IFS="," read -r YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  #echo $YEAR $ROUND $WINNER $OPPONENT $WINNER_GOALS $OPPONENT_GOALS

  #CHECK IF HOME TEAM IN TABLE IF NOT INSERT
  if [[ $($PSQL "SELECT COUNT(*) FROM teams WHERE name='$WINNER';") == 0 && $WINNER != winner ]]
  then
    $PSQL "INSERT INTO teams(name) VALUES ('$WINNER');"
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER';")
  else
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER';")
  fi

  #CHECK IF AWAY TEAM IN TABLE IF NOT INSERT
  if [[ $($PSQL "SELECT COUNT(*) FROM teams WHERE name='$OPPONENT';") == 0 && $OPPONENT != opponent ]]
  then
    $PSQL "INSERT INTO teams(name) VALUES ('$OPPONENT');"
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT';")
  else
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT';")
  fi

  if [[ $YEAR != year && $ROUND != round && $WINNER != winner && $OPPONENT != opponent && $WINNER_GOALS != winner_goals && $OPPONENT_GOALS != opponent_goals ]]
  then
    echo "$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS);")"
  fi
done