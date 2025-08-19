# Database Setup with Docker Compose

This Docker Compose file sets up the required databases for Open edX development as specified in the main README.

## Services Included

- **MySQL 8.0** (Single server with both databases)
  - Port: 3306
  - Databases: `edxapp` and `student_module_history`
  - User: `edxapp_user`
  - Password: `edxapp_password`
  - Root password: `rootpassword`

- **MongoDB 7.0**
  - Port: 27017
  - Database: `edxapp`
  - Root user: `root`
  - Root password: `rootpassword`

- **Memcached 1.6**
  - Port: 11211
  - Memory: 256MB

## Usage

1. Start the databases:
```bash
docker-compose up -d
```

2. Check if services are running:
```bash
docker-compose ps
```

3. View logs if needed:
```bash
docker-compose logs mysql
docker-compose logs mongodb
```

4. Stop the databases:
```bash
docker-compose down
```

5. Stop and remove all data:
```bash
docker-compose down -v
```

## Database Configuration

After starting the services, update your Django settings to use these databases:

```python
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.mysql',
        'NAME': 'edxapp',
        'USER': 'edxapp_user',
        'PASSWORD': 'edxapp_password',
        'HOST': 'localhost',
        'PORT': '3306',
        'OPTIONS': {
            'init_command': "SET sql_mode='STRICT_TRANS_TABLES'",
        },
    },
    'student_module_history': {
        'ENGINE': 'django.db.backends.mysql',
        'NAME': 'student_module_history',
        'USER': 'edxapp_user',
        'PASSWORD': 'edxapp_password',
        'HOST': 'localhost',
        'PORT': '3306',  # Same MySQL server, different database
        'OPTIONS': {
            'init_command': "SET sql_mode='STRICT_TRANS_TABLES'",
        },
    }
}
```

## MongoDB Configuration

For MongoDB connection, use:
```python
CONTENTSTORE = {
    'ENGINE': 'xmodule.contentstore.mongo.MongoContentStore',
    'DOC_STORE_CONFIG': {
        'host': 'localhost',
        'port': 27017,
        'db': 'edxapp',
        'user': 'admin',
        'password': 'rootpassword',
        'authSource': 'admin',
    }
}
```

## Verification

You can verify the setup by connecting to the databases:

1. **MySQL**:
```bash
docker exec -it edx_mysql mysql -u edxapp_user -p
# Enter password: edxapp_password
# Then run: SHOW DATABASES;
```

2. **MongoDB**:
```bash
docker exec -it edx_mongodb mongosh --username admin --password rootpassword --authenticationDatabase admin
# Then run: show dbs
```

3. **Memcached**:
```bash
docker exec -it edx_memcached sh -c "echo 'stats' | nc localhost 11211"
```

## Next Steps

After the databases are running, continue with the setup steps from the main README:

1. Run migrations:
```bash
./manage.py lms migrate
./manage.py lms migrate --database=student_module_history
./manage.py cms migrate
```

2. Continue with the remaining setup steps as documented in the main README.rst file.

## Troubleshooting

- If you get connection errors, make sure the containers are running: `docker-compose ps`
- Check container logs: `docker-compose logs [service_name]`
- Ensure ports 3306, 27017, and 11211 are not used by other services on your host
