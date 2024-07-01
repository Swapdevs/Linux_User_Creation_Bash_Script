#!/bin/bash

# Check if the input file is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <name-of-text-file>"
    exit 1
fi

INPUT_FILE=$1
LOG_FILE="/var/log/user_management.log"
PASSWORD_FILE="/var/secure/user_passwords.csv"

# Create log file and set permissions
touch $LOG_FILE
chmod 644 $LOG_FILE

# Create password file and set permissions
mkdir -p /var/secure
touch $PASSWORD_FILE
chmod 600 $PASSWORD_FILE

# Function to generate a random password
generate_password() {
    openssl rand -base64 12
}

# Read the input file and process each line
while IFS=';' read -r username groups; do
    username=$(echo $username | xargs) # trim whitespace
    groups=$(echo $groups | xargs) # trim whitespace

    # Skip empty lines
    [ -z "$username" ] && continue

    # Create the user if not exists
    if id -u "$username" >/dev/null 2>&1; then
        echo "User $username already exists." | tee -a $LOG_FILE
    else
        # Create a new user with a home directory
        useradd -m -s /bin/bash "$username"
        echo "Created user $username." | tee -a $LOG_FILE
    fi

    # Create a personal group for the user
    if ! getent group "$username" >/dev/null 2>&1; then
        groupadd "$username"
        usermod -a -G "$username" "$username"
        echo "Created personal group for $username." | tee -a $LOG_FILE
    fi

    # Add user to additional groups
    IFS=',' read -r -a group_array <<< "$groups"
    for group in "${group_array[@]}"; do
        group=$(echo $group | xargs) # trim whitespace
        if ! getent group "$group" >/dev/null 2>&1; then
            groupadd "$group"
            echo "Created group $group." | tee -a $LOG_FILE
        fi
        usermod -a -G "$group" "$username"
        echo "Added $username to group $group." | tee -a $LOG_FILE
    done

    # Generate a random password for the user
    password=$(generate_password)
    echo "$username:$password" | chpasswd
    echo "$username,$password" >> $PASSWORD_FILE
    echo "Set password for $username." | tee -a $LOG_FILE

    # Set permissions for the home directory
    chown -R "$username:$username" "/home/$username"
    chmod 700 "/home/$username"
    echo "Set home directory permissions for $username." | tee -a $LOG_FILE

done < "$INPUT_FILE"

echo "User management script completed." | tee -a $LOG_FILE
