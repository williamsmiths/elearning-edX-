# REPO_ANALYSIS — elearning-edx

Ngày: 2025-08-19
Branch: `master`

Tổng quan ngắn
- Kiểu dự án: monorepo Django (Open edX-like) kết hợp front-end Webpack.
- Ngôn ngữ chính: Python (Django), JavaScript (Webpack, Node/npm), CSS/Sass, Jinja/Django templates.
- Điểm vào chính: `manage.py`, WSGI modules trong `lms/` và `cms/`.
- Mục tiêu repo: nền tảng e‑learning với hai ứng dụng chính là LMS (`lms/`) và CMS (`cms/`).

Cấu trúc chính và vai trò từng thư mục/tệp quan trọng
- `manage.py` — CLI entrypoint Django: chạy server, migrate, tests, v.v.
- `lms/` — mã nguồn ứng dụng LMS (runtime), chứa: `wsgi.py`, `celery.py`, `urls.py`, `djangoapps/`, `templates/`, `static/`.
  - `lms/wsgi.py`, `lms/wsgi_apache_lms.py` — entry WSGI cho deployment.
  - `lms/docker_lms_gunicorn.py` — cấu hình gunicorn cho container.
- `cms/` — mã nguồn CMS (studio), cấu trúc tương tự `lms/` với `docker_cms_gunicorn.py` và `urls.py`.
- `common/` — code dùng chung (utilities, middleware, template tags) giữa LMS và CMS.
- `xmodule/` — implementation của các blocks / components course (Capa, XModule). Đây là lõi xử lý nội dung bài học.
- `openedx/` — module mở rộng/patches dành cho Open edX (feature flags, core overrides).
- `requirements/` — danh sách dependencies: `pip.in`, `pip.txt`, constraints/ pinning. Rất quan trọng cho reproducible env.
- `webpack-config/`, `webpack.*.config.js` — cấu hình biên dịch front-end.
- `themes/` và `static/` — assets giao diện, chủ đề (multiple themes).
- `scripts/` — helper scripts cho build, test, maintenance.
- `docs/` — tài liệu dự án, Sphinx config (`conf.py`, `index.rst`).
- `tests`/`conftest.py`/`pytest.ini` — setup test suite pytest/unittest.
- Root config files: `setup.py`, `setup.cfg`, `tox.ini`, `mypy.ini`, `pylintrc*`, `Makefile`, `package.json`.

Điểm chú ý về chất lượng code & công cụ
- Static analysis: `mypy.ini`, `pylintrc` → có thiết lập type checking và linting.
- Test coverage / CI: có `codecov.yml` và `pytest.ini` → repo hướng tới coverage reports.
- Frontend build: multiple webpack configs (dev/prod/common/builtinblocks) → cần node/npm toolchain.
- Packaging: `setup.py` + `requirements/` → hỗ trợ cài đặt/packaging truyền thống Python.

Luồng thực thi chính (tổng quan)
1. `manage.py` đọc `DJANGO_SETTINGS_MODULE` → tải settings của LMS hoặc CMS.
2. Django app initialises: installed apps, middleware, URL conf.
3. WSGI (`lms/wsgi.py`) được dùng bởi server (gunicorn/uwsgi/Apache) để chạy ứng dụng.
4. Task background: `celery.py` cấu hình worker để xử lý jobs bất đồng bộ.
5. Frontend assets được build bằng Webpack và phục vụ qua `static/`.

Khu vực có khả năng rủi ro / cần kiểm tra kỹ
- Dependencies pinned: kiểm tra `requirements/pip.txt` và `constraints.txt` để tránh dependency confusion.
- Secrets / config: tìm mọi biến môi trường hard-coded và file .env sample; đảm bảo không có secret nằm trong repo.
- XModule và block rendering: thường là nguồn lỗi runtime khi nâng cấp Django/Python.
- Templates và static assets: có thể gây leakage XSS nếu không sanitize đúng.
- Migration DB: kiểm tra folder migrations cho consistency giữa apps.

Gợi ý ưu tiên cải tiến
- Thêm/hoàn thiện `CONTRIBUTING.md` và checklist để contributors biết các bước local dev và test.
- CI: nếu chưa có workflow GitHub Actions/other, thêm pipeline build → lint → tests → coverage.
- Tách config deploy: dùng env-specific settings rõ ràng và tránh secrets trong repo.
- Type hints: tăng coverage `mypy` dần dần, target critical modules (`xmodule`, `djangoapps`) trước.
- Modularize: tách các apps lớn (nếu repo còn monolitic) để giảm coupling.
- Update dependencies: audit vulnerabilities và cập nhật major frameworks theo kế hoạch.

Nơi nên kiểm tra chi tiết đầu tiên (để hiểu nhanh codebase)
- `manage.py` — để thấy cách khởi động app.
- `lms/urls.py` và `cms/urls.py` — để thấy routing chính.
- `lms/wsgi.py`, `cms/docker_*_gunicorn.py` — để hiểu deploy entrypoints.
- `xmodule/` — core course components.
- `requirements/` và `setup.py` — để biết env và dependency pinning.
- `docs/` — để đọc hướng dẫn dev/architecture có sẵn.

Nhiệm vụ có thể thực hiện ngay (gợi ý cho contributor)
- Chạy test suite và ghi lại failing tests (nếu môi trường sẵn có).
- Chạy linter (`pylint`, `mypy`) trên từng package chính.
- Tạo checklist migration dependencies và auditing security libs.
- Lập bản đồ các templates có user-supplied content để kiểm tra XSS.

Tài liệu tham khảo nội bộ (tệp đáng mở ngay)
- `README.rst` — overview dự án.
- `docs/index.rst` và `docs/conf.py` — docs cấu trúc.
- `requirements/pip.txt` và `constraints.txt` — dependency pins.
- `lms/`, `cms/`, `xmodule/` — 3 thư mục mã nguồn chính.

Kết luận ngắn
- Đây là một repo lớn, đa phần là một fork/custom của Open edX architecture: Django monolith + modular XModule + Webpack front-end.
- Để hiểu toàn diện cần thực hiện: đọc `manage.py` → khởi chạy local dev (env phù hợp) → chạy test suite → đọc `xmodule` và `djangoapps` chính.
- Bước ưu tiên: đảm bảo CI/lint/tests hoạt động reproducible, audit dependencies và secrets.

Nếu muốn, tôi có thể:
- tạo checklist phân tích sâu hơn từng file/đường dẫn cụ thể, hoặc
- sinh script liệt kê các tệp tham chiếu tới biến môi trường/secret.

Hướng dẫn chạy (Run steps)

Mục tiêu: các bước dưới đây giúp thiết lập môi trường dev, build assets, chạy server và chạy test.

1) Yêu cầu trước
- Python 3.8+ (khuyến nghị). pip, virtualenv/venv.
- Node.js (LTS) và npm hoặc yarn cho frontend build.
- PostgreSQL (hoặc database tương thích) cho production/dev nếu cần.
- Redis (cho caching / Celery broker) nếu ứng dụng sử dụng Celery.

2) Tạo và kích hoạt virtual environment (PowerShell)
- Tạo venv:

  python -m venv .venv

- Kích hoạt (PowerShell):

  .\.venv\Scripts\Activate.ps1

  Nếu gặp lỗi do ExecutionPolicy, chạy tạm thời trong session này:

  Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope Process -Force

3) Cài đặt dependencies Python
- Cài đặt các dependencies đã pin (sử dụng constraints nếu có):

  pip install -r requirements/pip.txt -c requirements/constraints.txt

  (Hoặc nếu repo dùng pip-tools: pip-sync hoặc pip-compile theo README của dự án.)

4) Cài đặt frontend dependencies & build assets
- Ở thư mục gốc dự án, cài đặt node packages:

  npm install

- Build production assets:

  npm run build

- Hoặc chạy chế độ dev/watch khi phát triển:

  npm run watch

(Tùy dự án, tên script trong `package.json` có thể khác — kiểm tra `package.json` để biết script chính xác.)

5) Cấu hình biến môi trường
- Tạo file `.env` hoặc export biến môi trường cho session PowerShell. Các biến quan trọng thường gồm:
  - DJANGO_SETTINGS_MODULE (ví dụ: `lms.envs.dev` cho LMS, `cms.envs.dev` cho CMS)
  - DATABASE_URL hoặc DB_* vars (host, user, password, name)
  - REDIS_URL (nếu cần)
  - SECRET_KEY
  - EMAIL settings (SMTP) nếu cần gửi email

Ví dụ PowerShell:

  $env:DJANGO_SETTINGS_MODULE = 'lms.envs.dev'
  $env:SECRET_KEY = 'dev-secret'

6) Thiết lập database & migrations
- Chạy migrate để tạo schema:

  python manage.py migrate

- Tạo superuser để truy cập admin:

  python manage.py createsuperuser

- Thu thập static files (production):

  python manage.py collectstatic --noinput

7) Chạy server dev
- Khởi chạy Django dev server (theo biến DJANGO_SETTINGS_MODULE đã đặt):

  python manage.py runserver 8000

- Nếu bạn muốn chạy CMS/LMS riêng, thay đổi `DJANGO_SETTINGS_MODULE` tương ứng trước khi chạy.

8) Chạy Celery worker (nếu cần)
- Ví dụ khởi chạy worker (thay `<celery_app>` bằng module celery thực tế, ví dụ `lms.celery`):

  celery -A <celery_app> worker -l info

- Trong môi trường dự án, có thể cần services hỗ trợ: Redis, RabbitMQ.

9) Chạy tests
- Chạy pytest (nếu sử dụng pytest):

  pytest

- Hoặc chạy test command Django:

  python manage.py test

10) Chạy production (ví dụ Gunicorn)
- Build assets, collectstatic và chạy gunicorn (trong container thường sử dụng các file `docker_*_gunicorn.py`):

  gunicorn -c path/to/docker_lms_gunicorn.py lms.wsgi:application

  (Kiểm tra các file `docker_*_gunicorn.py` trong `lms/` hoặc `cms/` để biết cấu hình chính xác.)

Ghi chú quan trọng
- Kiểm tra `requirements/` và `setup.py` để biết phiên bản Python và packages mong đợi.
- Kiểm tra `package.json` để biết scripts chính xác cho build/watch của frontend.
- Tên settings modules có thể khác trong repo — tìm các tệp `envs/` trong `lms/` và `cms/` để biết tên chính xác (ví dụ `lms.envs.dev`, `cms.envs.dev`).
- Trước khi chạy mọi thứ trong production, đảm bảo tất cả secrets được cấu hình an toàn (ví dụ dùng secret manager, biến môi trường, hoặc vault).

Nếu muốn, tôi có thể:
- Tạo file `scripts/dev_setup.ps1` (PowerShell) để tự động hóa các bước trên cho Windows dev, hoặc
- Tạo checklist `DEV_SETUP.md` chi tiết với lệnh chính xác dựa trên nội dung `package.json` và `requirements/` trong repo.

(End of analysis)




Dưới đây là hướng dẫn cài đặt đầy đủ và chạy dự án trên 3 môi trường phổ biến (WSL2/Linux, Docker, Windows native). Chỉ làm theo 1 trong 3 cách — khuyến nghị: WSL2 hoặc Docker để ít gặp vấn đề.

Chuẩn bị chung
Git clone repo về máy.
Kiểm tra file requirements và package.json để biết phiên bản chính xác.
Cần: Python 3.8+; Node.js LTS; npm hoặc yarn.
Môi trường đề xuất A — WSL2 (Ubuntu)
Mở WSL/Ubuntu, chuyển đến thư mục repo.
Tạo venv và kích hoạt:
python3 -m venv .venv
source .venv/bin/activate
Cài Python deps:
pip install -U pip wheel
pip install -r pip.txt -c constraints.txt
Cài Node deps & build:
npm ci
npm run build # hoặc npm run watch khi dev
Cấu hình biến môi trường (ví dụ .env hoặc export):
export DJANGO_SETTINGS_MODULE='lms.envs.dev'
export SECRET_KEY='dev-secret'
export DATABASE_URL='postgres://user:pass@localhost:5432/dbname'
export REDIS_URL='redis://localhost:6379/0'
Database (Postgres):
sudo apt install postgresql (hoặc dùng Docker)
tạo database + user, grant quyền
python manage.py migrate
python manage.py createsuperuser
python manage.py collectstatic --noinput # production
Chạy services cần thiết:
Redis: sudo apt install redis-server (hoặc docker run -p 6379:6379 redis)
Chạy dev server:
python manage.py runserver 0.0.0.0:8000
Chạy Celery (trong WSL):
celery -A lms.celery worker -l info
Chạy tests:
pytest
Production (Gunicorn):
gunicorn -c docker_lms_gunicorn.py lms.wsgi:application
Môi trường B — Docker / Docker Desktop (Windows or Linux) — recommended for parity
Cài Docker Desktop (bật WSL2 backend nếu Windows).
Nếu repo có docker-compose (nếu không, bạn có thể tạo), dùng:
docker-compose up --build
Nếu không có compose, chạy services: Postgres, Redis bằng Docker:
docker run -d --name pg -e POSTGRES_PASSWORD=pass -e POSTGRES_USER=user -e POSTGRES_DB=db -p 5432:5432 postgres
docker run -d --name redis -p 6379:6379 redis
Trong container/host, làm theo bước migrate/build tương tự (cài deps hoặc image đã build).
Start Gunicorn in container using provided docker_*_gunicorn.py configuration.
Lợi ích: tất cả service parity, dễ reproduce.
Môi trường C — Windows native (PowerShell) — có caveats
Tạo & activate venv (PowerShell):
python -m venv .venv
..venv\Scripts\Activate.ps1
nếu gặp execution policy: Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope Process -Force
Cài Python deps:
pip install -r pip.txt -c constraints.txt
Node:
npm ci
npm run build
DB: cài Postgres cho Windows hoặc dùng Docker.
Redis: không có bản chính thức tốt cho Windows → dùng Docker.
Gunicorn không chạy native Windows → dùng waitress:
pip install waitress
waitress-serve --port=8000 lms.wsgi:application
Celery trên Windows: dùng pool solo:
celery -A lms.celery worker -l info -P solo
Run dev:
$env:DJANGO_SETTINGS_MODULE='lms.envs.dev'
python manage.py migrate
python manage.py createsuperuser
python manage.py runserver 0.0.0.0:8000
Tests:
pytest
Biến môi trường mẫu (.env)
DJANGO_SETTINGS_MODULE=lms.envs.dev
SECRET_KEY=dev-secret
DATABASE_URL=postgres://user:pass@localhost:5432/edx
REDIS_URL=redis://localhost:6379/0
EMAIL_HOST=smtp.example.com (Lưu ý: không commit .env; dùng secret manager cho production.)
Kiểm tra & khắc phục nhanh
Lỗi cài đặt pip: nâng pip, wheel trước.
Lỗi Node: kiểm tra node version (nvm hoặc nvs để thay đổi).
Celery không kết nối Redis: kiểm tra REDIS_URL & service status.
Migrations fail: kiểm tra Alembic/migrations conflict; chạy makemigrations nếu cần (chỉ dev).
Port in use: thay cổng runserver hoặc kill process.
ExecutionPolicy trên PowerShell: dùng Set-ExecutionPolicy tạm thời.
Gợi ý tự động hóa (tùy chọn)
Muốn tôi tạo script PowerShell scripts/dev_setup.ps1 (Windows) hoặc scripts/dev_setup.sh (WSL) để tự động hóa: tạo venv, cài deps, export env, migrate, create superuser (tùy chọn), build frontend — tôi sẽ tạo nếu bạn yêu cầu.
Kết luận ngắn

Để ít rắc rối nhất trên Windows: dùng WSL2 hoặc Docker Desktop.
Nếu muốn, tôi tạo script cài đặt tự động cho lựa chọn bạn chọn (WSL2 / Docker / PowerShell).