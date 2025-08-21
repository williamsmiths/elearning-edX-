#!/bin/bash
# MySQL initialization script for edX platform

echo "=== Initializing edX MySQL Databases ==="

# Wait for MySQL to be ready
until mysql -h localhost -u root -p${MYSQL_ROOT_PASSWORD} -e "SELECT 1" >/dev/null 2>&1; do
    echo "Waiting for MySQL to be ready..."
    sleep 2
done

# Create databases
mysql -h localhost -u root -p${MYSQL_ROOT_PASSWORD} <<EOF

-- Create main edX database
CREATE DATABASE IF NOT EXISTS edxapp DEFAULT CHARACTER SET utf8mb4 DEFAULT COLLATE utf8mb4_unicode_ci;

-- Create student module history database
CREATE DATABASE IF NOT EXISTS edxapp_csmh DEFAULT CHARACTER SET utf8mb4 DEFAULT COLLATE utf8mb4_unicode_ci;

-- Create test databases
CREATE DATABASE IF NOT EXISTS test_edxapp DEFAULT CHARACTER SET utf8mb4 DEFAULT COLLATE utf8mb4_unicode_ci;
CREATE DATABASE IF NOT EXISTS test_edxapp_csmh DEFAULT CHARACTER SET utf8mb4 DEFAULT COLLATE utf8mb4_unicode_ci;

-- Create edX user
CREATE USER IF NOT EXISTS 'edxapp001'@'%' IDENTIFIED BY 'password';

-- Grant permissions for main databases
GRANT ALL PRIVILEGES ON edxapp.* TO 'edxapp001'@'%';
GRANT ALL PRIVILEGES ON edxapp_csmh.* TO 'edxapp001'@'%';

-- Grant permissions for test databases
GRANT ALL PRIVILEGES ON test_edxapp.* TO 'edxapp001'@'%';
GRANT ALL PRIVILEGES ON test_edxapp_csmh.* TO 'edxapp001'@'%';

-- Grant permission to create test databases
GRANT CREATE ON *.* TO 'edxapp001'@'%';

-- Flush privileges
FLUSH PRIVILEGES;

-- Show created databases
SHOW DATABASES;

-- Show users
SELECT User, Host FROM mysql.user WHERE User LIKE 'edx%';

EOF

echo "✅ MySQL databases and users created successfully!"
echo "📊 Databases created:"
echo "  - edxapp (main database)"
echo "  - edxapp_csmh (student module history)"
echo "  - test_edxapp (test database)"
echo "  - test_edxapp_csmh (test student module history)"
echo ""
echo "👤 Users created:"
echo "  - edxapp001 (main user)"
