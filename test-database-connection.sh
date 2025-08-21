#!/bin/bash

# Script test kết nối database cho edX
# Kiểm tra tất cả kết nối database theo cấu hình trong local.py

set -e

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}=== KIỂM TRA KẾT NỐI DATABASE EDX ===${NC}"
echo "Theo cấu hình trong lms/envs/local.py"
echo ""

# Test MySQL connection
echo -e "${YELLOW}🔍 Kiểm tra MySQL...${NC}"
if mysql -h localhost -P 3306 -u edxapp001 -ppassword -e "SELECT 1;" >/dev/null 2>&1; then
    echo -e "${GREEN}✅ MySQL kết nối thành công${NC}"
    
    # Check databases
    echo "📊 Kiểm tra databases:"
    mysql -h localhost -P 3306 -u edxapp001 -ppassword -e "SHOW DATABASES;" | grep -E "(edxapp|edxapp_csmh)" | while read db; do
        echo "  ✓ $db"
    done
else
    echo -e "${RED}❌ MySQL kết nối thất bại${NC}"
    echo "Thông tin kết nối:"
    echo "  Host: localhost"
    echo "  Port: 3306"
    echo "  User: edxapp001"
    echo "  Password: password"
fi

echo ""

# Test MongoDB connection
echo -e "${YELLOW}🔍 Kiểm tra MongoDB...${NC}"
if mongo --host localhost:27017 --authenticationDatabase admin -u edxapp -p password edxapp --eval "db.runCommand('ismaster').ismaster" >/dev/null 2>&1; then
    echo -e "${GREEN}✅ MongoDB kết nối thành công${NC}"
    
    # Check collections
    echo "📊 Kiểm tra collections:"
    mongo --host localhost:27017 --authenticationDatabase admin -u edxapp -p password edxapp --quiet --eval "db.getCollectionNames()" | tr ',' '\n' | sed 's/\[//g' | sed 's/\]//g' | sed 's/"//g' | while read collection; do
        if [ ! -z "$collection" ]; then
            echo "  ✓ $collection"
        fi
    done
else
    echo -e "${RED}❌ MongoDB kết nối thất bại${NC}"
    echo "Thông tin kết nối:"
    echo "  Host: localhost"
    echo "  Port: 27017"
    echo "  Database: edxapp"
    echo "  User: edxapp"
    echo "  Password: password"
    echo "  Auth Source: admin"
fi

echo ""

# Test Redis connection
echo -e "${YELLOW}🔍 Kiểm tra Redis...${NC}"
if redis-cli -h localhost -p 6379 ping >/dev/null 2>&1; then
    echo -e "${GREEN}✅ Redis kết nối thành công${NC}"
    echo "📊 Redis info:"
    redis-cli -h localhost -p 6379 info server | grep "redis_version"
else
    echo -e "${RED}❌ Redis kết nối thất bại${NC}"
    echo "Thông tin kết nối:"
    echo "  Host: localhost"
    echo "  Port: 6379"
fi

echo ""

# Test Memcached connection
echo -e "${YELLOW}🔍 Kiểm tra Memcached...${NC}"
if echo "version" | nc localhost 11211 >/dev/null 2>&1; then
    echo -e "${GREEN}✅ Memcached kết nối thành công${NC}"
    echo "📊 Memcached version:"
    echo "version" | nc localhost 11211 | head -1
else
    echo -e "${RED}❌ Memcached kết nối thất bại${NC}"
    echo "Thông tin kết nối:"
    echo "  Host: localhost"
    echo "  Port: 11211"
fi

echo ""

# Test Elasticsearch (optional)
echo -e "${YELLOW}🔍 Kiểm tra Elasticsearch...${NC}"
if curl -s http://localhost:9200/_cluster/health >/dev/null 2>&1; then
    echo -e "${GREEN}✅ Elasticsearch kết nối thành công${NC}"
    curl -s http://localhost:9200/ | grep "cluster_name"
else
    echo -e "${YELLOW}⚠️  Elasticsearch không khả dụng (tùy chọn)${NC}"
fi

echo ""
echo -e "${BLUE}=== KẾT THÚC KIỂM TRA ===${NC}"

# Summary for edX configuration
echo ""
echo -e "${BLUE}📋 Tóm tắt cấu hình cho edX:${NC}"
echo ""
echo "File: lms/envs/local.py"
echo "DATABASES = {"
echo "    'default': {"
echo "        'ENGINE': 'django.db.backends.mysql',"
echo "        'NAME': 'edxapp',"
echo "        'USER': 'edxapp001',"
echo "        'PASSWORD': 'password',"
echo "        'HOST': 'localhost',"
echo "        'PORT': '3306',"
echo "    },"
echo "    'student_module_history': {"
echo "        'ENGINE': 'django.db.backends.mysql',"
echo "        'NAME': 'edxapp_csmh',"
echo "        'USER': 'edxapp001',"
echo "        'PASSWORD': 'password',"
echo "        'HOST': 'localhost',"
echo "        'PORT': '3306',"
echo "    }"
echo "}"
echo ""
echo "DOC_STORE_CONFIG = {"
echo "    'host': 'localhost',"
echo "    'port': 27017,"
echo "    'db': 'edxapp',"
echo "    'user': 'edxapp',"
echo "    'password': 'password',"
echo "    'authSource': 'admin',"
echo "}"
