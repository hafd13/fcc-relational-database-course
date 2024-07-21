#! /bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ MY SALON ~~~~~"
echo -e "\nWelcome to My Salon, how can I help you?\n"

DISPLAY_SERVICES() {
  echo "$SERVICES" | while read NUM BAR NAME_SERVICE
  do
    echo "$NUM) $NAME_SERVICE"
  done
  read SERVICE_ID_SELECTED
}

CREATE_APPOINTMENT() {
  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE
  EXISTS_CUSTOMER=$($PSQL "select * from customers where phone='$CUSTOMER_PHONE'")
  if [[ -z $EXISTS_CUSTOMER ]]
  then
    echo -e "\nI don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME
    INSERT_CUSTOMER=$($PSQL "insert into customers(name, phone) values ('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
  else
    CUSTOMER_NAME=$($PSQL "select name from customers where phone='$CUSTOMER_PHONE'")
  fi
  SERVICE_NAME=$($PSQL "select name from services where service_id=$SERVICE_ID_SELECTED")
  echo -e "\nWhat time would you like your $SERVICE_NAME, $CUSTOMER_NAME?"
  read SERVICE_TIME
  CUSTOMER_ID=$($PSQL "select customer_id from customers where phone='$CUSTOMER_PHONE'")
  INSERT_APPOINTMENT=$($PSQL "insert into appointments (customer_id, service_id, time) values ($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
  echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
}

SERVICES=$($PSQL "select * from services")
DISPLAY_SERVICES
EXISTS_SERVICE=$($PSQL "select * from services where service_id=$SERVICE_ID_SELECTED")
if [[ -z $EXISTS_SERVICE ]]
then
  echo -e "\nI could not find that service. What would you like today?"
  DISPLAY_SERVICES
else
  CREATE_APPOINTMENT
fi
