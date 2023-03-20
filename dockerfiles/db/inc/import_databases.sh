#!/bin/bash

# Loop through all SQL dump files in /var/db_dumps
for f in /var/db_dumps/*.sql
do
    # Get the filename without the extension
    db_name=$(basename "$f" .sql)

    # Create the database
    echo "Creating database: $db_name"
    mysql -u root -e "CREATE DATABASE $db_name;"

    # Import the SQL dump
    echo "Importing $f into $db_name"
    mysql -u root "$db_name" < "$f"
done
