
# Submission Reminder App

A shell-based application that helps track and remind students about assignment submissions.

## Features

- Automated environment setup
- Student submission tracking
- Assignment deadline reminders
- Dynamic assignment configuration

## Files Structure


submission_reminder_{Jobealieu}/
├── app/
│   ├── reminder.sh          # Main reminder logic
│   └── functions.sh         # Helper functions (in modules/)
├── modules/
│   └── functions.sh         # Submission checking functions
├── assets/
│   └── submissions.txt      # Student submission data
├── config/
│   └── config.env          # Application configuration
└── startup.sh              # Application launcher


## Usage

### 1. Setting Up the Environment

Run the setup script:

bash
./create_environment.sh
Enter your name when prompted. This will create the complete application structure.

### 2. Running the Application

Navigate to the created directory:

bash
cd submission_reminder_{Jobealieu}
./startup.sh

### 3. Changing Assignment Names

Use the copilot script to update assignment names:

bash
./copilot_shell_script.sh
Enter the new assignment name when prompted.

## Requirements

- Bash shell
- Unix-like operating system (Linux/macOS)
- Read/write permissions in the current directory

## Author

Alieu O Jobe

## Assignment

This project was created as part of the Individual Summative Lab for Introduction to Linux and IT Tools.
