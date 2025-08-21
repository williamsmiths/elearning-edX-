// Script khởi tạo user MongoDB cho edX
db = db.getSiblingDB('edxapp');

// Tạo user edxapp với quyền readWrite
db.createUser({
  user: 'edxapp',
  pwd: 'password',
  roles: [
    { role: 'readWrite', db: 'edxapp' }
  ]
});

print('User edxapp đã được tạo thành công!');
