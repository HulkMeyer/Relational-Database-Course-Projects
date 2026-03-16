# SHEBANG - Tells system to run script
#! /bin/bash

# Creates PSQL variable to store command
PSQL="psql --username=freecodecamp --dbname=salon --no-align --tuples-only -c"

# Prints Appl Name
echo -e "\n~~~~~ Salon Appointment Scheduler ~~~~~\n"

# Create Main Menu Function
MAIN_MENU() {

# Checks if the function was called with $1
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi

#State available services
echo -e "\nHere are the available services:\n"

# Pulls all services from from DB and creates a list of the form 1) "service"
echo "$($PSQL "SELECT service_id, name FROM services ORDER BY service_id")" | while IFS="|" read SERVICE_ID NAME
do
  echo "$SERVICE_ID) $NAME"
done

# Asks user to make a selection of service by entering the id
echo -e "\nWhich service would you like? Enter a service ID:"
read SERVICE_ID_SELECTED

# Checks the database for the service name and stores it in variable called SERVICE
SERVICE=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")

# checks to see if variable service is empty; if empty calls main menu again, prompting them to make a vaild selection
if [[ -z $SERVICE ]]
then
  MAIN_MENU "That service does not exist. Please try again."
else

#prints a prompt asking for the customers phone number
echo -e "\nWhat is your phone number?"
read CUSTOMER_PHONE

# Checks the database to see if the phone number already exists in the DB
CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")

# If this is a new customer, prompt for their name (would be a new customer if phone number was not already stored in the DB
if [[ -z $CUSTOMER_NAME ]]
then
  echo -e "\nI don't have a record for that phone number. What's your name?"
  read CUSTOMER_NAME
  INSERT_CUSTOMER=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
fi

# Queries the database for customer_id
CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")

# Asking the customer what time they would like their appointment
echo -e "\nWhat time for your appointment?"
read SERVICE_TIME

# Inserts a new row inot the appt table suing the information collected
INSERT_APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")

# Prints Appt Confirmation for Client
echo -e "\nI have put you down for a $SERVICE at $SERVICE_TIME, $CUSTOMER_NAME."

# Closing if/else loop
    fi
}

# Line calling MAIN_MENU to run
MAIN_MENU