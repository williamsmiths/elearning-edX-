# Open edX Installation Scripts

## Vấn đề với script cũ

Script `install_openedx_redwood.sh` gặp lỗi 404 vì:

1. **Repository deprecated**: Kho `openedx/configuration` đã bị deprecated và archived vào tháng 5/2024
2. **Phương pháp cũ không còn được hỗ trợ**: Native installation không còn được khuyến khích

## Giải pháp mới: Sử dụng Tutor

### Cài đặt nhanh với script mới

```bash
./install_openedx_tutor.sh
```

### Cài đặt thủ công với Tutor

1. **Cài đặt Docker**:
```bash
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker $USER
```

2. **Cài đặt Tutor**:
```bash
pip3 install --user "tutor[full]"
export PATH="$HOME/.local/bin:$PATH"
```

3. **Cấu hình và khởi chạy**:
```bash
tutor local launch
```

## Tài liệu tham khảo

- [Tutor Documentation](https://docs.tutor.edly.io/)
- [Open edX Documentation](https://docs.openedx.org/)
- [Tutor Installation Guide](https://docs.tutor.edly.io/install.html)

## Lưu ý quan trọng

- Tutor là phương pháp cài đặt Open edX được khuyến khích chính thức
- Tutor sử dụng Docker và dễ quản lý hơn
- Hỗ trợ cả development và production environments
- Dễ backup, restore và migrate
