USE [quanlyquancafe];
GO
IF COL_LENGTH('dbo.taikhoan', 'MatKhau') IS NULL
    ALTER TABLE dbo.taikhoan ADD MatKhau nvarchar(256) NULL;
GO
-- Ghi nhận mật khẩu mẫu Admin nếu tài khoản vẫn dùng mật khẩu mẫu.
UPDATE dbo.taikhoan SET MatKhau=N'admin'
WHERE TenDangNhap='admin'
  AND LOWER(MatKhauHash)=LOWER(CONVERT(varchar(64),HASHBYTES('SHA2_256','admin'),2));

-- Đặt lại hai tài khoản mẫu còn dùng mã băm từ bộ dữ liệu ban đầu.
UPDATE dbo.taikhoan
SET MatKhau=N'Test@12345',
    MatKhauHash=LOWER(CONVERT(varchar(64),HASHBYTES('SHA2_256','Test@12345'),2))
WHERE TenDangNhap IN ('phache01','thungan01')
  AND MatKhauHash='e6c53572f4e3c92e7d7045b88251e39a51d95dc51e9e802a4339e38e6e58f001';
GO
