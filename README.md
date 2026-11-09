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

---

## 4. QUY TRÌNH LÀM VIỆC NHÓM VỚI GIT & GITHUB (TRÁNH XUNG ĐỘT / CONFLICT)

Để cả 5 thành viên cùng làm việc trơn tru, **không bị ghi đè mất code hoặc bị lỗi trùng lặp (Conflict)**, tất cả thành viên trong nhóm cần tuân thủ quy trình dưới đây:

### 4.1. Lần đầu tiên lấy code về máy (Clone)
Mở Terminal / PowerShell / Git Bash tại thư mục muốn lưu dự án:
```bash
git clone https://github.com/levandieu2001/du-an-nhom-web.git
cd du-an-nhom-web
```
Sau đó mở file `N9_QLCAFE/N9_QLCAFE.sln` trên Visual Studio và làm việc bình thường.

---

### 4.2. Nguyên tắc vàng để KHÔNG BAO GIỜ bị xung đột code
1. **Mỗi người một nhánh (Branch) riêng**: Tuyệt đối **không code trực tiếp trên nhánh `main`**.
2. **Ai làm file người nấy**: Mỗi thành viên chỉ sửa các file `.aspx` và `.cs` thuộc phân hệ của mình đã phân công ở Mục 1 (Ví dụ: Anh Kỳ làm `DoUong.aspx`, Thắng làm `BanVaDatBan.aspx`, Điều làm `GoiMonThanhToan.aspx`...).
3. **Trước khi bắt đầu code**: Luôn cập nhật code mới nhất từ GitHub về máy (`git pull`).
4. **Không commit file rác / file biên dịch**: Thư mục `.vs/`, `bin/`, `obj/` đã được chặn trong `.gitignore`. Không dùng lệnh ép thêm (`git add -f`) các thư mục này.

---

### 4.3. Quy trình làm việc hàng ngày (3 giai đoạn)

#### 🔹 Giai đoạn 1: Bắt đầu làm việc (Tạo hoặc chuyển sang nhánh của mình)
Đặt tên nhánh theo tên bạn hoặc tính năng bạn làm:
- Nguyễn Anh Kỳ: `feat/douong`
- Lư Quốc Thắng: `feat/ban-datban`
- Lê Văn Điều: `feat/pos-thanhtoan`
- Nguyễn Nhật Anh: `feat/nhanvien-thongke`
- Mẫn Vinh: `feat/kiemthu-nghiemthu`

Lệnh tạo nhánh mới (chỉ làm lần đầu):
```bash
git checkout main
git pull origin main
git checkout -b feat/douong
```
*(Từ các lần sau chỉ cần chuyển vào nhánh của mình: `git checkout feat/douong`)*

---

#### 🔹 Giai đoạn 2: Lưu và đẩy code của mình lên GitHub
Sau khi code và kiểm tra chạy thử trên Visual Studio thành công:
```bash
# 1. Xem các file mình vừa chỉnh sửa
git status

# 2. Thêm các file thay đổi vào danh sách chuẩn bị lưu
git add .

# 3. Lưu commit kèm thông điệp rõ ràng
git commit -m "Mo ta ngan gon cong viec vua lam (VD: Hoan thien xu ly them do uong F06)"

# 4. Đẩy nhánh của mình lên GitHub (chỉ đẩy nhánh của mình, KHÔNG đẩy đè main)
git push origin feat/douong
```

---

#### 🔹 Giai đoạn 3: Đồng bộ code mới nhất của các bạn khác về máy mình
Khi một bạn khác đã đẩy code mới lên `main`, để lấy về nhánh mình mà không bị lỗi:
```bash
# 1. Chuyển về nhánh main và kéo code mới nhất về
git checkout main
git pull origin main

# 2. Chuyển lại về nhánh của mình
git checkout feat/douong

# 3. Gộp code mới từ main vào nhánh của mình
git merge main

# 4. Kiểm tra lại web trên Visual Studio, nếu ổn thì đẩy nhánh mình lên lại
git push origin feat/douong
```

---

### 4.4. Cách xử lý khi gặp Xung Đột (Merge Conflict)

Nếu vô tình 2 bạn cùng sửa vào cùng 1 dòng trong file chung (ví dụ `Web.config` hoặc `Site.Master`):
1. Git sẽ báo thông báo `CONFLICT (content): Merge conflict in ...`.
2. Mở file bị báo đỏ lên trong Visual Studio (hoặc VS Code).
3. Bạn sẽ thấy dấu hiệu:
   ```text
   <<<<<<< HEAD (Code hiện tại trên máy bạn)
   Code của bạn
   =======
   Code của bạn khác trên GitHub
   >>>>>>> main
   ```
4. **Cách giải quyết:** Thảo luận với bạn trong nhóm để chọn giữ đoạn nào (hoặc kết hợp cả 2), sau đó xóa các ký hiệu `<<<<<<<`, `=======`, `>>>>>>>` đi và lưu file lại.
5. Chạy lệnh hoàn tất:
   ```bash
   git add .
   git commit -m "Giai quyet conflict merge tu main"
   git push origin <ten-nhanh-cua-ban>
   ```

---

### 4.5. Lệnh hữu ích khi muốn cất tạm code chưa làm xong (`git stash`)
Nếu bạn đang code dở mà cần kéo code mới về ngay:
```bash
git stash             # Cất tạm code dở vào ngăn kéo bí mật
git pull origin main  # Kéo code mới về
git stash pop         # Lấy lại code đang làm dở ra làm tiếp
```
