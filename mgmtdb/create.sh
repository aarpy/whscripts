#!/bin/bash

# Global variables
production=false
drop_database=false
db_host=localhost

#
while getopts "dph" opt; do
     case $opt in
         d) drop_database=true;;
         p) production=true;;
         h) help_message=true;;
     esac
done

# Help message
if [ "$help_message" == true ] ; then
    echo "Instructions to run the command:"
    echo "    ./create.sh -d|p|h"
    echo "                 -c drop database & user  (default: false)"
    echo "                 -p production            (default: false)"
    echo "                 -h help message          (default: false)"
    echo ""
    exit 0
fi

# Production settings
if [ "$production" == true ] ; then
    db_host=wisehoot.csrqepoazh6f.us-east-1.rds.amazonaws.com
fi

# Check drop database command
if [ $production == false ] && [ $drop_database == true ]; then

    # Confirm with user
    echo "Are you sure to to drop the database and users (y/N)?"
    read TEMP
    if [ ! "$TEMP" == "y" ]; then
        exit 1
    fi

    # Drop the database and user
    echo "Dropping database and users"
    psql -h $db_host -U whuser -c 'DROP DATABASE IF EXISTS whmgmt;'
    if [ $? != 0 ]; then
        echo "psql failed to drop database" 1>&2
        exit
    fi

    psql -h $db_host -U whuser -c 'DROP USER IF EXISTS whuser;'
    if [ $? != 0 ]; then
        echo "psql failed to drop user" 1>&2
        exit
    fi
fi

#
echo "Creating database and users"


# Create database
psql -h $db_host -d template1 -U whuser -c 'CREATE DATABASE whmgmt;'

# Create user and grant permissions
if [ $production == false ]; then
    psql -h $db_host -d template1 -U whuser -c 'CREATE USER whuser WITH PASSWORD '"'"'wh$p!d5!98'"'"'';
    psql -h $db_host -U whuser -d whmgmt -c 'GRANT ALL PRIVILEGES ON DATABASE whmgmt to whuser;'
fi

# Create Basic Schema information
psql -h $db_host -U whuser -d whmgmt -f schema/tables/version.sql

#
echo "Completed successfully"
