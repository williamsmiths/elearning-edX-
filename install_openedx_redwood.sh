#!/bin/bash

# DEPRECATED: Script cai dat native Open edX Redwood tren Ubuntu 22.04
# 
# CANH BAO: Script nay da KHONG CON HOAT DONG vi:
# - Repository openedx/configuration da bi deprecated va archived vao thang 5/2024
# - Phuong phap native installation khong con duoc support
# 
# PHUONG PHAP MOI KHUYÊN DUNG: Su dung Tutor
# Chay script moi: ./install_openedx_tutor.sh
#
# Hoac xem huong dan chi tiet tai: https://docs.tutor.edly.io/
#
# Script cu (khong hoat dong):

echo "Bat dau cai dat Open edX Redwood native..."
echo "CANH BAO: Phuong phap nay da deprecated. Vui long su dung Tutor thay the!"
echo "Chay: ./install_openedx_tutor.sh"

# Buoc 1: Cap nhat he thong
sudo apt-get update -y
sudo apt-get upgrade -y
echo "He thong da cap nhat. Neu can, reboot thu cong: sudo reboot va chay lai script sau."

# Buoc 2: Thiet lap bien moi truong
export OPENEDX_RELEASE=open-release/redwood.master
echo "OPENEDX_RELEASE da thiet lap: $OPENEDX_RELEASE"

# Buoc 3: Tao file config.yml
# Yeu cau input tu nguoi dung
read -p "Nhap hostname cho LMS (vi du: online.myeducation.org, khong co https://): " lms_base
read -p "Nhap hostname cho CMS (vi du: studio.online.myeducation.org, khong co https://): " cms_base

if [ -z "$lms_base" ] || [ -z "$cms_base" ]; then
    echo "Loi: Hostname khong duoc de trong. Thoat script."
    exit 1
fi

echo "EDXAPP_LMS_BASE: \"$lms_base\"" > config.yml
echo "EDXAPP_CMS_BASE: \"$cms_base\"" >> config.yml
echo "File config.yml da tao voi LMS: $lms_base va CMS: $cms_base"

# Buoc 4: Bootstrap Ansible
wget https://raw.githubusercontent.com/openedx/configuration/$OPENEDX_RELEASE/util/install/ansible-bootstrap.sh -O - | sudo -E bash
echo "Ansible bootstrap hoan thanh."

# Buoc 5: Tao mat khau ngau nhien
wget https://raw.githubusercontent.com/openedx/configuration/$OPENEDX_RELEASE/util/install/generate-passwords.sh -O - | bash
echo "Mat khau da tao va luu trong my-passwords.yml. Luu file nay an toan!"

# Buoc 6: Chay cai dat Open edX
wget https://raw.githubusercontent.com/openedx/configuration/$OPENEDX_RELEASE/util/install/native.sh -O - | bash
echo "Cai dat hoan thanh. Kiem tra LMS tai http://$lms_base va CMS tai http://$cms_base."
echo "Neu can, cau hinh them SSL, email, v.v. theo huong dan Open edX."

# Ket thuc
echo "Script ket thuc. Neu loi, kiem tra log va tham khao docs.openedx.org."