#!/bin/bash

echo "=========================================="
echo "   SUBMISSION REMINDER APP STARTING"
echo "=========================================="
echo

# Check if required files exist
if [ ! -f "./config/config.env" ]; then
    echo "Error: config.env file not found!"
    exit 1
fi

if [ ! -f "./modules/functions.sh" ]; then
    echo "Error: functions.sh file not found!"
    exit 1
fi

if [ ! -f "./app/reminder.sh" ]; then
    echo "Error: reminder.sh file not found!"
    exit 1
fi

if [ ! -f "./assets/submissions.txt" ]; then
    echo "Error: submissions.txt file not found!"
    exit 1
fi

echo "All required files found. Starting the reminder application..."
echo

# Run the reminder application
bash ./app/reminder.sh

echo
echo "=========================================="
echo "   APPLICATION FINISHED"
echo "=========================================="
