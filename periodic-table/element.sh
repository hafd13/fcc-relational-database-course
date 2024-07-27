#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

if [[ $1 ]]
  then
    if [[ $1 =~ ^[0-9]+$ ]]
    then
      QUERY_NUMBER=$($PSQL "select E.atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius from elements E inner join properties P on E.atomic_number = P.atomic_number inner join types T on P.type_id = T.type_id where E.atomic_number=$1")
      if [[ ! -z $QUERY_NUMBER ]]
      then
        echo $QUERY_NUMBER | while read NUMBER BAR NAME BAR SYMBOL BAR TYPE BAR MASS BAR MELTING BAR BOILING
        do
          echo The element with atomic number $NUMBER is $NAME \($SYMBOL\). It\'s a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius.
        done
      else
        echo I could not find that element in the database.
      fi
    else
      QUERY_SYMBOL=$($PSQL "select E.atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius from elements E inner join properties P on E.atomic_number = P.atomic_number inner join types T on P.type_id = T.type_id where symbol='$1'")
      if [[ ! -z $QUERY_SYMBOL ]]
      then
        echo $QUERY_SYMBOL | while read NUMBER BAR NAME BAR SYMBOL BAR TYPE BAR MASS BAR MELTING BAR BOILING
        do
          echo The element with atomic number $NUMBER is $NAME \($SYMBOL\). It\'s a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius.
        done
      else
        QUERY_NAME=$($PSQL "select E.atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius from elements E inner join properties P on E.atomic_number = P.atomic_number inner join types T on P.type_id = T.type_id where name='$1'")
        if [[ ! -z $QUERY_NAME ]]
        then
          echo $QUERY_NAME | while read NUMBER BAR NAME BAR SYMBOL BAR TYPE BAR MASS BAR MELTING BAR BOILING
          do
            echo The element with atomic number $NUMBER is $NAME \($SYMBOL\). It\'s a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius.
          done
        else
          echo I could not find that element in the database.
        fi
      fi
    fi
  else
   echo Please provide an element as an argument.
  fi
