Automated Project Bootstrapping & Process Management
 Project Overview

This project implements a Project Factory using a Bash shell script (setup_project.sh) that automatically bootstraps a fully structured workspace for a Student Attendance Tracker application.

The goal is to demonstrate:

Infrastructure as Code (IaC)

Automated environment setup

Dynamic configuration using stream editing (sed)

Process lifecycle management using trap

Environment validation and defensive scripting

Instead of manually creating folders and configuration files, the script automates everything in seconds, ensuring:

Reproducibility

Efficiency

Reliability

Clean workspace management

Function of the script

When executed, the script:

Prompts the user for a project identifier.

Creates a structured directory named:

attendance_tracker_<identifier>


Builds the required architecture:

attendance_tracker_<identifier>/
│
├── attendance_checker.py
├── Helpers/
│   ├── assets.csv
│   └── config.json
└── reports/
    └── reports.log


Generates a default config.json with attendance thresholds.

Optionally updates threshold values using sed.

Performs a health check to verify python3 is installed.

Implements a SIGINT trap (Ctrl+C handler) to archive and clean up incomplete setups.

How to Run the Script

Make the script executable:

chmod +x setup_project.sh


Run it:

./setup_project.sh


You will be prompted to:

Enter a project identifier

Choose whether to update attendance thresholds

Dynamic Configuration (sed Logic)

If the user chooses to update thresholds:

The script requests new values.

It validates that input is numeric using regex.

It performs in-place modification of config.json using:

sed -i


This ensures configuration is dynamically injected without manually editing files.

Process Management – The Trap (SIGINT Handling)

One of the key features of this project is signal handling using trap.

The script registers a handler for:

SIGINT (Ctrl + C)

What Happens on Interrupt?

If the user presses Ctrl + C during execution:

The cleanup_on_interrupt function executes.

The current project directory is archived into:

attendance_tracker_<identifier>_archive.tar.gz


The incomplete project directory is deleted.

The script exits safely.

This prevents:

Partial setup

Broken directory structures

Workspace clutter

How the Trap Was Tested

The trap functionality was tested using the following procedure:

Run the script:

./setup_project.sh


Enter a project identifier.

Before the script finishes execution, press:

Ctrl + C


Expected behavior:

An archive file is created.

The incomplete project directory is removed.

A confirmation message is printed.

Verification commands used:

ls


Expected result:

Archive file exists

Project directory does NOT exist

This confirms:

Signal was successfully intercepted.

Cleanup logic executed correctly.

No orphan directories remain.

Environment Validation (System Check)

Before completing execution, the script checks:

python3 --version


If Python is found:

Python3 is present in the environment.


If not:

Python3 is missing. Please install Python3.


This ensures the deployment environment is properly configured.

Error Handling & Defensive Measures

The script includes:

Directory existence checks (prevents overwriting)

Numeric validation for threshold input

Exit if there is an error (set -e)

Structured validation of required files

Controlled signal cleanup

These measures ensure robust execution and reduce human error.

Repository Contents

This repository contains:

setup_project.sh    Main deployment script
README.md           Documentation
.gitignore          Prevents generated files from being committed


Generated project directories and archive files are intentionally excluded from version control and the git hub repository.
