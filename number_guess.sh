#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"
SECRET_NUMBER=$(( 1 + RANDOM % 1000 ))
NUMBER_OF_GUESSES=0

# user "login"
echo -e "\nEnter your username:"; read USERNAME
REGISTERED_USER=$($PSQL "SELECT username FROM user_data WHERE username='$USERNAME'")
if [[ -z $REGISTERED_USER ]]; then
  ADD_USERNAME=$($PSQL "INSERT INTO user_data(username) VALUES('$USERNAME')")
  echo -e "\nWelcome, $USERNAME! It looks like this is your first time here."
else
  GAMES_PLAYED=$($PSQL "SELECT games_played FROM user_data WHERE username='$REGISTERED_USER'")
  BEST_GAME=$($PSQL "SELECT best_game FROM user_data WHERE username='$REGISTERED_USER'")
  echo -e "\nWelcome back, $REGISTERED_USER! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
fi

# game loop
echo -e "\nGuess the secret number between 1 and 1000:"; read GUESS
until [[ $GUESS == $SECRET_NUMBER ]]; do
  if [[ ! $GUESS =~ ^[0-9]+$ ]]; then
    # (( NUMBER_OF_GUESSES++ ))
    echo -e "\nThat is not an integer, guess again:"
    read GUESS
  elif [[ $GUESS -lt $SECRET_NUMBER ]]; then
    (( NUMBER_OF_GUESSES++ ))
    echo -e "\nIt's higher than that, guess again:"
    read GUESS
  elif [[ $GUESS -gt $SECRET_NUMBER ]]; then
    (( NUMBER_OF_GUESSES++ ))
    echo -e "\nIt's lower than that, guess again:"
    read GUESS
  fi
done

# user successfully guesses the number
(( NUMBER_OF_GUESSES++ ))
GET_GUESSES=$($PSQL "SELECT best_game FROM user_data where username='$USERNAME'")
if [[ $NUMBER_OF_GUESSES -lt $GET_GUESSES ]] || [[ $GET_GUESSES -eq 0 ]]; then
  ADD_GUESSES=$($PSQL "UPDATE user_data SET best_game = $NUMBER_OF_GUESSES WHERE username='$USERNAME'")
fi
ADD_GAMES_PLAYED=$($PSQL "UPDATE user_data SET games_played=games_played+1 WHERE username='$USERNAME'")
echo -e "\nYou guessed it in $NUMBER_OF_GUESSES tries. The secret number was $SECRET_NUMBER. Nice job!"
