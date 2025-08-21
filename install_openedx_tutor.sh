#!/bin/bash

# Script cai dat Open edX bang Tutor (phuong phap moi khuyên dung)
# Chay voi quyen sudo hoac user co sudo
# Can ket noi internet va server moi sach

echo "Bat dau cai dat Open edX bang Tutor..."

# Buoc 1: Cap nhat he thong
echo "Cap nhat he thong..."
sudo apt-get update -y
sudo apt-get upgrade -y
echo "He thong da cap nhat."

# Buoc 2: Cai dat cac dependency can thiet
echo "Cai dat Python, pip, va cac dependency..."
sudo apt-get install -y python3 python3-pip python3-venv curl

# Buoc 3: Cai dat Docker (neu chua co)
if ! command -v docker &> /dev/null; then
    echo "Cai dat Docker..."
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    sudo usermod -aG docker $USER
    rm get-docker.sh
    echo "Docker da cai dat. Neu ban khong muon dung sudo voi docker, hay logout va login lai."
else
    echo "Docker da co san."
fi

# Buoc 4: Cai dat Docker Compose (neu chua co)
if ! command -v docker-compose &> /dev/null; then
    echo "Cai dat Docker Compose..."
    sudo apt-get install -y docker-compose-plugin
else
    echo "Docker Compose da co san."
fi

# Buoc 5: Cai dat pipx (de quan ly virtual environment cho Tutor)
echo "Cai dat pipx..."
sudo apt-get install -y pipx
pipx ensurepath

# Them pipx PATH vao bashrc neu chua co
if ! grep -q 'pipx' ~/.bashrc; then
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
fi
export PATH="$HOME/.local/bin:$PATH"

# Buoc 6: Cai dat Tutor bang pipx
echo "Cai dat Tutor bang pipx..."
pipx install "tutor[full]"

# Kiem tra cai dat Tutor
export PATH="$HOME/.local/bin:$PATH"
if command -v tutor &> /dev/null; then
    echo "Tutor da cai dat thanh cong. Phien ban:"
    tutor --version
else
    echo "Loi: Khong the cai dat Tutor. Kiem tra lai."
    echo "Thu cai dat bang cach khac..."
    
    # Fallback: Thu cai dat bang virtual environment
    echo "Tao virtual environment cho Tutor..."
    python3 -m venv ~/tutor-venv
    source ~/tutor-venv/bin/activate
    pip install "tutor[full]"
    
    # Tao symlink de co the dung tutor tu bat ki dau
    sudo ln -sf ~/tutor-venv/bin/tutor /usr/local/bin/tutor
    
    if command -v tutor &> /dev/null; then
        echo "Tutor da cai dat thanh cong bang virtual environment."
        tutor --version
    else
        echo "Khong the cai dat Tutor. Vui long cai dat thu cong."
        exit 1
    fi
fi

# Buoc 6: Khoi tao Tutor config
echo "Khoi tao cau hinh Tutor..."

# Yeu cau input tu nguoi dung
read -p "Nhap hostname cho LMS (vi du: online.myeducation.org, khong co https://): " lms_host
read -p "Nhap hostname cho CMS (vi du: studio.online.myeducation.org, khong co https://): " cms_host

if [ -z "$lms_host" ] || [ -z "$cms_host" ]; then
    echo "Loi: Hostname khong duoc de trong. Su dung gia tri mac dinh."
    lms_host="local.edly.io"
    cms_host="studio.local.edly.io"
fi

# Thiet lap config voi interactive mode
tutor config save --set LMS_HOST="$lms_host" --set CMS_HOST="$cms_host"

echo "Cau hinh Tutor da hoan thanh voi LMS: $lms_host va CMS: $cms_host"

# Buoc 7: Khoi dong Open edX
echo "Khoi dong Open edX..."
echo "Dang build Docker images (co the mat vai phut)..."
tutor local launch

echo ""
echo "========================================="
echo "Cai dat hoan thanh!"
echo "========================================="
echo "LMS: http://$lms_host"
echo "CMS: http://$cms_host"
echo ""
echo "Cac lenh Tutor huu ich:"
echo "- tutor local start: Khoi dong lai cac service"
echo "- tutor local stop: Dung cac service"
echo "- tutor local logs: Xem logs"
echo "- tutor local exec lms bash: Vao shell cua LMS"
echo "- tutor local createuser --staff --superuser admin admin@example.com: Tao admin user"
echo ""
echo "Xem them tai: https://docs.tutor.edly.io/"
echo "========================================="
