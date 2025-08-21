#!/bin/bash

# Script setup Tutor cho Development
# Dành cho developers muốn phát triển code cho Open edX

echo "Thiết lập Tutor cho Development..."

# Kiểm tra xem Tutor đã được cài đặt chưa
if ! command -v tutor &> /dev/null; then
    echo "Tutor chưa được cài đặt. Chạy script cài đặt trước:"
    echo "./install_openedx_tutor.sh"
    exit 1
fi

echo "Tutor đã cài đặt. Phiên bản:"
tutor --version

# Tạo thư mục development
echo "Tạo thư mục development..."
mkdir -p ~/openedx-dev
cd ~/openedx-dev

# Khởi tạo cấu hình development
echo "Khởi tạo cấu hình development..."

# Yêu cầu input từ người dùng
read -p "Nhập hostname cho LMS dev (mặc định: local.edly.io): " lms_host
read -p "Nhập hostname cho CMS dev (mặc định: studio.local.edly.io): " cms_host

# Sử dụng giá trị mặc định nếu không nhập
lms_host=${lms_host:-"local.edly.io"}
cms_host=${cms_host:-"studio.local.edly.io"}

# Cấu hình Tutor cho development
tutor config save --set LMS_HOST="$lms_host" --set CMS_HOST="$cms_host"

# Clone edx-platform repository cho development
echo "Clone edx-platform repository..."
if [ ! -d "edx-platform" ]; then
    git clone https://github.com/openedx/edx-platform.git
    echo "Repository edx-platform đã được clone."
else
    echo "Repository edx-platform đã tồn tại."
fi

# Mount edx-platform cho development
echo "Mount edx-platform cho development..."
tutor mounts add ./edx-platform

# Build development environment
echo "Build development environment (có thể mất nhiều thời gian)..."
tutor dev launch

echo ""
echo "========================================="
echo "Thiết lập Development hoàn tất!"
echo "========================================="
echo "LMS Development: http://$lms_host:8000"
echo "CMS Development: http://$cms_host:8001"
echo ""
echo "Các lệnh Development hữu ích:"
echo ""
echo "=== Quản lý services ==="
echo "tutor dev start          # Khởi động development environment"
echo "tutor dev stop           # Dừng development environment"
echo "tutor dev restart lms    # Restart LMS service"
echo "tutor dev restart cms    # Restart CMS service"
echo ""
echo "=== Development workflow ==="
echo "tutor dev exec lms bash  # Vào shell của LMS container"
echo "tutor dev exec cms bash  # Vào shell của CMS container"
echo "tutor dev logs lms       # Xem logs của LMS"
echo "tutor dev logs cms       # Xem logs của CMS"
echo ""
echo "=== Database và User ==="
echo "tutor dev createuser --staff --superuser admin admin@example.com"
echo "tutor dev importdemocourse  # Import demo course"
echo ""
echo "=== Code development ==="
echo "- Code thay đổi trong ./edx-platform sẽ tự động reload"
echo "- Không cần rebuild container cho code changes"
echo "- Static files: tutor dev exec lms python manage.py lms collectstatic"
echo ""
echo "Thư mục development: ~/openedx-dev"
echo "Tài liệu: https://docs.tutor.edly.io/dev.html"
echo "========================================="
