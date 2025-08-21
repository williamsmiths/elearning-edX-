# Hướng dẫn sử dụng Tutor cho Development

## Cài đặt ban đầu

### 1. Cài đặt Tutor (nếu chưa có):
```bash
./install_openedx_tutor.sh
```

### 2. Setup Development Environment:
```bash
./setup_tutor_dev.sh
```

## Sự khác biệt giữa Local và Dev mode

### Tutor Local (Production-like)
- **Mục đích**: Chạy Open edX như production
- **Port**: LMS trên port 80, CMS trên port 80
- **Code**: Code được build vào Docker image
- **Thay đổi code**: Cần rebuild image
- **Command**: `tutor local ...`

### Tutor Dev (Development)
- **Mục đích**: Phát triển và debug code
- **Port**: LMS trên port 8000, CMS trên port 8001  
- **Code**: Code được mount từ host
- **Thay đổi code**: Tự động reload
- **Command**: `tutor dev ...`

## Workflow Development với Tutor

### 1. Khởi động Development Environment
```bash
cd ~/openedx-dev
tutor dev start
```

### 2. Tạo superuser
```bash
tutor dev createuser --staff --superuser admin admin@example.com
```

### 3. Import demo course
```bash
tutor dev importdemocourse
```

### 4. Truy cập
- **LMS**: http://local.edly.io:8000
- **CMS**: http://studio.local.edly.io:8001

### 5. Development thường dùng

#### Xem logs real-time:
```bash
tutor dev logs --follow lms
tutor dev logs --follow cms
```

#### Vào shell để debug:
```bash
tutor dev exec lms bash
tutor dev exec cms bash
```

#### Chạy Django commands:
```bash
tutor dev exec lms python manage.py lms shell
tutor dev exec cms python manage.py cms shell
```

#### Chạy tests:
```bash
tutor dev exec lms python -m pytest
```

### 6. Code Development

#### Thay đổi Python code:
- Edit file trong `~/openedx-dev/edx-platform/`
- Server tự động reload
- Không cần restart

#### Thay đổi static files (CSS, JS):
```bash
tutor dev exec lms python manage.py lms collectstatic --noinput
tutor dev exec cms python manage.py cms collectstatic --noinput
```

#### Thay đổi requirements:
```bash
tutor dev exec lms pip install package-name
# Hoặc rebuild image nếu cần persistent
```

### 7. Database Operations

#### Migrate database:
```bash
tutor dev exec lms python manage.py lms migrate
tutor dev exec cms python manage.py cms migrate
```

#### Tạo migrations:
```bash
tutor dev exec lms python manage.py lms makemigrations
```

#### Database shell:
```bash
tutor dev exec lms python manage.py lms dbshell
```

## Debugging và Performance

### 1. Enable Django Debug Mode:
```bash
tutor config save --set LMS_HOST=local.edly.io:8000 --set CMS_HOST=studio.local.edly.io:8001
```

### 2. Xem performance với Django Debug Toolbar:
- Cài đặt: `tutor dev exec lms pip install django-debug-toolbar`
- Configure trong settings

### 3. Memory và CPU monitoring:
```bash
docker stats
```

## Plugin Development

### 1. Tạo Tutor plugin:
```bash
tutor plugins init my-plugin
```

### 2. Enable plugin:
```bash
tutor plugins enable my-plugin
```

### 3. Build với plugin:
```bash
tutor dev launch
```

## Tips và Best Practices

### 1. Sử dụng multiple terminals:
- Terminal 1: `tutor dev logs --follow lms`
- Terminal 2: Development commands
- Terminal 3: `tutor dev exec lms bash`

### 2. Quick restart khi cần:
```bash
tutor dev restart lms
tutor dev restart cms
```

### 3. Clean restart:
```bash
tutor dev stop
tutor dev start
```

### 4. Backup development data:
```bash
tutor dev exec mysql mysqldump --all-databases > backup.sql
```

## Troubleshooting

### 1. Port conflicts:
```bash
sudo netstat -tulpn | grep :8000
sudo netstat -tulpn | grep :8001
```

### 2. Reset development environment:
```bash
tutor dev stop
tutor dev start --reset
```

### 3. Rebuild từ đầu:
```bash
tutor dev stop
tutor images build
tutor dev launch
```

### 4. Xem container status:
```bash
docker ps
docker logs tutor_dev_lms_1
```

## Tài liệu tham khảo

- [Tutor Development Guide](https://docs.tutor.edly.io/dev.html)
- [Open edX Developer Guide](https://docs.openedx.org/en/latest/developers/)
- [edx-platform Repository](https://github.com/openedx/edx-platform)
- [Django Documentation](https://docs.djangoproject.com/)
