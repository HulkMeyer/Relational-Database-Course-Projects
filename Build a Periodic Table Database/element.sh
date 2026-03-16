#! /bin/bash

# Creating variable for storing database connection command
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# Checks to see if the argument has been passed
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."

# If there was an argument drop in here, Query the DB for Atomic Number
else
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    ELEMENT=$($PSQL "SELECT atomic_number, name, symbol FROM elements WHERE atomic_number=$1")

# If arguement was not a number, then drop in here looking for a symbol like H for Hydrogen
  else
    ELEMENT=$($PSQL "SELECT atomic_number, name, symbol FROM elements WHERE symbol='$1' OR name='$1'")
  fi

# Check if element is empty, if yes then nothing was found then get the output
  if [[ -z $ELEMENT ]]
  then
    echo "I could not find that element in the database."

# If element is not empty drop in here, Output the elements infomration
  else
    while IFS="|" read ATOMIC_NUMBER NAME SYMBOL
    do

# Run second query to get rest of information for element
      PROPERTIES=$($PSQL "SELECT atomic_mass, melting_point_celsius, boiling_point_celsius, type FROM properties INNER JOIN types USING(type_id) WHERE atomic_number=$ATOMIC_NUMBER")
      
# Loop through propoerties results row by row retrieving the 4 variables
      while IFS="|" read MASS MELTING BOILING TYPE
      do

# Outputs all variables collected in query in a sentence
        echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
 
# Close everything that we have opened above
      done <<< "$PROPERTIES"
    done <<< "$ELEMENT"
  fi
fi

# end of script
