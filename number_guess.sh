#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"
random_number=$(($RANDOM % 1000 + 1))

echo "Enter your username:"
read username

user_returned=$($PSQL "select username from users where username = '$username'")


if [[ -z $user_returned ]]
then
  user_insert=$($PSQL "insert into users(username) values('$username')")
  echo "Welcome, $username! It looks like this is your first time here."
else
  games_played=$($PSQL "select count(*) from games inner join users using (user_id) where username = '$username'")
  best_game=$($PSQL "select min(guesses) from games inner join users using (user_id) where username = '$username'")
  echo "Welcome back, $username! You have played $games_played games, and your best game took $best_game guesses."
fi

# get user_id
user_id=$($PSQL "select user_id from users where username = '$username'")
#echo "$user_id"

#echo "$random_number"
echo "Guess the secret number between 1 and 1000:"
number_of_guesses=0
guessed=0

while [[ $guessed = 0 ]]
do
    read guess

  #if not a number
  if [[ ! $guess =~ ^[0-9]+$ ]]
  then
    echo "That is not an integer, guess again:"
  
  # if correct guess
  elif [[ $random_number = $guess ]]
  then
    number_of_guesses=$(($number_of_guesses + 1))
    echo "You guessed it in $number_of_guesses tries. The secret number was $random_number. Nice job!"
    # insert into db
    data_insert=$($PSQL "insert into games(user_id, guesses) values($user_id, $number_of_guesses)")
    guessed=1
  # if greater
  elif [[ $guess -lt $random_number ]]
  then
    number_of_guesses=$(($number_of_guesses + 1))
    echo "It's higher than that, guess again:"
  # if smaller
  else
    echo "It's lower than that, guess again:"
  fi

done







