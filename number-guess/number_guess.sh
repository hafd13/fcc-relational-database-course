#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

NUMBER=$(( RANDOM % 1000 + 1 ))
TRIES=0

echo Enter your username:
read USERNAME

GAMES_PLAYED=$($PSQL "select games_played from users where username = '$USERNAME'")
BEST_GAME=$($PSQL "select best_game from users where username = '$USERNAME'")

if [[ -z $GAMES_PLAYED ]]
then
  INSERT_USER=$($PSQL "insert into users(username, games_played) values('$USERNAME', 0)")
  echo Welcome, $USERNAME! It looks like this is your first time here.
  GAMES_PLAYED=0
else
  echo Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses.
fi

echo Guess the secret number between 1 and 1000:
read INPUT
let TRIES++

while [ $INPUT != $NUMBER ]
do
  if [[ ! $INPUT =~ ^[0-9]+$ ]]
  then
    echo That is not an integer, guess again:
  else
    if [ $INPUT -gt $NUMBER ]
    then
      echo "It's lower than that, guess again:"
    elif [ $INPUT -lt $NUMBER ]
    then
      echo "It's higher than that, guess again:"
    fi
  fi
  read INPUT
  let TRIES++
done

echo You guessed it in $TRIES tries. The secret number was $NUMBER. Nice job!

let GAMES_PLAYED++

if [[ -z $BEST_GAME ]]
then
  BEST_GAME=$TRIES
elif [ $TRIES -lt $BEST_GAME ]
then
  BEST_GAME=$TRIES
fi

UPDATE_USER=$($PSQL "update users set games_played = $GAMES_PLAYED, best_game = $BEST_GAME where username = '$USERNAME'")
