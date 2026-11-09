# N9_QLCAFE - HỆ THỐNG QUẢN LÝ CỬA HÀNG CAFÉ (NHÓM 9)

> **Dự án môn học:** Lập trình Web / Ứng dụng Web  
> **Nền tảng:** ASP.NET Web Forms (.NET Framework 4.7.2), Bootstrap 5, MySQL  
> **Tông màu chủ đạo:** Xanh dương & Trắng (Blue & White Modern UI)

---

## 1. THÀNH VIÊN NHÓM 9 & PHÂN CHIA ĐẶC TẢ

Theo tài liệu đặc tả **Nhóm 9.docx** (Mục 5):

| Thành viên | Phân hệ phụ trách | Mã chức năng đặc tả | Trang giao diện tương ứng |
|---|---|---|---|
| **Nguyễn Anh Kỳ** | Quản lý đồ uống & danh mục | `F06` → `F13` | [DoUong.aspx](N9_QLCAFE/N9_QLCAFE/DoUong.aspx) |
| **Lư Quốc Thắng** | Quản lý bàn, khu vực & đặt bàn | `F14` → `F26` | [BanVaDatBan.aspx](N9_QLCAFE/N9_QLCAFE/BanVaDatBan.aspx) |
| **Lê Văn Điều** | Gọi món (POS), đơn hàng & thanh toán | `F27` → `F44` | [GoiMonThanhToan.aspx](N9_QLCAFE/N9_QLCAFE/GoiMonThanhToan.aspx) |
| **Nguyễn Nhật Anh** | Tài khoản, phân quyền, nhân viên & thống kê | `F01` → `F05`, `F45` → `F58` | [NhanVienTaiKhoan.aspx](N9_QLCAFE/N9_QLCAFE/NhanVienTaiKhoan.aspx), [Default.aspx](N9_QLCAFE/N9_QLCAFE/Default.aspx) |
| **Mẫn Vinh** | Kiểm thử, nghiệm thu quy tắc & báo lỗi | `NF01` → `NF08`, Test Cases | [KiemThuNghiemThu.aspx](N9_QLCAFE/N9_QLCAFE/KiemThuNghiemThu.aspx), [Login.aspx](N9_QLCAFE/N9_QLCAFE/Login.aspx) |

---

## 2. DANH MỤC CÁC TRANG GIAO DIỆN (UI)

1. **Khung giao diện chung:**
   - `Site.Master`: Sidebar điều hướng, Topbar tìm kiếm nhanh, menu người dùng, Modal đổi mật khẩu (`F03`).
   - `Content/site.css`: Tùy biến toàn bộ màu sắc chủ đạo xanh dương - trắng, kiểu dáng thẻ KPI, bàn café, menu món nước.
2. **Thống kê Doanh thu:** `Default.aspx`
   - Bộ lọc thời gian theo ngày, tháng, năm (`F51`, `F52`, `F53`, `F56`).
   - 4 thẻ KPI doanh thu, số lượng đơn thanh toán (`F54`), số ly bán được.
   - Biểu đồ doanh thu 7 ngày (`F57`), tỷ lệ tiền mặt/chuyển khoản (`F39`, `F40`).
   - Bảng Top 5 món bán chạy nhất (`F55`) và phân chia công việc 5 thành viên.
3. **Quản lý Đồ uống & Menu:** `DoUong.aspx`
   - Chế độ xem dạng bảng chi tiết và dạng lưới Menu trực quan cho nhân viên (`F13`).
   - Modal Thêm / Sửa đồ uống, hình ảnh, mô tả, cập nhật giá (`F06`, `F07`, `F11`).
   - Modal Quản lý danh mục sản phẩm (`F10`).
   - Cảnh báo quy tắc: món ngừng kinh doanh (`F08`), hết hàng (`F12`).
4. **Quản lý Bàn & Đặt bàn trước:** `BanVaDatBan.aspx`
   - Sơ đồ bàn trực quan theo khu vực tầng 1, tầng 2, sân vườn (`F17`).
   - Trạng thái bàn: Trống, Đang sử dụng, Đã đặt trước (`F18`).
   - Modal Thêm/Sửa bàn (`F14`, `F15`), Chuyển bàn (`F19`), Khu vực (`F17`).
   - Tab Quản lý & Lịch đặt bàn trước (`F21`, `F22`, `F24`, `F25`, `F26`), trạng thái No-show / hủy (`F23`).
5. **Gọi món (POS) & Thanh toán Hóa đơn:** `GoiMonThanhToan.aspx`
   - Quầy POS 2 cột: Cột chọn món nhanh từ menu (`F28`, `F29`) và Cột đơn hàng bàn hiện tại (`F27`).
   - Chỉnh số lượng (`F30`), xóa món (`F31`), ghi chú món ít đá/ít đường (`F32`), tạm tính (`F33`), giảm giá (`F38`).
   - Chọn phương thức thanh toán Tiền mặt (`F39`) / Chuyển khoản QR (`F40`).
   - Tab Tra cứu & Lịch sử hóa đơn giao dịch (`F43`, `F44`).
   - Modal In và xác nhận thanh toán hóa đơn (`F36`, `F41`, `F42`).
6. **Nhân viên & Tài khoản Phân quyền:** `NhanVienTaiKhoan.aspx`
   - Danh sách hồ sơ nhân viên (`F45`, `F46`, `F47`, `F48`).
   - Quản lý chức vụ làm việc (`F49`), liên kết tài khoản (`F50`).
   - Tab Quản lý tài khoản hệ thống (`F05`) kèm Ma trận phân quyền Admin / Quản lý / Nhân viên (`F04`, `NF03`).
7. **Quản lý Khách hàng & Thành viên:** `KhachHang.aspx`
   - Danh sách khách hàng thân thiết, khách VIP, tích điểm và ưu đãi giảm giá (`F38`).
8. **Kiểm thử, Nghiệm thu & Báo lỗi:** `KiemThuNghiemThu.aspx`
   - Bảng đánh giá nghiệm thu 8 yêu cầu phi chức năng (`NF01` - `NF08`).
   - Kịch bản test quy tắc nghiệp vụ (ràng buộc không xóa vật lý món đã bán, kiểm tra trùng bàn, tính tiền chính xác).
   - Modal Sao lưu & Phục hồi cơ sở dữ liệu MySQL (`NF07`).
   - Modal Ghi nhận lỗi / Bug mới cho Tester.
9. **Trang Đăng nhập:** `Login.aspx`
   - Giao diện đăng nhập hệ thống (`F01`) kèm chọn vai trò truy cập và thông tin nhóm.

---

## 3. CÁCH CHẠY DỰ ÁN TRÊN VISUAL STUDIO

1. Mở file giải pháp `N9_QLCAFE/N9_QLCAFE.sln` bằng **Visual Studio 2022 / 2019**.
2. Nhấn tổ hợp phím **Ctrl + F5** (hoặc nút **Start Without Debugging** / **F5**).
3. Visual Studio sẽ tự động khởi động IIS Express và mở trình duyệt tại trang `Default.aspx`.
