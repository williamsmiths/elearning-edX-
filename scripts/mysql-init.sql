-- Initialize databases for Open edX
-- Create the main edxapp database
CREATE DATABASE IF NOT EXISTS edxapp CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Create the student module history database 
CREATE DATABASE IF NOT EXISTS student_module_history CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Grant all privileges to edxapp_user on both databases
GRANT ALL PRIVILEGES ON edxapp.* TO 'edxapp_user'@'%';
GRANT ALL PRIVILEGES ON student_module_history.* TO 'edxapp_user'@'%';

-- Also grant privileges to root user from any host for convenience
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'rootpassword' WITH GRANT OPTION;

-- Refresh privileges
FLUSH PRIVILEGES;

-- Display created databases
SHOW DATABASES;
