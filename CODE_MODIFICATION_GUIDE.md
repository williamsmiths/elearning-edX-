# Hướng dẫn thay đổi code Open edX

## 1. Cấu trúc thư mục code chính

### Thư mục hiện tại `/home/kongubuntu/Desktop/elearning-edX-/`:
```
lms/                    # Learning Management System
├── djangoapps/         # LMS Django apps
├── envs/              # Environment settings
├── static/            # Static files (CSS, JS)
├── templates/         # HTML templates
├── urls.py            # URL routing
└── wsgi.py            # WSGI config

cms/                    # Content Management System (Studio)  
├── djangoapps/         # CMS Django apps
├── envs/              # Environment settings
├── static/            # Static files
├── templates/         # HTML templates
└── urls.py            # URL routing

common/                 # Code dùng chung
├── djangoapps/         # Shared Django apps
├── static/            # Shared static files
└── templates/         # Shared templates

openedx/               # Core platform
├── core/              # Core functionality
├── features/          # Feature toggles
└── testing/           # Testing utilities

xmodule/               # XBlock modules và course content
```

## 2. Các thư mục quan trọng để thay đổi code

### A. LMS (Learning Management System)
**Đường dẫn**: `lms/djangoapps/`

**Các app chính**:
```bash
# Navigation và course discovery
lms/djangoapps/courseware/        # Course content display
lms/djangoapps/course_home/        # Course home page
lms/djangoapps/learner_dashboard/  # Student dashboard

# User management
lms/djangoapps/student/            # User registration, login
lms/djangoapps/profile/            # User profiles
lms/djangoapps/account/            # Account management

# Learning features
lms/djangoapps/discussion/         # Forum discussions
lms/djangoapps/grades/             # Grading system
lms/djangoapps/certificates/       # Certificates
lms/djangoapps/instructor/         # Instructor tools
```

### B. CMS (Content Management System - Studio)
**Đường dẫn**: `cms/djangoapps/`

**Các app chính**:
```bash
cms/djangoapps/contentstore/       # Course content editing
cms/djangoapps/course_creators/    # Course creation
cms/djangoapps/maintenance/        # Maintenance tools
cms/djangoapps/models/             # CMS models
```

### C. Common (Shared code)
**Đường dẫn**: `common/djangoapps/`

**Các app chính**:
```bash
common/djangoapps/student/         # Shared user models
common/djangoapps/course_modes/    # Course pricing modes
common/djangoapps/util/            # Utilities
common/djangoapps/xblock_django/   # XBlock integration
```

## 3. Ví dụ thay đổi code thường gặp

### A. Thay đổi giao diện (Templates)

#### Thay đổi LMS homepage:
```bash
# File: lms/templates/index.html
# Hoặc: lms/templates/courseware/course_about.html
```

#### Thay đổi CMS interface:
```bash
# File: cms/templates/base.html
# Hoặc: cms/templates/container.html
```

### B. Thay đổi CSS/JavaScript

#### LMS styles:
```bash
lms/static/sass/         # SASS files
lms/static/css/          # Compiled CSS
lms/static/js/           # JavaScript files
```

#### CMS styles:
```bash
cms/static/sass/         # SASS files  
cms/static/css/          # Compiled CSS
cms/static/js/           # JavaScript files
```

### C. Thay đổi business logic (Python)

#### Thay đổi course logic:
```bash
# File: lms/djangoapps/courseware/views.py
# File: lms/djangoapps/courseware/models.py
```

#### Thay đổi user management:
```bash
# File: lms/djangoapps/student/views.py
# File: common/djangoapps/student/models.py
```

## 4. Workflow thay đổi code

### Với setup hiện tại (Native):
```bash
# 1. Activate virtual environment
source edx-venv/bin/activate

# 2. Thay đổi code trong thư mục hiện tại

# 3. Restart services
sudo supervisorctl restart lms
sudo supervisorctl restart cms

# 4. Collect static files nếu thay đổi CSS/JS
python manage.py lms collectstatic --noinput
python manage.py cms collectstatic --noinput

# 5. Compile SASS nếu thay đổi styles
python manage.py lms compile_sass
python manage.py cms compile_sass
```

### Với Tutor Development (Khuyến khích):
```bash
# 1. Thay đổi code trong ~/openedx-dev/edx-platform/

# 2. Code tự động reload (hot reload)

# 3. Nếu thay đổi static files:
tutor dev exec lms python manage.py lms collectstatic
tutor dev exec cms python manage.py cms collectstatic

# 4. Restart nếu cần:
tutor dev restart lms
tutor dev restart cms
```

## 5. Ví dụ cụ thể: Thay đổi homepage

### File cần sửa: `lms/templates/index.html`

```html
<!-- Tìm section hero -->
<section class="home-hero">
    <div class="hero-content">
        <h1>{% trans "Welcome to Your Learning Platform" %}</h1>
        <p>{% trans "Start your learning journey today" %}</p>
    </div>
</section>
```

### Thay đổi thành:
```html
<section class="home-hero">
    <div class="hero-content">
        <h1>Chào mừng đến với nền tảng học tập</h1>
        <p>Bắt đầu hành trình học tập của bạn ngay hôm nay</p>
    </div>
</section>
```

## 6. Debug và testing

### Xem logs:
```bash
# Native setup
tail -f logs/edx.log

# Tutor setup  
tutor dev logs --follow lms
```

### Django shell:
```bash
# Native setup
python manage.py lms shell

# Tutor setup
tutor dev exec lms python manage.py lms shell
```

### Run tests:
```bash
# Native setup
python -m pytest lms/djangoapps/courseware/tests/

# Tutor setup
tutor dev exec lms python -m pytest lms/djangoapps/courseware/tests/
```

## 7. Best practices

1. **Luôn backup** trước khi thay đổi
2. **Test thay đổi** trên development environment trước
3. **Theo dõi logs** khi thay đổi
4. **Sử dụng version control** (git) để track changes
5. **Đọc documentation** của Open edX trước khi sửa core functionality

## 8. Tài liệu tham khảo

- [Open edX Developer Guide](https://docs.openedx.org/en/latest/developers/)
- [Django Documentation](https://docs.djangoproject.com/)
- [XBlock SDK](https://xblock.readthedocs.io/)
- [Open edX Architecture](https://docs.openedx.org/en/latest/developers/references/architecture.html)
