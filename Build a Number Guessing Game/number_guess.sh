#!/bin/bash

# Storing Database connection as a variable for easy access
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

# Generate random number between 1 and 1000
SECRET_NUMBER=$(( RANDOM % 1000 + 1 ))

# Ask for username
echo "Enter your username:"
read USERNAME

# Check if username exists
USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$USERNAME'")

# If user_id is empty, Insert name in DB, Queries user_id, then prints welcome message
if [[ -z $USER_ID ]]
then
  # New user
  INSERT_USER=$($PSQL "INSERT INTO users(username) VALUES('$USERNAME')")
  USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$USERNAME'")
  echo "Welcome, $USERNAME! It looks like this is your first time here."

# IF user_id is not empty, queries the DB for number of games and best game and give welcome back message
else
  # Existing user
  GAMES_PLAYED=$($PSQL "SELECT games_played FROM users WHERE user_id=$USER_ID")
  BEST_GAME=$($PSQL "SELECT best_game FROM users WHERE user_id=$USER_ID")
  echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
fi

# Start guessing cycle
echo "Guess the secret number between 1 and 1000:"
read GUESS

# Initializing the counter
NUMBER_OF_GUESSES=1

# Start guessing while loop
while [[ $GUESS != $SECRET_NUMBER ]]
do
 
# Check is guess is an integer, outputs not integer if it is not 
  if [[ ! $GUESS =~ ^[0-9]+$ ]]
  then
    echo "That is not an integer, guess again:"
  
#  triggered if an integer was guessed but is higher than target number
  elif [[ $GUESS -gt $SECRET_NUMBER ]]
  then
    echo "It's lower than that, guess again:"
  
#  triggered if an integer was guessed but is lower than target number
  else
    echo "It's higher than that, guess again:"
  fi

# Wait for the user to enter another guess
  read GUESS
  (( NUMBER_OF_GUESSES++ ))
done

# Won - update database
echo "You guessed it in $NUMBER_OF_GUESSES tries. The secret number was $SECRET_NUMBER. Nice job!"

# Update DB with user_id and number of guesses; then updates games_played  with interating 1 one game for the user_id
INSERT_GAME=$($PSQL "INSERT INTO games(user_id, guesses) VALUES($USER_ID, $NUMBER_OF_GUESSES)")
UPDATE_GAMES_PLAYED=$($PSQL "UPDATE users SET games_played = games_played + 1 WHERE user_id=$USER_ID")

# Update best game; checks the users best game and if new game is lower it is updated
BEST_GAME=$($PSQL "SELECT best_game FROM users WHERE user_id=$USER_ID")
if [[ -z $BEST_GAME || $NUMBER_OF_GUESSES -lt $BEST_GAME ]]
then
  UPDATE_BEST=$($PSQL "UPDATE users SET best_game=$NUMBER_OF_GUESSES WHERE user_id=$USER_ID")
fi