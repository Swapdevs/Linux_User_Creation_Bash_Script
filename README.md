## Efficient User Management with Bash Scripting.
Managing user accounts and their respective groups can be a daunting task, especially in a growing company. As a SysOps engineer, automating this process saves time and minimizes the risk of human error. In this article, we will walk you through a Bash script designed to streamline user and group management by reading input from a text file. This script will create users, assign them to groups, generate random passwords, and log all actions for audit purposes.

## Script Overview
The script create_users.sh performs the following tasks:
- Read Input File: It reads a text file where each line contains a username and associated groups separated by a semicolon.
- Create Users and Groups: It creates users and their personal groups if they don’t already exist, and assigns users to additional groups as specified.
- Generate Passwords: It generates random passwords for the users and stores them securely.
- Log Actions: It logs all actions to /var/log/user_management.log.
- Secure Password Storage: It stores the generated passwords in /var/secure/user_passwords.csv with restricted permissions.

## Detailed Breakdown
- Input Validation: The script starts by checking if an input file is provided as an argument. If not, it exits with a usage message.
- Log and Password Files: The script initializes log and password files, ensuring appropriate permissions for security and auditing.
- Password Generation: A function is defined to generate random passwords using OpenSSL.
- Processing Input File: The script reads each line from the input file, trimming any whitespace around usernames and groups.
- User and Group Management: For each user, it checks if the user already exists. If not, it creates the user and their home directory. It then creates a personal group for the user and adds the user to any additional groups specified in the input file.
- Password Assignment and Home Directory Permissions: The script generates a password for each user, updates the user’s password, and stores the credentials securely. It also sets the appropriate permissions for the user’s home directory to ensure privacy.

##Conclusion
By automating user management tasks with a Bash script, you can significantly reduce administrative overhead and improve the security of your system. This script demonstrates a robust approach to handling user creation, group assignments, password management, and logging.
For more insights and opportunities, explore the [HNG Internship program](https://hng.tech/internship) and learn how it can help you advance your career. Additionally, if you want to hire skilled professionals, consider [HNG’s hiring services](https://hng.tech/hire) for top-notch talent.
This script and article exemplify how automation can enhance efficiency and security in system operations, making it an invaluable tool for SysOps engineers.





