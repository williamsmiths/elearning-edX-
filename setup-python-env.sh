#!/bin/bash

# =============================================================================
# Open edX Platform - Python Environment Setup Script
# =============================================================================
# Script này sẽ tự động thiết lập Python virtual environment và cài đặt dependencies
# cho dự án Open edX Platform
# =============================================================================

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check if running from correct directory
if [ ! -f "manage.py" ]; then
    print_error "Vui lòng chạy script này từ thư mục gốc của dự án edX (có file manage.py)"
    exit 1
fi

print_info "Bắt đầu thiết lập Python environment cho Open edX Platform..."

# Check Python versions (prioritize 3.11, fallback to 3.12, 3.10)
PYTHON_CMD=""
print_info "Kiểm tra Python version..."

if command_exists python3.11; then
    PYTHON_CMD="python3.11"
    PYTHON_VERSION=$(python3.11 --version)
    print_success "Tìm thấy $PYTHON_VERSION"
elif command_exists python3.12; then
    PYTHON_CMD="python3.12"
    PYTHON_VERSION=$(python3.12 --version)
    print_warning "Python 3.11 không tìm thấy, sử dụng $PYTHON_VERSION"
    print_warning "edX khuyến nghị Python 3.11, nhưng 3.12 cũng có thể hoạt động"
elif command_exists python3.10; then
    PYTHON_CMD="python3.10"
    PYTHON_VERSION=$(python3.10 --version)
    print_warning "Sử dụng $PYTHON_VERSION (có thể có vấn đề compatibility)"
else
    print_error "Không tìm thấy Python 3.10+ nào!"
    print_info "Đang cài đặt Python 3.11..."
    
    # Try to install Python 3.11 with better error handling
    if sudo apt update && sudo apt install -y python3.11 python3.11-venv python3.11-dev; then
        PYTHON_CMD="python3.11"
        print_success "Python 3.11 đã được cài đặt thành công"
    else
        print_error "Không thể cài đặt Python 3.11. Thử cài thủ công:"
        print_error "sudo apt install software-properties-common"
        print_error "sudo add-apt-repository ppa:deadsnakes/ppa"
        print_error "sudo apt update && sudo apt install python3.11 python3.11-venv python3.11-dev"
        exit 1
    fi
fi

# Install system dependencies for Python packages
print_info "Cài đặt system dependencies..."
sudo apt install -y \
    python3-dev \
    default-libmysqlclient-dev \
    build-essential \
    pkg-config \
    libssl-dev \
    libffi-dev \
    libxml2-dev \
    libxslt1-dev \
    libjpeg-dev \
    libpng-dev \
    gettext

# Remove existing virtual environment if exists
if [ -d "edx-venv" ]; then
    print_warning "Virtual environment edx-venv đã tồn tại. Xóa và tạo lại..."
    rm -rf edx-venv
fi

# Create virtual environment
print_info "Tạo Python virtual environment với $PYTHON_CMD..."
$PYTHON_CMD -m venv edx-venv

# Activate virtual environment
print_info "Kích hoạt virtual environment..."
source edx-venv/bin/activate

# Upgrade pip, setuptools, and wheel
print_info "Nâng cấp pip, setuptools, và wheel..."
pip install --upgrade pip setuptools wheel

# Check if requirements file exists
if [ ! -f "requirements/edx/development.txt" ]; then
    print_error "File requirements/edx/development.txt không tồn tại!"
    exit 1
fi

# Install dependencies
print_info "Cài đặt Python dependencies từ requirements/edx/development.txt..."
print_warning "Quá trình này có thể mất 10-20 phút..."

# Install in chunks to handle large requirements file
pip install --timeout 1000 -r requirements/edx/development.txt

print_success "Hoàn thành cài đặt Python dependencies!"

# Verify installation
print_info "Kiểm tra một số packages quan trọng..."
python -c "import django; print(f'Django version: {django.__version__}')"
python -c "import lms; print('LMS module imported successfully')"
python -c "import cms; print('CMS module imported successfully')"

print_success "Python environment đã được thiết lập thành công!"
print_info "Để kích hoạt environment trong tương lai, chạy:"
print_info "  source edx-venv/bin/activate"

print_info "Bước tiếp theo:"
print_info "1. Cài đặt Node.js dependencies: npm clean-install --dev"
print_info "2. Chạy database migrations: ./manage.py lms migrate"
print_info "3. Build static assets: npm run build-dev"
print_info "4. Chạy servers: ./manage.py lms runserver 18000"

print_success "Setup hoàn tất! 🚀"
