#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"
SECRET_NUMBER=$((1 + RANDOM % 1000))
NUMBER_OF_GUESSES=0

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

echo "Guess the secret number between 1 and 1000:"; read GUESS
until [ $GUESS == $SECRET_NUMBER ]; do
  if [[ ! $GUESS =~ ^[0-9]+$ ]]; then
    echo "That is not an integer, guess again:"
    read GUESS
  elif [[ $GUESS < $SECRET_NUMBER ]]; then
    (( NUMBER_OF_GUESSES++ ))
    echo "It's higher than that, guess again:"
    read GUESS
  elif [[ $GUESS > $SECRET_NUMBER ]]; then
    (( NUMBER_OF_GUESSES++ ))
    echo "It's lower than that, guess again:"
    read GUESS
  fi
done

GET_GUESSES=$($PSQL "SELECT best_game FROM user_data where username='$USERNAME'")
if [[ $GET_GUESSES < $NUMBER_OF_GUESSES ]]; then
  ADD_GUESSES=$($PSQL "UPDATE user_data SET best_game = $NUMBER_OF_GUESSES WHERE username='$USERNAME'")
fi
ADD_GAMES_PLAYED=$($PSQL "UPDATE user_data SET games_played=games_played+1 WHERE username='$USERNAME'")
echo "You guessed it in $NUMBER_OF_GUESSES tries. The secret number was $SECRET_NUMBER. Nice job!"
