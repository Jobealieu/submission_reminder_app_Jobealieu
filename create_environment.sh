#!/bin/bash

echo "=== Submission Reminder App Setup ==="
echo "This script will create the application environment."
echo

# Get user's name
echo "Please enter your name:"
read -r user_name

# Validate input
if [ -z "$user_name" ]; then
    echo "Error: Name cannot be empty!"
    exit 1
fi

echo "Setting up environment for: $user_name"

# Create main directory
main_dir="submission_reminder_${user_name// /_}"  # Replace spaces with underscores
echo "Creating directory: $main_dir"

if [ -d "$main_dir" ]; then
    echo "Warning: Directory $main_dir already exists!"
    echo "Do you want to continue? (y/n)"
    read -r continue_choice
    if [ "$continue_choice" != "y" ] && [ "$continue_choice" != "Y" ]; then
        echo "Setup cancelled."
        exit 0
    fi
    rm -rf "$main_dir"
fi

mkdir -p "$main_dir"
cd "$main_dir"

# Create subdirectories
echo "Creating subdirectories..."
mkdir -p app
mkdir -p modules  
mkdir -p assets
mkdir -p config

echo "Directory structure created successfully!"

# Create config.env file
echo "Creating config/config.env..."
cat > config/config.env << 'EOF'
# This is the config file
ASSIGNMENT="Shell Navigation"
DAYS_REMAINING=2
EOF

# Create reminder.sh file
echo "Creating app/reminder.sh..."
cat > app/reminder.sh << 'EOF'
#!/bin/bash

# Source environment variables and helper functions
source ./config/config.env
source ./modules/functions.sh

# Path to the submissions file
submissions_file="./assets/submissions.txt"

# Print remaining time and run the reminder function
echo "Assignment: $ASSIGNMENT"
echo "Days remaining to submit: $DAYS_REMAINING days"
echo "--------------------------------------------"

check_submissions $submissions_file
EOF

# Create functions.sh file
echo "Creating modules/functions.sh..."
cat > modules/functions.sh << 'EOF'
#!/bin/bash

# Function to read submissions file and output students who have not submitted
function check_submissions {
    local submissions_file=$1
    echo "Checking submissions in $submissions_file"

    # Skip the header and iterate through the lines
    while IFS=, read -r student assignment status; do
        # Remove leading and trailing whitespace
        student=$(echo "$student" | xargs)
        assignment=$(echo "$assignment" | xargs)
        status=$(echo "$status" | xargs)

        # Check if assignment matches and status is 'not submitted'
        if [[ "$assignment" == "$ASSIGNMENT" && "$status" == "not submitted" ]]; then
            echo "Reminder: $student has not submitted the $ASSIGNMENT assignment!"
        fi
    done < <(tail -n +2 "$submissions_file") # Skip the header
}
EOF

# Create submissions.txt file (with original data + 5 additional students)
echo "Creating assets/submissions.txt..."
cat > assets/submissions.txt << 'EOF'
student, assignment, submission status
Chinemerem, Shell Navigation, not submitted
Chiagoziem, Git, submitted
Divine, Shell Navigation, not submitted
Anissa, Shell Basics, submitted
Ahmed, Shell Navigation, submitted
Maria, Shell Navigation, not submitted
John, Git, not submitted
Sarah, Shell Basics, submitted
Michael, Shell Navigation, not submitted
Lisa, Git, submitted
EOF

# Create startup.sh file
echo "Creating startup.sh..."
cat > startup.sh << 'EOF'
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
EOF

# Make all .sh files executable
echo "Making shell scripts executable..."
find . -name "*.sh" -exec chmod +x {} \;

echo
echo "=========================================="
echo "   SETUP COMPLETE!"
echo "=========================================="
echo "Environment created successfully in: $PWD"
echo "To test the application, run: ./startup.sh"
echo
