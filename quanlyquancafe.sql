USE [master];
GO
IF DB_ID(N'quanlyquancafe') IS NULL
    EXEC(N'CREATE DATABASE [quanlyquancafe]');
GO
USE [quanlyquancafe]
GO

-- =============================================
-- PHẦN 1 TẠO CÁC BẢNG (DDL)
-- =============================================

--  Object Table [dbo].[chucvu] 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[chucvu](
[MaChucVu] [int] IDENTITY(1,1) NOT NULL,
[TenChucVu] [nvarchar](50) NOT NULL,
[MoTa] [nvarchar](255) NULL,
PRIMARY KEY CLUSTERED
(
[MaChucVu] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

--  Object Table [dbo].[nhanvien] 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[nhanvien](
[MaNhanVien] [varchar](20) NOT NULL,
[HoTen] [nvarchar](100) NOT NULL,
[NgaySinh] [date] NULL,
[GioiTinh] [nvarchar](10) NULL,
[SoDienThoai] [varchar](15) NOT NULL,
[DiaChi] [nvarchar](255) NULL,
[Email] [varchar](100) NULL,
[NgayVaoLam] [date] NOT NULL,
[TrangThaiLamViec] [nvarchar](30) NOT NULL,
[MaChucVu] [int] NOT NULL,
PRIMARY KEY CLUSTERED
(
[MaNhanVien] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED
(
[SoDienThoai] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO

--  Object Table [dbo].[taikhoan] 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[taikhoan](
[TenDangNhap] [varchar](50) NOT NULL,
[MatKhauHash] [varchar](255) NOT NULL,
[MatKhau] [nvarchar](256) NULL,
[VaiTro] [varchar](20) NOT NULL,
[TrangThaiKhoa] [tinyint] NOT NULL,
[NgayTao] [datetime] NOT NULL,
[MaNhanVien] [varchar](20) NOT NULL,
PRIMARY KEY CLUSTERED
(
[TenDangNhap] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED
(
[MaNhanVien] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO

--  Object Table [dbo].[khuvuc] 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[khuvuc](
[MaKhuVuc] [int] IDENTITY(1,1) NOT NULL,
[TenKhuVuc] [nvarchar](50) NOT NULL,
[GhiChu] [nvarchar](255) NULL,
PRIMARY KEY CLUSTERED
(
[MaKhuVuc] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

--  Object Table [dbo].[banan] 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[banan](
[MaBan] [int] IDENTITY(1,1) NOT NULL,
[TenBan] [nvarchar](50) NOT NULL,
[SoGhe] [int] NOT NULL,
[TrangThai] [varchar](30) NOT NULL,
[MaKhuVuc] [int] NOT NULL,
PRIMARY KEY CLUSTERED
(
[MaBan] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO

--  Object Table [dbo].[danhmuc] 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[danhmuc](
[MaDanhMuc] [int] IDENTITY(1,1) NOT NULL,
[TenDanhMuc] [nvarchar](100) NOT NULL,
[MoTa] [nvarchar](255) NULL,
PRIMARY KEY CLUSTERED
(
[MaDanhMuc] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

--  Object Table [dbo].[douong] 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[douong](
[MaDoUong] [varchar](20) NOT NULL,
[TenDoUong] [nvarchar](100) NOT NULL,
[GiaBanHienTai] [decimal](18, 2) NOT NULL,
[HinhAnh] [varchar](255) NULL,
[MoTa] [nvarchar](max) NULL,
[TrangThaiKinhDoanh] [varchar](30) NOT NULL,
[MaDanhMuc] [int] NOT NULL,
PRIMARY KEY CLUSTERED
(
[MaDoUong] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO

--  Object Table [dbo].[khachhang] 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[khachhang](
[MaKhachHang] [int] IDENTITY(1,1) NOT NULL,
[TenKhachHang] [nvarchar](100) NOT NULL,
[SoDienThoai] [varchar](15) NOT NULL,
[NgayTao] [datetime] NOT NULL,
[HangThanhVien] [nvarchar](50) NULL,
[GhiChu] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED
(
[MaKhachHang] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO

--  Object Table [dbo].[datban] 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[datban](
[MaDatBan] [int] IDENTITY(1,1) NOT NULL,
[SoLuongKhach] [int] NOT NULL,
[NgayGioDat] [datetime] NOT NULL,
[NgayGioDenDuKien] [datetime] NOT NULL,
[GhiChu] [nvarchar](255) NULL,
[TrangThaiDat] [varchar](30) NOT NULL,
[MaKhachHang] [int] NOT NULL,
[MaBan] [int] NOT NULL,
[MaNhanVienTiepNhan] [varchar](20) NOT NULL,
PRIMARY KEY CLUSTERED
(
[MaDatBan] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO

--  Object Table [dbo].[donhang] 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[donhang](
[MaDonHang] [varchar](30) NOT NULL,
[ThoiGianTao] [datetime] NOT NULL,
[LoaiDon] [varchar](20) NOT NULL,
[TrangThaiDon] [varchar](30) NOT NULL,
[MaBan] [int] NULL,
[MaNhanVienTao] [varchar](20) NOT NULL,
PRIMARY KEY CLUSTERED
(
[MaDonHang] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO

--  Object Table [dbo].[chitietdonhang] 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[chitietdonhang](
[MaDonHang] [varchar](30) NOT NULL,
[MaDoUong] [varchar](20) NOT NULL,
[SoLuong] [int] NOT NULL,
[DonGiaTaiThoiDiemGoi] [decimal](18, 2) NOT NULL,
[GhiChuMon] [nvarchar](255) NULL,
[ThanhTien] [decimal](18, 2) NOT NULL,
PRIMARY KEY CLUSTERED
(
[MaDonHang] ASC,
[MaDoUong] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO

--  Object Table [dbo].[hoadon] 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[hoadon](
[MaHoaDon] [varchar](30) NOT NULL,
[NgayGioThanhToan] [datetime] NOT NULL,
[TongTienMon] [decimal](18, 2) NOT NULL,
[GiamGia] [decimal](18, 2) NOT NULL,
[TienPhaiTra] [decimal](18, 2) NOT NULL,
[PhuongThucThanhToan] [varchar](30) NOT NULL,
[MaDonHang] [varchar](30) NOT NULL,
[MaNhanVienThuNgan] [varchar](20) NOT NULL,
PRIMARY KEY CLUSTERED
(
[MaHoaDon] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED
(
[MaDonHang] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO

-- Thiết lập giá trị mặc định (DEFAULT constraints)
ALTER TABLE [dbo].[banan] ADD DEFAULT ((4)) FOR [SoGhe]
GO
ALTER TABLE [dbo].[banan] ADD DEFAULT ('Trong') FOR [TrangThai]
GO
ALTER TABLE [dbo].[datban] ADD DEFAULT (getdate()) FOR [NgayGioDat]
GO
ALTER TABLE [dbo].[datban] ADD DEFAULT ('ChoNhanBan') FOR [TrangThaiDat]
GO
ALTER TABLE [dbo].[donhang] ADD DEFAULT (getdate()) FOR [ThoiGianTao]
GO
ALTER TABLE [dbo].[donhang] ADD DEFAULT ('TaiCho') FOR [LoaiDon]
GO
ALTER TABLE [dbo].[donhang] ADD DEFAULT ('DangPhucVu') FOR [TrangThaiDon]
GO
ALTER TABLE [dbo].[douong] ADD DEFAULT ('ConHang') FOR [TrangThaiKinhDoanh]
GO
ALTER TABLE [dbo].[hoadon] ADD DEFAULT (getdate()) FOR [NgayGioThanhToan]
GO
ALTER TABLE [dbo].[hoadon] ADD DEFAULT ((0.00)) FOR [GiamGia]
GO
ALTER TABLE [dbo].[khachhang] ADD DEFAULT (getdate()) FOR [NgayTao]
GO
ALTER TABLE [dbo].[khachhang] ADD DEFAULT (N'Moi') FOR [HangThanhVien]
GO
ALTER TABLE [dbo].[nhanvien] ADD DEFAULT ('DangLamViec') FOR [TrangThaiLamViec]
GO
ALTER TABLE [dbo].[taikhoan] ADD DEFAULT ((0)) FOR [TrangThaiKhoa]
GO
ALTER TABLE [dbo].[taikhoan] ADD DEFAULT (getdate()) FOR [NgayTao]
GO

-- Thiết lập khóa ngoại (FOREIGN KEY constraints)
ALTER TABLE [dbo].[banan] WITH CHECK ADD CONSTRAINT [FK_BanAn_KhuVuc] FOREIGN KEY([MaKhuVuc])
REFERENCES [dbo].[khuvuc] ([MaKhuVuc])
GO
ALTER TABLE [dbo].[banan] CHECK CONSTRAINT [FK_BanAn_KhuVuc]
GO
ALTER TABLE [dbo].[chitietdonhang] WITH CHECK ADD CONSTRAINT [FK_CTDH_DonHang] FOREIGN KEY([MaDonHang])
REFERENCES [dbo].[donhang] ([MaDonHang])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[chitietdonhang] CHECK CONSTRAINT [FK_CTDH_DonHang]
GO
ALTER TABLE [dbo].[chitietdonhang] WITH CHECK ADD CONSTRAINT [FK_CTDH_DoUong] FOREIGN KEY([MaDoUong])
REFERENCES [dbo].[douong] ([MaDoUong])
GO
ALTER TABLE [dbo].[chitietdonhang] CHECK CONSTRAINT [FK_CTDH_DoUong]
GO
ALTER TABLE [dbo].[datban] WITH CHECK ADD CONSTRAINT [FK_DatBan_BanAn] FOREIGN KEY([MaBan])
REFERENCES [dbo].[banan] ([MaBan])
GO
ALTER TABLE [dbo].[datban] CHECK CONSTRAINT [FK_DatBan_BanAn]
GO
ALTER TABLE [dbo].[datban] WITH CHECK ADD CONSTRAINT [FK_DatBan_KhachHang] FOREIGN KEY([MaKhachHang])
REFERENCES [dbo].[khachhang] ([MaKhachHang])
GO
ALTER TABLE [dbo].[datban] CHECK CONSTRAINT [FK_DatBan_KhachHang]
GO
ALTER TABLE [dbo].[datban] WITH CHECK ADD CONSTRAINT [FK_DatBan_NhanVien] FOREIGN KEY([MaNhanVienTiepNhan])
REFERENCES [dbo].[nhanvien] ([MaNhanVien])
GO
ALTER TABLE [dbo].[datban] CHECK CONSTRAINT [FK_DatBan_NhanVien]
GO
ALTER TABLE [dbo].[donhang] WITH CHECK ADD CONSTRAINT [FK_DonHang_BanAn] FOREIGN KEY([MaBan])
REFERENCES [dbo].[banan] ([MaBan])
GO
ALTER TABLE [dbo].[donhang] CHECK CONSTRAINT [FK_DonHang_BanAn]
GO
ALTER TABLE [dbo].[donhang] WITH CHECK ADD CONSTRAINT [FK_DonHang_NhanVien] FOREIGN KEY([MaNhanVienTao])
REFERENCES [dbo].[nhanvien] ([MaNhanVien])
GO
ALTER TABLE [dbo].[donhang] CHECK CONSTRAINT [FK_DonHang_NhanVien]
GO
ALTER TABLE [dbo].[douong] WITH CHECK ADD CONSTRAINT [FK_DoUong_DanhMuc] FOREIGN KEY([MaDanhMuc])
REFERENCES [dbo].[danhmuc] ([MaDanhMuc])
GO
ALTER TABLE [dbo].[douong] CHECK CONSTRAINT [FK_DoUong_DanhMuc]
GO
ALTER TABLE [dbo].[hoadon] WITH CHECK ADD CONSTRAINT [FK_HoaDon_DonHang] FOREIGN KEY([MaDonHang])
REFERENCES [dbo].[donhang] ([MaDonHang])
GO
ALTER TABLE [dbo].[hoadon] CHECK CONSTRAINT [FK_HoaDon_DonHang]
GO
ALTER TABLE [dbo].[hoadon] WITH CHECK ADD CONSTRAINT [FK_HoaDon_NhanVien] FOREIGN KEY([MaNhanVienThuNgan])
REFERENCES [dbo].[nhanvien] ([MaNhanVien])
GO
ALTER TABLE [dbo].[hoadon] CHECK CONSTRAINT [FK_HoaDon_NhanVien]
GO
ALTER TABLE [dbo].[nhanvien] WITH CHECK ADD CONSTRAINT [FK_NhanVien_ChucVu] FOREIGN KEY([MaChucVu])
REFERENCES [dbo].[chucvu] ([MaChucVu])
GO
ALTER TABLE [dbo].[nhanvien] CHECK CONSTRAINT [FK_NhanVien_ChucVu]
GO
ALTER TABLE [dbo].[taikhoan] WITH CHECK ADD CONSTRAINT [FK_TaiKhoan_NhanVien] FOREIGN KEY([MaNhanVien])
REFERENCES [dbo].[nhanvien] ([MaNhanVien])
GO
ALTER TABLE [dbo].[taikhoan] CHECK CONSTRAINT [FK_TaiKhoan_NhanVien]
GO


-- =============================================
-- PHẦN 2 NẠP DỮ LIỆU MẪU (DML)
-- =============================================

-- 1. NẠP DỮ LIỆU BẢNG chucvu
SET IDENTITY_INSERT [dbo].[chucvu] ON;
INSERT INTO [dbo].[chucvu] ([MaChucVu], [TenChucVu], [MoTa]) VALUES
(1, N'Quản lý', N'Quản lý toàn bộ hoạt động của quán'),
(2, N'Thu ngân', N'Thực hiện thanh toán và lập hóa đơn'),
(3, N'Pha chế', N'Pha chế đồ uống theo yêu cầu'),
(4, N'Phục vụ', N'Phục vụ khách hàng và dọn dẹp bàn');
SET IDENTITY_INSERT [dbo].[chucvu] OFF;
GO

-- 2. NẠP DỮ LIỆU BẢNG nhanvien
INSERT INTO [dbo].[nhanvien] ([MaNhanVien], [HoTen], [NgaySinh], [GioiTinh], [SoDienThoai], [DiaChi], [Email], [NgayVaoLam], [TrangThaiLamViec], [MaChucVu]) VALUES
('NV001', N'Nguyễn Văn An', '1995-05-12', N'Nam', '0901122334', N'123 Nguyễn Trãi, Q.5, TP.HCM', 'an.nguyen@quanlycafe.com', '2023-01-15', N'DangLamViec', 1),
('NV002', N'Trần Thị Bích', '1998-08-20', N'Nữ', '0912233445', N'456 Lê Văn Việt, TP. Thủ Đức', 'bich.tran@quanlycafe.com', '2023-03-10', N'DangLamViec', 2),
('NV003', N'Lê Hoàng Long', '2000-11-05', N'Nam', '0923344556', N'789 CMT8, Q.10, TP.HCM', 'long.le@quanlycafe.com', '2023-06-01', N'DangLamViec', 3),
('NV004', N'Phạm Thị Mai', '2002-02-14', N'Nữ', '0934455667', N'321 Hoàng Văn Thụ, Q. Tân Bình', 'mai.pham@quanlycafe.com', '2024-01-10', N'DangLamViec', 4);
GO

-- 3. NẠP DỮ LIỆU BẢNG taikhoan
INSERT INTO [dbo].[taikhoan] ([TenDangNhap], [MatKhauHash], [VaiTro], [TrangThaiKhoa], [NgayTao], [MaNhanVien]) VALUES
('admin', '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918', 'Admin', 0, GETDATE(), 'NV001'),
('thungan01', 'e6c53572f4e3c92e7d7045b88251e39a51d95dc51e9e802a4339e38e6e58f001', 'ThuNgan', 0, GETDATE(), 'NV002'),
('phache01', 'e6c53572f4e3c92e7d7045b88251e39a51d95dc51e9e802a4339e38e6e58f001', 'NhanVien', 0, GETDATE(), 'NV003');
GO

-- 4. NẠP DỮ LIỆU BẢNG khuvuc
SET IDENTITY_INSERT [dbo].[khuvuc] ON;
INSERT INTO [dbo].[khuvuc] ([MaKhuVuc], [TenKhuVuc], [GhiChu]) VALUES
(1, N'Khu vực máy lạnh', N'Phòng kín, có điều hòa mát mẻ'),
(2, N'Sân vườn', N'Không gian mở, thoáng đãng, nhiều cây xanh'),
(3, N'Tầng thượng', N'View ngắm phố phường về đêm');
SET IDENTITY_INSERT [dbo].[khuvuc] OFF;
GO

-- 5. NẠP DỮ LIỆU BẢNG banan
SET IDENTITY_INSERT [dbo].[banan] ON;
INSERT INTO [dbo].[banan] ([MaBan], [TenBan], [SoGhe], [TrangThai], [MaKhuVuc]) VALUES
(1, N'Bàn 01', 4, N'Trong', 1),
(2, N'Bàn 02', 4, N'DangPhucVu', 1),
(3, N'Bàn 03', 2, N'Trong', 1),
(4, N'Bàn 04', 6, N'DaDat', 2),
(5, N'Bàn 05', 4, N'Trong', 2),
(6, N'Bàn 06', 4, N'Trong', 3);
SET IDENTITY_INSERT [dbo].[banan] OFF;
GO

-- 6. NẠP DỮ LIỆU BẢNG danhmuc
SET IDENTITY_INSERT [dbo].[danhmuc] ON;
INSERT INTO [dbo].[danhmuc] ([MaDanhMuc], [TenDanhMuc], [MoTa]) VALUES
(1, N'Cà phê', N'Các loại cà phê truyền thống và máy'),
(2, N'Trà sữa', N'Các loại trà sữa thơm ngon béo ngậy'),
(3, N'Sinh tố & Nước ép', N'Đồ uống tươi từ trái cây tự nhiên'),
(4, N'Bánh ngọt', N'Các loại bánh ăn kèm');
SET IDENTITY_INSERT [dbo].[danhmuc] OFF;
GO

-- 7. NẠP DỮ LIỆU BẢNG douong
INSERT INTO [dbo].[douong] ([MaDoUong], [TenDoUong], [GiaBanHienTai], [HinhAnh], [MoTa], [TrangThaiKinhDoanh], [MaDanhMuc]) VALUES
('CF01', N'Cà phê đen đá', 25000.00, 'cf_den.jpg', N'Cà phê rang xay nguyên chất', 'ConHang', 1),
('CF02', N'Cà phê sữa đá', 29000.00, 'cf_sua.jpg', N'Cà phê kết hợp sữa đặc ngọt ngào', 'ConHang', 1),
('TS01', N'Trà sữa truyền thống', 35000.00, 'ts_truyenthong.jpg', N'Trà sữa kèm trân châu đen', 'ConHang', 2),
('TS02', N'Trà sữa matcha', 40000.00, 'ts_matcha.jpg', N'Trà sữa vị matcha Nhật Bản', 'ConHang', 2),
('ST01', N'Sinh tố bơ', 45000.00, 'st_bo.jpg', N'Sinh tố bơ tươi đậm đà', 'ConHang', 3),
('BN01', N'Bánh Tiramisu', 38000.00, 'bn_tiramisu.jpg', N'Bánh ngọt vị cà phê Ý', 'ConHang', 4);
GO

-- 8. NẠP DỮ LIỆU BẢNG khachhang (Đã thêm dữ liệu cho HangThanhVien và GhiChu)
SET IDENTITY_INSERT [dbo].[khachhang] ON;
INSERT INTO [dbo].[khachhang] ([MaKhachHang], [TenKhachHang], [SoDienThoai], [NgayTao], [HangThanhVien], [GhiChu]) VALUES
(1, N'Trần Văn Khách', '0988776655', GETDATE(), N'VIP', N'Thích ít ngọt, hay ngồi khu vực tầng 1'),
(2, N'Lê Thị Hương', '0977665544', GETDATE(), N'ThanThiet', N'Khách quen gọi trà sữa matcha'),
(3, N'Nguyễn Hoàng Huy', '0966554433', GETDATE(), N'Moi', N'Khách mới ghé lần đầu');
SET IDENTITY_INSERT [dbo].[khachhang] OFF;
GO

-- 9. NẠP DỮ LIỆU BẢNG datban
SET IDENTITY_INSERT [dbo].[datban] ON;
INSERT INTO [dbo].[datban] ([MaDatBan], [SoLuongKhach], [NgayGioDat], [NgayGioDenDuKien], [GhiChu], [TrangThaiDat], [MaKhachHang], [MaBan], [MaNhanVienTiepNhan]) VALUES
(1, 4, GETDATE(), DATEADD(hour, 2, GETDATE()), N'Đặt bàn góc thoáng mát', 'DaXacNhan', 1, 4, 'NV001');
SET IDENTITY_INSERT [dbo].[datban] OFF;
GO

-- 10. NẠP DỮ LIỆU BẢNG donhang
INSERT INTO [dbo].[donhang] ([MaDonHang], [ThoiGianTao], [LoaiDon], [TrangThaiDon], [MaBan], [MaNhanVienTao]) VALUES
('DH2026051101', GETDATE(), 'TaiCho', 'DangPhucVu', 2, 'NV004');
GO

-- 11. NẠP DỮ LIỆU BẢNG chitietdonhang
INSERT INTO [dbo].[chitietdonhang] ([MaDonHang], [MaDoUong], [SoLuong], [DonGiaTaiThoiDiemGoi], [GhiChuMon], [ThanhTien]) VALUES
('DH2026051101', 'CF01', 2, 25000.00, N'Ít đường', 50000.00),
('DH2026051101', 'TS01', 1, 35000.00, N'Nhiều trân châu', 35000.00);
GO

-- Mật khẩu mẫu để nhóm kiểm thử.
UPDATE dbo.taikhoan SET MatKhau=N'admin' WHERE TenDangNhap='admin';
UPDATE dbo.taikhoan
SET MatKhau=N'Test@12345',
    MatKhauHash=LOWER(CONVERT(varchar(64),HASHBYTES('SHA2_256','Test@12345'),2))
WHERE TenDangNhap IN ('phache01','thungan01');
GO