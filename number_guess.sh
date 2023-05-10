#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"
SECRET_NUMBER=$((1 + RANDOM % 1000))

echo "Enter your username:"; read USERNAME
REGISTERED_USER=$($PSQL "SELECT username FROM user_data WHERE username='$USERNAME'")
if [[ -z $REGISTERED_USER ]]; then
  ADD_USERNAME=$($PSQL "INSERT INTO user_data(username) VALUES('$USERNAME')")
  echo "Welcome, $USERNAME! It looks like this is your first time here."
else
  GAMES_PLAYED=$($PSQL "SELECT games_played FROM user_data WHERE username='$REGISTERED_USER'")
  BEST_GAME=$($PSQL "SELECT best_game FROM user_data WHERE username='$REGISTERED_USER'")
  echo "Welcome back, $REGISTERED_USER! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
fi
