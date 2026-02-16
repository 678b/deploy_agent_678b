#!/bin/bash

# Exit if there is an error
set -e

#  GLOBAL VARIABLES
PROJECT_NAME=""
ARCHIVE_NAME=""

# TRAP FUNCTION
cleanup_on_interrupt() {
    echo ""
    echo "Script  is interrupted. Archiving the current state..."

    if [ -d "$PROJECT_NAME" ]; then
        tar -czf "${ARCHIVE_NAME}.tar.gz" "$PROJECT_NAME"
        rm -rf "$PROJECT_NAME"
        echo " Archive created: ${ARCHIVE_NAME}.tar.gz"
        echo " Incomplete directory removed."
    fi

    exit 1
}

trap cleanup_on_interrupt SIGINT

#  USER INPUT
read -p "Enter project identifier: " INPUT

if [ -z "$INPUT" ]; then
    echo " Project identifier is required and cannot be empty."
    exit 1
fi

PROJECT_NAME="attendance_tracker_${INPUT}"
ARCHIVE_NAME="${PROJECT_NAME}_archive"

#  CREATION OF DIRECTORIES
if [ -d "$PROJECT_NAME" ]; then
    echo "Directory already exists."
    exit 1
fi

mkdir -p "$PROJECT_NAME/Helpers"
mkdir -p "$PROJECT_NAME/reports"

touch "$PROJECT_NAME/attendance_checker.py"
touch "$PROJECT_NAME/Helpers/assets.csv"
touch "$PROJECT_NAME/Helpers/config.json"
touch "$PROJECT_NAME/reports/reports.log"

echo " Directory structure created successfully."

#  DEFAULT CONFIG CONTENT
cat <<EOF > "$PROJECT_NAME/Helpers/config.json"
{
  "warning_threshold": 75,
  "failure_threshold": 50
}
EOF

#  UPDATING THE CONFIGURATION
read -p "Do you want to update attendance thresholds? (y/n): " UPDATE

if [ "$UPDATE" = "y" ]; then

    read -p "Enter new warning threshold (default 75): " WARNING
    read -p "Enter new failure threshold (default 50): " FAILURE

    # Validation
    if [[ ! "$WARNING" =~ ^[0-9]+$ ]] || [[ ! "$FAILURE" =~ ^[0-9]+$ ]]; then
        echo "❌ Thresholds must be numeric."
        exit 1
    fi

    sed -i "s/\"warning_threshold\": [0-9]*/\"warning_threshold\": $WARNING/" "$PROJECT_NAME/Helpers/config.json"
    sed -i "s/\"failure_threshold\": [0-9]*/\"failure_threshold\": $FAILURE/" "$PROJECT_NAME/Helpers/config.json"

    echo " Thresholds updated successfully."
fi

#  SYSTEM CHECK
echo " Running environment system check..."

if python3 --version >/dev/null 2>&1; then
    echo " Python3 is present in the environment."
else
    echo "Python3  is missing. Please install Python3."
fi

# PROJECT STRUCTURE VALIDATION
if [ -f "$PROJECT_NAME/attendance_checker.py" ] &&
   [ -f "$PROJECT_NAME/Helpers/assets.csv" ] &&
   [ -f "$PROJECT_NAME/Helpers/config.json" ] &&
   [ -f "$PROJECT_NAME/reports/reports.log" ]; then
   echo " Directory structure validated."
else
   echo " Structure validation failed."
   exit 1
fi

echo " Project setup completed successfully."

