<%@ Page Title="Kiểm thử, Nghiệm thu & Báo lỗi" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="KiemThuNghiemThu.aspx.cs" Inherits="N9_QLCAFE.KiemThuNghiemThu" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <!-- HEADER -->
    <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 gap-3">
        <div>
            <span class="badge badge-soft-blue mb-1">Phân hệ NF01 - NF08 • Phụ trách: Mẫn Vinh (Test, Nghiệm thu & Lỗi)</span>
            <h4 class="fw-bold mb-0 text-dark">Trung tâm Kiểm thử, Nghiệm thu Nghiệp vụ & Sao lưu Hệ thống</h4>
        </div>
        <div class="d-flex flex-wrap gap-2">
            <button type="button" class="btn btn-cafe-outline" data-bs-toggle="modal" data-bs-target="#modalSaoLuu">
                <i class="bi bi-cloud-arrow-up me-1"></i>Sao lưu & Phục hồi DB (NF07)
            </button>
            <button type="button" class="btn btn-cafe-primary" data-bs-toggle="modal" data-bs-target="#modalBaoLoi">
                <i class="bi bi-bug-fill me-1"></i>Ghi nhận Lỗi / Bug mới
            </button>
        </div>
    </div>

    <!-- 4 THẺ CHỈ SỐ KIỂM THỬ & NGHIỆM THU -->
    <div class="row g-3 mb-4">
        <div class="col-12 col-sm-6 col-xl-3">
            <div class="stat-card stat-card-primary">
                <div>
                    <div class="small opacity-75 fw-medium">Tổng chức năng đặc tả</div>
                    <h3 class="fw-bold my-1">58 / 58 (F01-F58)</h3>
                    <div class="small opacity-75">Đạt 100% giao diện đặc tả</div>
                </div>
                <div class="stat-icon">
                    <i class="bi bi-ui-checks-grid"></i>
                </div>
            </div>
        </div>
        <div class="col-12 col-sm-6 col-xl-3">
            <div class="stat-card">
                <div>
                    <div class="text-muted small fw-medium">Yêu cầu Phi chức năng</div>
                    <h3 class="fw-bold my-1 text-primary">8 / 8 (NF01-NF08)</h3>
                    <div class="small text-success fw-medium"><i class="bi bi-shield-check"></i> Đã kiểm tra tiêu chuẩn</div>
                </div>
                <div class="stat-icon">
                    <i class="bi bi-patch-check-fill"></i>
                </div>
            </div>
        </div>
        <div class="col-12 col-sm-6 col-xl-3">
            <div class="stat-card">
                <div>
                    <div class="text-muted small fw-medium">Kịch bản Test Quy tắc</div>
                    <h3 class="fw-bold my-1 text-dark">26 Test Cases</h3>
                    <div class="small text-primary">24 Pass • 2 Đang theo dõi</div>
                </div>
                <div class="stat-icon">
                    <i class="bi bi-clipboard2-check"></i>
                </div>
            </div>
        </div>
        <div class="col-12 col-sm-6 col-xl-3">
            <div class="stat-card">
                <div>
                    <div class="text-muted small fw-medium">Bản sao lưu MySQL (NF07)</div>
                    <h3 class="fw-bold my-1 text-dark">Hôm nay 14:00</h3>
                    <div class="small text-muted">n9_qlcafe_backup.sql</div>
                </div>
                <div class="stat-icon">
                    <i class="bi bi-database-check"></i>
                </div>
            </div>
        </div>
    </div>

    <div class="row g-4 mb-4">
        <!-- CỘT TRÁI: BẢNG NGHIỆM THU YÊU CẦU PHI CHỨC NĂNG (NF01 - NF08) -->
        <div class="col-12 col-lg-6">
            <div class="card-custom h-100">
                <div class="card-header-custom">
                    <div>
                        <h6 class="fw-bold mb-0 text-dark"><i class="bi bi-shield-fill-check text-primary me-2"></i>Nghiệm thu Yêu cầu Phi chức năng (Mục 3)</h6>
                        <small class="text-muted">Đánh giá các tiêu chí NF01 → NF08 theo tài liệu đặc tả Nhóm 9</small>
                    </div>
                    <span class="badge badge-soft-blue">NF01 - NF08</span>
                </div>
                <div class="table-responsive">
                    <table class="table table-cafe">
                        <thead>
                            <tr>
                                <th>Mã</th>
                                <th>Yêu cầu & Mô tả</th>
                                <th class="text-end">Kết quả</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td class="fw-bold text-primary">NF01</td>
                                <td>
                                    <div class="fw-semibold">Hiệu năng</div>
                                    <small class="text-muted">Các thao tác thông thường phản hồi nhanh</small>
                                </td>
                                <td class="text-end"><span class="badge badge-soft-success">Đạt (Pass)</span></td>
                            </tr>
                            <tr>
                                <td class="fw-bold text-primary">NF02</td>
                                <td>
                                    <div class="fw-semibold">Bảo mật</div>
                                    <small class="text-muted">Mật khẩu được mã hóa trước khi lưu</small>
                                </td>
                                <td class="text-end"><span class="badge badge-soft-success">Đạt (Pass)</span></td>
                            </tr>
                            <tr>
                                <td class="fw-bold text-primary">NF03</td>
                                <td>
                                    <div class="fw-semibold">Phân quyền</div>
                                    <small class="text-muted">Người dùng chỉ truy cập chức năng được cấp quyền</small>
                                </td>
                                <td class="text-end"><span class="badge badge-soft-success">Đạt (Pass)</span></td>
                            </tr>
                            <tr>
                                <td class="fw-bold text-primary">NF04</td>
                                <td>
                                    <div class="fw-semibold">Tính chính xác</div>
                                    <small class="text-muted">Tính tiền và doanh thu chính xác</small>
                                </td>
                                <td class="text-end"><span class="badge badge-soft-success">Đạt (Pass)</span></td>
                            </tr>
                            <tr>
                                <td class="fw-bold text-primary">NF05</td>
                                <td>
                                    <div class="fw-semibold">Dễ sử dụng</div>
                                    <small class="text-muted">Giao diện trực quan, dễ thao tác (Xanh dương & Trắng)</small>
                                </td>
                                <td class="text-end"><span class="badge badge-soft-success">Đạt (Pass)</span></td>
                            </tr>
                            <tr>
                                <td class="fw-bold text-primary">NF06</td>
                                <td>
                                    <div class="fw-semibold">Toàn vẹn dữ liệu</div>
                                    <small class="text-muted">Đảm bảo quan hệ khóa ngoại giữa các bảng MySQL</small>
                                </td>
                                <td class="text-end"><span class="badge badge-soft-success">Đạt (Pass)</span></td>
                            </tr>
                            <tr>
                                <td class="fw-bold text-primary">NF07</td>
                                <td>
                                    <div class="fw-semibold">Sao lưu</div>
                                    <small class="text-muted">Có khả năng sao lưu và phục hồi dữ liệu</small>
                                </td>
                                <td class="text-end"><span class="badge badge-soft-success">Đạt (Pass)</span></td>
                            </tr>
                            <tr>
                                <td class="fw-bold text-primary">NF08</td>
                                <td>
                                    <div class="fw-semibold">Khả năng mở rộng</div>
                                    <small class="text-muted">Có thể bổ sung chức năng mới dễ dàng</small>
                                </td>
                                <td class="text-end"><span class="badge badge-soft-success">Đạt (Pass)</span></td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- CỘT PHẢI: KIỂM THỬ QUY TẮC NGHIỆP VỤ & NHẬT KÝ BÁO LỖI -->
        <div class="col-12 col-lg-6">
            <div class="card-custom h-100">
                <div class="card-header-custom">
                    <div>
                        <h6 class="fw-bold mb-0 text-dark"><i class="bi bi-bug text-primary me-2"></i>Kịch bản Kiểm thử Quy tắc Nghiệp vụ & Báo lỗi</h6>
                        <small class="text-muted">Kiểm tra các ràng buộc nghiệp vụ trong mục 2.1 → 2.8</small>
                    </div>
                    <span class="badge badge-soft-blue">QC: Mẫn Vinh</span>
                </div>
                <div class="table-responsive">
                    <table class="table table-cafe">
                        <thead>
                            <tr>
                                <th>Mã TC</th>
                                <th>Nội dung kiểm thử quy tắc</th>
                                <th>Phân hệ</th>
                                <th class="text-end">Trạng thái</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td class="fw-bold text-primary">TC01</td>
                                <td>
                                    <div class="fw-semibold">Chặn xóa vật lý đồ uống đã có giao dịch</div>
                                    <small class="text-muted">Chỉ chuyển sang trạng thái "Ngừng kinh doanh" (F08)</small>
                                </td>
                                <td><span class="badge badge-soft-blue">Đồ uống</span></td>
                                <td class="text-end"><span class="badge badge-soft-success">Pass</span></td>
                            </tr>
                            <tr>
                                <td class="fw-bold text-primary">TC02</td>
                                <td>
                                    <div class="fw-semibold">Chặn gọi món đã hết hàng trên màn hình POS</div>
                                    <small class="text-muted">Nút Thêm món bị vô hiệu hóa khi trạng thái Hết hàng (F12)</small>
                                </td>
                                <td><span class="badge badge-soft-blue">Gọi món</span></td>
                                <td class="text-end"><span class="badge badge-soft-success">Pass</span></td>
                            </tr>
                            <tr>
                                <td class="fw-bold text-primary">TC03</td>
                                <td>
                                    <div class="fw-semibold">Không cho phép trùng lịch đặt bàn cùng thời điểm</div>
                                    <small class="text-muted">Kiểm tra bàn trống trước khi xác nhận đặt bàn (F21, F24)</small>
                                </td>
                                <td><span class="badge badge-soft-blue">Đặt bàn</span></td>
                                <td class="text-end"><span class="badge badge-soft-success">Pass</span></td>
                            </tr>
                            <tr>
                                <td class="fw-bold text-primary">TC04</td>
                                <td>
                                    <div class="fw-semibold">Không xóa bàn đang có đơn chưa thanh toán</div>
                                    <small class="text-muted">Ẩn/khóa nút xóa đối với bàn đang sử dụng (F16)</small>
                                </td>
                                <td><span class="badge badge-soft-blue">Bàn</span></td>
                                <td class="text-end"><span class="badge badge-soft-success">Pass</span></td>
                            </tr>
                            <tr>
                                <td class="fw-bold text-primary">TC05</td>
                                <td>
                                    <div class="fw-semibold">Lưu đơn giá tại thời điểm gọi món</div>
                                    <small class="text-muted">Tránh thay đổi hóa đơn cũ khi cập nhật giá menu (F11, F33)</small>
                                </td>
                                <td><span class="badge badge-soft-blue">Hóa đơn</span></td>
                                <td class="text-end"><span class="badge badge-soft-success">Pass</span></td>
                            </tr>
                            <tr>
                                <td class="fw-bold text-primary">TC06</td>
                                <td>
                                    <div class="fw-semibold">Doanh thu chỉ tính hóa đơn đã thanh toán thành công</div>
                                    <small class="text-muted">Loại trừ đơn hàng đang phục vụ hoặc hóa đơn đã hủy (F51-F57)</small>
                                </td>
                                <td><span class="badge badge-soft-blue">Thống kê</span></td>
                                <td class="text-end"><span class="badge badge-soft-success">Pass</span></td>
                            </tr>
                            <tr>
                                <td class="fw-bold text-primary">BUG01</td>
                                <td>
                                    <div class="fw-semibold">Xác nhận giao dịch chuyển khoản QR trước khi đóng bàn</div>
                                    <small class="text-muted">Cần nhân viên bấm Xác nhận hoàn tất (F40, F41)</small>
                                </td>
                                <td><span class="badge badge-soft-blue">Thanh toán</span></td>
                                <td class="text-end"><span class="badge badge-soft-warning">Đang kiểm tra</span></td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <!-- MODAL SAO LƯU & PHỤC HỒI DỮ LIỆU (NF07) -->
    <div class="modal fade" id="modalSaoLuu" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow">
                <div class="modal-header bg-primary text-white">
                    <h6 class="modal-title fw-bold"><i class="bi bi-database-gear me-2"></i>Sao lưu & Phục hồi Cơ sở dữ liệu MySQL (NF07)</h6>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body p-4">
                    <div class="p-3 rounded-3 bg-light border mb-3">
                        <div class="d-flex justify-content-between align-items-center mb-2">
                            <span class="fw-bold text-primary"><i class="bi bi-hdd-network me-1"></i>Database: n9_qlcafe_db (MySQL)</span>
                            <span class="badge badge-soft-success">Đang kết nối</span>
                        </div>
                        <div class="small text-muted">Bản sao lưu gần nhất: <strong>n9_qlcafe_20261109_1400.sql</strong> (4.2 MB)</div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Tạo bản sao lưu mới (Backup)</label>
                        <div class="input-group">
                            <input type="text" class="form-control" value="n9_qlcafe_backup_20261109.sql" />
                            <button type="button" class="btn btn-cafe-primary"><i class="bi bi-download me-1"></i>Tạo Backup</button>
                        </div>
                    </div>
                    <div class="mb-0">
                        <label class="form-label small fw-semibold">Phục hồi dữ liệu từ file .sql (Restore)</label>
                        <input type="file" class="form-control" />
                    </div>
                </div>
                <div class="modal-footer bg-light">
                    <button type="button" class="btn btn-sm btn-secondary" data-bs-dismiss="modal">Đóng</button>
                    <button type="button" class="btn btn-sm btn-cafe-primary" data-bs-dismiss="modal">Thực hiện Phục hồi</button>
                </div>
            </div>
        </div>
    </div>

    <!-- MODAL GHI NHẬN LỖI / BUG MỚI -->
    <div class="modal fade" id="modalBaoLoi" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow">
                <div class="modal-header bg-primary text-white">
                    <h6 class="modal-title fw-bold"><i class="bi bi-bug-fill me-2"></i>Phiếu Ghi nhận Lỗi / Nghiệm thu (Mẫn Vinh)</h6>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body p-4">
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Phân hệ phát sinh lỗi <span class="text-danger">*</span></label>
                        <select class="form-select">
                            <option selected>F06 - F13: Quản lý Đồ uống & Menu (Nguyễn Anh Kỳ)</option>
                            <option>F14 - F26: Quản lý Bàn & Đặt bàn (Lư Quốc Thắng)</option>
                            <option>F27 - F44: Gọi món & Thanh toán (Lê Văn Điều)</option>
                            <option>F01 - F05, F45 - F58: Tài khoản, NV & Thống kê (Nguyễn Nhật Anh)</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Tiêu đề lỗi / Vấn đề nghiệm thu <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" placeholder="Nhập mô tả ngắn gọn..." />
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Mức độ ưu tiên</label>
                        <select class="form-select">
                            <option>Cao (Ảnh hưởng quy tắc tính tiền / dữ liệu)</option>
                            <option selected>Trung bình (Cần tinh chỉnh giao diện / cảnh báo)</option>
                            <option>Thấp (Góp ý cải tiến trải nghiệm NF05)</option>
                        </select>
                    </div>
                    <div class="mb-0">
                        <label class="form-label small fw-semibold">Các bước tái hiện & Kết quả mong đợi</label>
                        <textarea class="form-control" rows="3" placeholder="Nhập chi tiết kịch bản kiểm thử..."></textarea>
                    </div>
                </div>
                <div class="modal-footer bg-light">
                    <button type="button" class="btn btn-sm btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="button" class="btn btn-sm btn-cafe-primary" data-bs-dismiss="modal">Lưu phiếu báo lỗi</button>
                </div>
            </div>
        </div>
    </div>
</asp:Content>

