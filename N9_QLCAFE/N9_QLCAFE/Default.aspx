<%@ Page Title="Thống kê & Báo cáo Doanh thu" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="N9_QLCAFE._Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <!-- TIÊU ĐỀ & BỘ LỌC THỜI GIAN (F56, F58) -->
    <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 gap-3">
        <div>
            <span class="badge badge-soft-blue mb-1">Phân hệ F51 - F58 • Phụ trách: Nguyễn Nhật Anh</span>
            <h4 class="fw-bold mb-0 text-dark">Bảng điều khiển & Thống kê Doanh thu</h4>
        </div>
        <div class="d-flex flex-wrap align-items-center gap-2 bg-white p-2 rounded-3 border">
            <select class="form-select form-select-sm" style="width: 145px;">
                <option selected>Hôm nay (F51)</option>
                <option>Tháng này (F52)</option>
                <option>Năm 2026 (F53)</option>
                <option>Tùy chọn ngày (F56)</option>
            </select>
            <input type="date" class="form-control form-control-sm" style="width: 140px;" value="2026-11-09" />
            <span class="text-muted small">đến</span>
            <input type="date" class="form-control form-control-sm" style="width: 140px;" value="2026-11-09" />
            <button type="button" class="btn btn-sm btn-cafe-primary">
                <i class="bi bi-funnel-fill me-1"></i>Lọc (F56)
            </button>
            <div class="btn-group">
                <button type="button" class="btn btn-sm btn-cafe-outline dropdown-toggle" data-bs-toggle="dropdown">
                    <i class="bi bi-download me-1"></i>Xuất báo cáo (F58)
                </button>
                <ul class="dropdown-menu dropdown-menu-end shadow-sm border-0">
                    <li><a class="dropdown-item small" href="#"><i class="bi bi-file-earmark-excel text-success me-2"></i>Xuất file Excel (.xlsx)</a></li>
                    <li><a class="dropdown-item small" href="#"><i class="bi bi-file-earmark-pdf text-danger me-2"></i>Xuất file PDF (.pdf)</a></li>
                </ul>
            </div>
        </div>
    </div>

    <!-- 4 THẺ CHỈ SỐ KPI CHÍNH (F51 - F54) -->
    <div class="row g-3 mb-4">
        <div class="col-12 col-sm-6 col-xl-3">
            <div class="stat-card stat-card-primary">
                <div>
                    <div class="small opacity-75 fw-medium">Doanh thu hôm nay (F51)</div>
                    <h3 class="fw-bold my-1">0 đ</h3>
                    <div class="small opacity-75">Chưa có phát sinh</div>
                </div>
                <div class="stat-icon">
                    <i class="bi bi-cash-coin"></i>
                </div>
            </div>
        </div>
        <div class="col-12 col-sm-6 col-xl-3">
            <div class="stat-card">
                <div>
                    <div class="text-muted small fw-medium">Doanh thu tháng này (F52)</div>
                    <h3 class="fw-bold my-1 text-primary">0 đ</h3>
                    <div class="small text-muted">Chưa có phát sinh</div>
                </div>
                <div class="stat-icon">
                    <i class="bi bi-calendar2-check"></i>
                </div>
            </div>
        </div>
        <div class="col-12 col-sm-6 col-xl-3">
            <div class="stat-card">
                <div>
                    <div class="text-muted small fw-medium">Đơn đã thanh toán (F54)</div>
                    <h3 class="fw-bold my-1 text-dark">0 hóa đơn</h3>
                    <div class="small text-muted">Chưa có phát sinh</div>
                </div>
                <div class="stat-icon">
                    <i class="bi bi-receipt-cutoff"></i>
                </div>
            </div>
        </div>
        <div class="col-12 col-sm-6 col-xl-3">
            <div class="stat-card">
                <div>
                    <div class="text-muted small fw-medium">Số lượng ly đã bán</div>
                    <h3 class="fw-bold my-1 text-dark">0 ly</h3>
                    <div class="small text-muted">Chưa có phát sinh</div>
                </div>
                <div class="stat-icon">
                    <i class="bi bi-cup-hot"></i>
                </div>
            </div>
        </div>
    </div>

    <!-- BIỂU ĐỒ DOANH THU (F57) & MÓN BÁN CHẠY NHẤT (F55) -->
    <div class="row g-4 mb-4">
        <!-- Cột trái: Biểu đồ doanh thu 7 ngày & Tỷ lệ thanh toán -->
        <div class="col-12 col-lg-7">
            <div class="card-custom h-100">
                <div class="card-header-custom">
                    <div>
                        <h6 class="fw-bold mb-0 text-dark"><i class="bi bi-bar-chart-fill text-primary me-2"></i>Biểu đồ doanh thu 7 ngày gần nhất (F57)</h6>
                        <small class="text-muted">Chỉ tính từ dữ liệu các hóa đơn đã thanh toán thành công</small>
                    </div>
                    <span class="badge badge-soft-blue">Đơn vị: VNĐ</span>
                </div>
                <div class="p-4">
                    <div class="chart-bars">
                        <div class="chart-bar-col">
                            <span class="small text-muted mb-1" style="font-size:0.72rem;">0đ</span>
                            <div class="chart-bar-fill" style="height: 4px;"></div>
                            <span class="small fw-semibold mt-2">T2</span>
                        </div>
                        <div class="chart-bar-col">
                            <span class="small text-muted mb-1" style="font-size:0.72rem;">0đ</span>
                            <div class="chart-bar-fill" style="height: 4px;"></div>
                            <span class="small fw-semibold mt-2">T3</span>
                        </div>
                        <div class="chart-bar-col">
                            <span class="small text-muted mb-1" style="font-size:0.72rem;">0đ</span>
                            <div class="chart-bar-fill" style="height: 4px;"></div>
                            <span class="small fw-semibold mt-2">T4</span>
                        </div>
                        <div class="chart-bar-col">
                            <span class="small text-muted mb-1" style="font-size:0.72rem;">0đ</span>
                            <div class="chart-bar-fill" style="height: 4px;"></div>
                            <span class="small fw-semibold mt-2">T5</span>
                        </div>
                        <div class="chart-bar-col">
                            <span class="small text-muted mb-1" style="font-size:0.72rem;">0đ</span>
                            <div class="chart-bar-fill" style="height: 4px;"></div>
                            <span class="small fw-semibold mt-2">T6</span>
                        </div>
                        <div class="chart-bar-col">
                            <span class="small text-muted mb-1" style="font-size:0.72rem;">0đ</span>
                            <div class="chart-bar-fill" style="height: 4px;"></div>
                            <span class="small fw-semibold mt-2">T7</span>
                        </div>
                        <div class="chart-bar-col">
                            <span class="small text-muted mb-1" style="font-size:0.72rem;">0đ</span>
                            <div class="chart-bar-fill" style="height: 4px;"></div>
                            <span class="small fw-bold text-primary mt-2">CN (Nay)</span>
                        </div>
                    </div>

                    <!-- Thống kê theo phương thức thanh toán -->
                    <div class="row g-3 mt-3 pt-2">
                        <div class="col-sm-6">
                            <div class="p-3 rounded-3 border bg-light d-flex justify-content-between align-items-center">
                                <div>
                                    <div class="text-muted small">Thanh toán Tiền mặt (F39)</div>
                                    <div class="fw-bold text-dark fs-6">0 đ <span class="badge badge-soft-blue ms-1">0%</span></div>
                                </div>
                                <i class="bi bi-cash-stack fs-3 text-primary"></i>
                            </div>
                        </div>
                        <div class="col-sm-6">
                            <div class="p-3 rounded-3 border bg-light d-flex justify-content-between align-items-center">
                                <div>
                                    <div class="text-muted small">Chuyển khoản QR (F40)</div>
                                    <div class="fw-bold text-primary fs-6">0 đ <span class="badge badge-soft-blue ms-1">0%</span></div>
                                </div>
                                <i class="bi bi-qr-code-scan fs-3 text-primary"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Cột phải: Top Món bán chạy nhất (F55) -->
        <div class="col-12 col-lg-5">
            <div class="card-custom h-100">
                <div class="card-header-custom">
                    <div>
                        <h6 class="fw-bold mb-0 text-dark"><i class="bi bi-trophy-fill text-primary me-2"></i>Top đồ uống bán chạy nhất (F55)</h6>
                        <small class="text-muted">Thống kê số lượng tiêu thụ cao nhất</small>
                    </div>
                    <a href="DoUong.aspx" class="btn btn-sm btn-cafe-outline">Xem Menu</a>
                </div>
                <div class="p-0">
                    <table class="table table-cafe">
                        <thead>
                            <tr>
                                <th>Hạng</th>
                                <th>Tên đồ uống</th>
                                <th class="text-center">Đã bán</th>
                                <th class="text-end">Doanh thu</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td colspan="4" class="text-center text-muted py-5">
                                    <i class="bi bi-inbox fs-2 d-block text-secondary mb-1 opacity-50"></i>
                                    <div class="fw-semibold">Chưa có dữ liệu đồ uống bán chạy</div>
                                    <small class="text-muted">Dữ liệu sẽ tự động tổng hợp khi phát sinh hóa đơn</small>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <!-- PHÂN CHIA ĐẶC TẢ 5 THÀNH VIÊN NHÓM 9 (MỤC 5 TRONG FILE DOCX) -->
    <div class="card-custom">
        <div class="card-header-custom">
            <div>
                <h6 class="fw-bold mb-0 text-dark"><i class="bi bi-diagram-3-fill text-primary me-2"></i>Phân chia đặc tả dự án - Nhóm 9 (Theo tài liệu đặc tả)</h6>
                <small class="text-muted">Điểm điều hướng nhanh tới các phân hệ giao diện của từng thành viên</small>
            </div>
            <span class="badge badge-soft-blue">5 Thành viên</span>
        </div>
        <div class="table-responsive">
            <table class="table table-cafe">
                <thead>
                    <tr>
                        <th>Thành viên</th>
                        <th>Phân hệ phụ trách</th>
                        <th>Mã chức năng</th>
                        <th>Trạng thái Giao diện</th>
                        <th class="text-end">Truy cập nhanh</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td class="fw-bold text-primary"><i class="bi bi-person-badge me-2"></i>Nguyễn Anh Kỳ</td>
                        <td>Quản lý đồ uống và danh mục Menu</td>
                        <td><span class="badge badge-soft-blue">F06 → F13</span></td>
                        <td><span class="badge badge-soft-success">Hoàn tất UI</span></td>
                        <td class="text-end"><a href="DoUong.aspx" class="btn btn-sm btn-cafe-outline">Mở giao diện <i class="bi bi-arrow-right"></i></a></td>
                    </tr>
                    <tr>
                        <td class="fw-bold text-primary"><i class="bi bi-person-badge me-2"></i>Lư Quốc Thắng</td>
                        <td>Quản lý bàn, khu vực và đặt bàn trước</td>
                        <td><span class="badge badge-soft-blue">F14 → F26</span></td>
                        <td><span class="badge badge-soft-success">Hoàn tất UI</span></td>
                        <td class="text-end"><a href="BanVaDatBan.aspx" class="btn btn-sm btn-cafe-outline">Mở giao diện <i class="bi bi-arrow-right"></i></a></td>
                    </tr>
                    <tr>
                        <td class="fw-bold text-primary"><i class="bi bi-person-badge me-2"></i>Lê Văn Điều</td>
                        <td>Gọi món (POS), đơn hàng và thanh toán hóa đơn</td>
                        <td><span class="badge badge-soft-blue">F27 → F44</span></td>
                        <td><span class="badge badge-soft-success">Hoàn tất UI</span></td>
                        <td class="text-end"><a href="GoiMonThanhToan.aspx" class="btn btn-sm btn-cafe-outline">Mở giao diện <i class="bi bi-arrow-right"></i></a></td>
                    </tr>
                    <tr>
                        <td class="fw-bold text-primary"><i class="bi bi-person-badge me-2"></i>Nguyễn Nhật Anh</td>
                        <td>Tài khoản, phân quyền, nhân viên và thống kê doanh thu</td>
                        <td><span class="badge badge-soft-blue">F01 → F05, F45 → F58</span></td>
                        <td><span class="badge badge-soft-success">Hoàn tất UI</span></td>
                        <td class="text-end"><a href="NhanVienTaiKhoan.aspx" class="btn btn-sm btn-cafe-outline">Mở giao diện <i class="bi bi-arrow-right"></i></a></td>
                    </tr>
                    <tr>
                        <td class="fw-bold text-primary"><i class="bi bi-person-badge me-2"></i>Mẫn Vinh</td>
                        <td>Kiểm thử (Test), nghiệm thu quy tắc nghiệp vụ & báo lỗi</td>
                        <td><span class="badge badge-soft-blue">NF01 → NF08</span></td>
                        <td><span class="badge badge-soft-success">Hoàn tất UI</span></td>
                        <td class="text-end"><a href="KiemThuNghiemThu.aspx" class="btn btn-sm btn-cafe-outline">Mở giao diện <i class="bi bi-arrow-right"></i></a></td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
</asp:Content>
