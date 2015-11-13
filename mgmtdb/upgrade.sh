#!/bin/bash

# Upgrade steps
# 1. Get the last version installed from database
# 2. Find next 1000 files in sequence
#   a. When a file is found, run the script with version update and error checks
#   b. When a file is NOT found, stop processing

# Default settings
production=false
continue_on_error=false
db_host=localhost
help_message=false
pref_next_db_version=0

#
while getopts "cphn:" opt; do
     case $opt in
         c) continue_on_error=true;;
         p) production=true;;
         n) pref_next_db_version=$OPTARG;;
         h) help_message=true;;
     esac
done

# Help message
if [ "$help_message" == true ] ; then
    echo "Instructions to run the command:"
    echo "    ./upgrade.sh -c|p|h"
    echo "                 -c continue on error      (default: false)"
    echo "                 -p production             (default: false)"
    echo "                 -n next db version to run (default: latest)"
    echo "                 -h help message           (default: false)"
    echo ""
    exit 0
fi

# Production settings
if [ "$production" == true ] ; then
    db_host=wisehoot.csrqepoazh6f.us-east-1.rds.amazonaws.com
fi

# variables Setup
git_commit=$(git log --pretty=oneline | head -n 1)
server_info=$(uname -a)
install_user=$(whoami)

# Setup variables to run 1000 iterations at a time
if [ $pref_next_db_version == 0 ]; then
    curr_db_version=$(psql -h $db_host -U whuser -d whmgmt -P t -P format=unaligned -c "select COALESCE(MAX(db_version), 0) from version;")
else
    curr_db_version=$(($pref_next_db_version - 1))
fi

next_db_version=$(($curr_db_version + 1))
maxx_db_version=$(($next_db_version + 1000))
last_db_version=0

echo "Starting version: $next_db_version, Current: $curr_db_version"

# Iterate the possible versions
while [  $next_db_version -lt $maxx_db_version ]; do
    # Loop control
    found_version=false

    # Make next matching file
    file_version_search="upgrades/up$(seq -f "%04g" $next_db_version $next_db_version)_*.sql"

    # Loop the files
    for file in $file_version_search; do
        # Check for file validity
        if [ ! -f "$file" ]; then
            break
        fi
        found_version=true

        # Run the file now
        if [ $continue_on_error == true ]; then
            echo "Running SQL file (no error check): $file";

            # Continue on error
            psql -h $db_host -U whuser -d whmgmt -f $file
        else
            echo "Running SQL file: $file";

            # Stop on error
            psql -h $db_host -U whuser -d whmgmt -f $file --set ON_ERROR_STOP=on

            # Validate status to avoid unknown issues
            psql_exit_status=$?
            if [ $psql_exit_status != 0 ]; then
                echo "psql failed while trying to run this sql script" 1>&2
                exit $psql_exit_status
            fi
        fi
    done

    # Last one found, stop the loop
    if [ $found_version == false ]; then
        break
    fi

    # Add version information to the log
    psql -h $db_host -U whuser -d whmgmt -c "INSERT INTO version (db_version, git_commit, server_info, install_user) VALUES ($next_db_version, '$git_commit', '$server_info', '$install_user');"

    # Increment for next version
    let last_db_version=next_db_version
    let next_db_version=next_db_version+1
done

# Last one found, stop the loop
if [ $last_db_version == 0 ]; then
    echo "$db_host database already upto date."
else
    echo "$db_host database upgraded successfully"
fi
