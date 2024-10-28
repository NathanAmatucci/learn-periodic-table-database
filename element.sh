#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# Check if user has provided an argument
if [[ -z $1 ]]; 
then
  echo -e "Please provide an element as an argument."
  exit 0
else
  # Query based on input (atomic number, symbol, or name)
  if [[ $1 =~ ^[0-9]+$ ]]; then
    # If input is a number (atomic number)
    ELEMENT_QUERY=$($PSQL "SELECT elements.atomic_number, elements.name, elements.symbol, types.type, properties.atomic_mass, properties.melting_point_celsius, properties.boiling_point_celsius FROM elements INNER JOIN properties ON elements.atomic_number = properties.atomic_number INNER JOIN types ON properties.type_id = types.type_id WHERE elements.atomic_number = $1")
  elif [[ $1 =~ ^[A-Z][a-z]?$ ]]; then
    # If input is a symbol
    ELEMENT_QUERY=$($PSQL "SELECT elements.atomic_number, elements.name, elements.symbol, types.type, properties.atomic_mass, properties.melting_point_celsius, properties.boiling_point_celsius FROM elements INNER JOIN properties ON elements.atomic_number = properties.atomic_number INNER JOIN types ON properties.type_id = types.type_id WHERE elements.symbol = '$1'")
  else
    # If input is a name
    ELEMENT_QUERY=$($PSQL "SELECT elements.atomic_number, elements.name, elements.symbol, types.type, properties.atomic_mass, properties.melting_point_celsius, properties.boiling_point_celsius FROM elements INNER JOIN properties ON elements.atomic_number = properties.atomic_number INNER JOIN types ON properties.type_id = types.type_id WHERE elements.name = '$1'")
  fi

  # Check if the query returned a result
  if [[ -z $ELEMENT_QUERY ]]; then
    echo "I could not find that element in the database."
    exit 0
  fi
  




  # Read results into variables
  IFS="|" read ATOMIC_NUMBER NAME SYMBOL TYPE ATOMIC_MASS MELTING_POINT BOILING_POINT <<< "$ELEMENT_QUERY"

  # Output the result
  echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
fi

