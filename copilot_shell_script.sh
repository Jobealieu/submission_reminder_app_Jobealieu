#!/bin/bash

echo "=========================================="
echo "   ASSIGNMENT COPILOT SCRIPT"
echo "=========================================="
echo

# Look for submission_reminder directory in current directory and subdirectories
app_dir=$(find . -maxdepth 2 -type d -name "submission_reminder_*" 2>/dev/null | head -1)

if [ -z "$app_dir" ]; then
    echo "Error: No submission_reminder app directory found!"
    echo "Please run create_environment.sh first to create the application structure."
    echo
    echo "Looking for directories starting with 'submission_reminder_'..."
    find . -name "submission_reminder_*" -type d 2>/dev/null || echo "No matching directories found."
    exit 1
fi

echo "Found application directory: $app_dir"
echo "Entering directory: $app_dir"
echo

# Navigate to the app directory
cd "$app_dir" || {
    echo "Error: Cannot enter directory $app_dir"
    exit 1
}

# Verify we have the correct structure
if [ ! -d "./config" ]; then
    echo "Error: config/ directory not found in $app_dir"
    echo "Please ensure create_environment.sh ran successfully."
    exit 1
fi

if [ ! -f "./config/config.env" ]; then
    echo "Error: config/config.env file not found!"
    echo "Please ensure create_environment.sh ran successfully."
    exit 1
fi

if [ ! -f "./startup.sh" ]; then
    echo "Error: startup.sh file not found!"
    echo "Please ensure create_environment.sh ran successfully."
    exit 1
fi

echo "✓ All required files found."
echo

# Get current assignment name
current_assignment=$(grep "ASSIGNMENT=" ./config/config.env | cut -d'"' -f2)
echo "Current assignment: $current_assignment"
echo

# Prompt for new assignment name
echo "Enter the new assignment name:"
read -r new_assignment

# Validate input
if [ -z "$new_assignment" ]; then
    echo "Error: Assignment name cannot be empty!"
    exit 1
fi

echo
echo "Updating assignment from '$current_assignment' to '$new_assignment'..."

# Create backup of config file
cp ./config/config.env ./config/config.env.backup

# Use sed to replace the assignment name in config.env
if sed -i.tmp "s/ASSIGNMENT=\".*\"/ASSIGNMENT=\"$new_assignment\"/" ./config/config.env; then
    # Remove the temporary file created by sed (on macOS)
    rm -f ./config/config.env.tmp
    echo "✓ Configuration file updated successfully."
else
    echo "✗ Error updating configuration file!"
    # Restore backup if sed failed
    mv ./config/config.env.backup ./config/config.env
    exit 1
fi

# Verify the change
updated_assignment=$(grep "ASSIGNMENT=" ./config/config.env | cut -d'"' -f2)

if [ "$updated_assignment" = "$new_assignment" ]; then
    echo "✓ Assignment successfully updated to: '$new_assignment'"
    # Remove backup file since update was successful
    rm -f ./config/config.env.backup
    echo
    
    # Show current configuration
    echo "Current configuration:"
    echo "--------------------"
    cat ./config/config.env
    echo "--------------------"
    echo
    
    echo "Would you like to run the application now to check submissions for '$new_assignment'? (y/n)"
    read -r run_choice
    
    if [ "$run_choice" = "y" ] || [ "$run_choice" = "Y" ]; then
        echo
        echo "Running startup.sh..."
        echo "=========================================="
        ./startup.sh
    else
        echo
        echo "You can run './startup.sh' later to check submissions for '$new_assignment'"
        echo "Or run this copilot script again from anywhere to change assignments."
    fi
else
    echo "✗ Error: Failed to update assignment name!"
    echo "Expected: '$new_assignment', but got: '$updated_assignment'"
    # Restore backup
    mv ./config/config.env.backup ./config/config.env
    exit 1
fi

echo
echo "=========================================="
echo "   COPILOT SCRIPT COMPLETED"
echo "=========================================="
