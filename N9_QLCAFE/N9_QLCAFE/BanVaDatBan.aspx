<%@ Page Title="Quản lý Bàn & Đặt bàn" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="BanVaDatBan.aspx.cs" Inherits="N9_QLCAFE.BanVaDatBan" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <!-- HEADER -->
    <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 gap-3">
        <div>
            <span class="badge badge-soft-blue mb-1">Phân hệ F14 - F26 • Phụ trách: Lư Quốc Thắng</span>
            <h4 class="fw-bold mb-0 text-dark">Quản lý Bàn, Khu vực & Đặt bàn trước</h4>
        </div>
        <div class="d-flex flex-wrap gap-2">
            <button type="button" class="btn btn-cafe-outline" data-bs-toggle="modal" data-bs-target="#modalKhuVuc">
                <i class="bi bi-layers me-1"></i>Quản lý Khu vực (F17)
            </button>
            <button type="button" class="btn btn-cafe-outline" data-bs-toggle="modal" data-bs-target="#modalChuyenBan">
                <i class="bi bi-arrow-left-right me-1"></i>Chuyển bàn (F19)
            </button>
            <button type="button" class="btn btn-cafe-outline" data-bs-toggle="modal" data-bs-target="#modalThemBan">
                <i class="bi bi-plus-square me-1"></i>Thêm bàn (F14)
            </button>
            <button type="button" class="btn btn-cafe-primary" data-bs-toggle="modal" data-bs-target="#modalTaoDatBan">
                <i class="bi bi-calendar-plus me-1"></i>Tạo đặt bàn mới (F21)
            </button>
        </div>
    </div>

    <!-- THỐNG KÊ NHANH TRẠNG THÁI BÀN (F18) -->
    <div class="row g-3 mb-4">
        <div class="col-6 col-xl-3">
            <div class="stat-card">
                <div>
                    <div class="text-muted small fw-medium">Tổng số bàn hệ thống</div>
                    <h3 class="fw-bold my-1 text-dark">0 bàn</h3>
                    <div class="small text-muted">0 Khu vực phục vụ</div>
                </div>
                <div class="stat-icon">
                    <i class="bi bi-grid-3x3-gap"></i
                </div>
            </div>
        </div>
        <div class="col-6 col-xl-3">
            <div class="stat-card">
                <div>
                    <div class="text-muted small fw-medium">Bàn đang trống</div>
                    <h3 class="fw-bold my-1 text-success">0 bàn</h3>
                    <div class="small text-muted">Chưa có bàn</div>
                </div>
                <div class="stat-icon">
                    <i class="bi bi-check2-circle"></i>
                </div>
            </div>
        </div>
        <div class="col-6 col-xl-3">
            <div class="stat-card stat-card-primary">
                <div>
                    <div class="small opacity-75 fw-medium">Bàn đang sử dụng</div>
                    <h3 class="fw-bold my-1">0 bàn</h3>
                    <div class="small opacity-75">Chưa có đơn phục vụ</div>
                </div>
                <div class="stat-icon">
                    <i class="bi bi-people-fill"></i>
                </div>
            </div>
        </div>
        <div class="col-6 col-xl-3">
            <div class="stat-card">
                <div>
                    <div class="text-muted small fw-medium">Bàn đã đặt trước (F26)</div>
                    <h3 class="fw-bold my-1 text-primary">0 bàn</h3>
                    <div class="small text-muted">Chưa có lịch hẹn</div>
                </div>
                <div class="stat-icon">
                    <i class="bi bi-calendar-event"></i>
                </div>
            </div>
        </div>
    </div>

    <!-- THANH ĐIỀU HƯỚNG TAB: SƠ ĐỒ BÀN (F14-F20) & QUẢN LÝ ĐẶT BÀN (F21-F26) -->
    <div class="card-custom p-3 mb-4">
        <div class="d-flex flex-wrap justify-content-between align-items-center gap-3">
            <ul class="nav nav-pills nav-pills-blue" role="tablist">
                <li class="nav-item" role="presentation">
                    <button class="nav-link active" data-bs-toggle="tab" data-bs-target="#tabSoDoBan" type="button">
                        <i class="bi bi-grid-fill me-1"></i>Sơ đồ & Trạng thái Bàn (F18)
                    </button>
                </li>
                <li class="nav-item" role="presentation">
                    <button class="nav-link" data-bs-toggle="tab" data-bs-target="#tabLichDatBan" type="button">
                        <i class="bi bi-calendar-week me-1"></i>Lịch Đặt bàn & Tra cứu (F25, F26)
                    </button>
                </li>
            </ul>

            <!-- Tìm kiếm bàn theo mã hoặc khu vực (F20) -->
            <div class="d-flex flex-wrap align-items-center gap-2">
                <div class="input-group input-group-sm" style="width: 230px;">
                    <span class="input-group-text bg-light text-primary border-end-0"><i class="bi bi-search"></i></span>
                    <input type="text" class="form-control border-start-0" placeholder="Tìm mã bàn, tên khách (F20)..." />
                </div>
                <select class="form-select form-select-sm" style="width: 175px;">
                    <option selected>-- Tất cả khu vực (F17) --</option>
                    <option>KV01 - Tầng 1 (Máy lạnh)</option>
                    <option>KV02 - Tầng 2 (Ban công)</option>
                    <option>KV03 - Sân vườn</option>
                </select>
                <select class="form-select form-select-sm" style="width: 155px;">
                    <option selected>-- Mọi trạng thái --</option>
                    <option>Trống</option>
                    <option>Đang sử dụng</option>
                    <option>Đã đặt trước</option>
                </select>
            </div>
        </div>
    </div>

    <div class="tab-content">
        <!-- TAB 1: SƠ ĐỒ BÀN TRỰC QUAN (F14 - F20) -->
        <div class="tab-pane fade show active" id="tabSoDoBan" role="tabpanel">
            <div class="card-custom p-4">
                <div class="d-flex flex-wrap justify-content-between align-items-center mb-3 pb-2 border-bottom">
                    <div>
                        <h6 class="fw-bold mb-0 text-dark">Sơ đồ bàn trực quan theo Khu vực (F17, F18)</h6>
                        <small class="text-muted">Quy tắc: Không xóa bàn đang có đơn chưa thanh toán • Khi thanh toán xong bàn tự chuyển về Trống</small>
                    </div>
                    <div class="d-flex gap-3 small fw-semibold">
                        <span><i class="bi bi-square-fill text-white border border-primary me-1"></i>Trống</span>
                        <span><i class="bi bi-square-fill text-primary me-1"></i>Đang sử dụng</span>
                        <span><i class="bi bi-bounding-box text-primary me-1"></i>Đã đặt trước</span>
                    </div>
                </div>

                <!-- Grid danh sách bàn -->
                <div class="row g-3">
                    <!-- Bàn B01: Đang sử dụng -->
                    <div class="col-12 col-sm-6 col-md-4 col-xl-3">
                        <div class="cafe-table-box table-occupied">
                            <div class="d-flex justify-content-between align-items-start mb-2">
                                <span class="badge bg-primary">B01 • Tầng 1</span>
                                <span class="badge badge-soft-blue">Đang sử dụng</span>
                            </div>
                            <h6 class="fw-bold mb-1 text-dark">Bàn 01 (4 ghế)</h6>
                            <div class="small text-primary fw-semibold mb-2">
                                <i class="bi bi-receipt me-1"></i>Đơn: #DH1024 • 138.000 đ
                            </div>
                            <div class="small text-muted mb-3">
                                <i class="bi bi-clock me-1"></i>Vào lúc: 13:45 (45 phút)
                            </div>
                            <div class="d-flex justify-content-between gap-1 pt-2 border-top border-primary border-opacity-25">
                                <a href="GoiMonThanhToan.aspx" class="btn btn-sm btn-cafe-primary flex-grow-1">Gọi thêm / Thu tiền</a>
                                <button type="button" class="btn btn-sm btn-cafe-outline" data-bs-toggle="modal" data-bs-target="#modalChuyenBan" title="Chuyển bàn (F19)">
                                    <i class="bi bi-arrow-left-right"></i>
                                </button>
                                <button type="button" class="btn btn-sm btn-cafe-outline" data-bs-toggle="modal" data-bs-target="#modalThemBan" title="Sửa bàn (F15)">
                                    <i class="bi bi-pencil"></i>
                                </button>
                            </div>
                        </div>
                    </div>

                    <!-- Bàn B02: Trống -->
                    <div class="col-12 col-sm-6 col-md-4 col-xl-3">
                        <div class="cafe-table-box table-empty">
                            <div class="d-flex justify-content-between align-items-start mb-2">
                                <span class="badge badge-soft-blue">B02 • Tầng 1</span>
                                <span class="badge badge-soft-success">Trống</span>
                            </div>
                            <h6 class="fw-bold mb-1 text-dark">Bàn 02 (2 ghế)</h6>
                            <div class="small text-muted mb-2">
                                <i class="bi bi-check2-circle me-1"></i>Bàn chưa có khách
                            </div>
                            <div class="small text-muted mb-3">
                                <i class="bi bi-geo-alt me-1"></i>Khu vực máy lạnh - Cửa sổ
                            </div>
                            <div class="d-flex justify-content-between gap-1 pt-2 border-top">
                                <a href="GoiMonThanhToan.aspx" class="btn btn-sm btn-cafe-outline flex-grow-1">Mở bàn gọi món</a>
                                <button type="button" class="btn btn-sm btn-cafe-outline" data-bs-toggle="modal" data-bs-target="#modalThemBan" title="Sửa bàn (F15)">
                                    <i class="bi bi-pencil"></i>
                                </button>
                                <button type="button" class="btn btn-sm btn-outline-danger" title="Xóa bàn chưa phát sinh GD (F16)">
                                    <i class="bi bi-trash"></i>
                                </button>
                            </div>
                        </div>
                    </div>

                    <!-- Bàn B03: Đã đặt trước -->
                    <div class="col-12 col-sm-6 col-md-4 col-xl-3">
                        <div class="cafe-table-box table-reserved">
                            <div class="d-flex justify-content-between align-items-start mb-2">
                                <span class="badge badge-soft-blue">B03 • Tầng 1</span>
                                <span class="badge badge-soft-warning">Đã đặt trước</span>
                            </div>
                            <h6 class="fw-bold mb-1 text-dark">Bàn 03 (6 ghế)</h6>
                            <div class="small text-primary fw-semibold mb-2">
                                <i class="bi bi-person-check me-1"></i>Khách: Trần Minh Tâm (5 người)
                            </div>
                            <div class="small text-muted mb-3">
                                <i class="bi bi-alarm me-1"></i>Giờ hẹn: 15:30 hôm nay (#DB012)
                            </div>
                            <div class="d-flex justify-content-between gap-1 pt-2 border-top">
                                <a href="GoiMonThanhToan.aspx" class="btn btn-sm btn-cafe-primary flex-grow-1">Khách đến • Nhận bàn</a>
                                <button type="button" class="btn btn-sm btn-cafe-outline" data-bs-toggle="modal" data-bs-target="#modalTaoDatBan" title="Sửa đặt bàn (F22)">
                                    <i class="bi bi-pencil"></i>
                                </button>
                            </div>
                        </div>
                    </div>

                    <!-- Bàn B04: Đang sử dụng -->
                    <div class="col-12 col-sm-6 col-md-4 col-xl-3">
                        <div class="cafe-table-box table-occupied">
                            <div class="d-flex justify-content-between align-items-start mb-2">
                                <span class="badge bg-primary">B04 • Tầng 1</span>
                                <span class="badge badge-soft-blue">Đang sử dụng</span>
                            </div>
                            <h6 class="fw-bold mb-1 text-dark">Bàn 04 (4 ghế)</h6>
                            <div class="small text-primary fw-semibold mb-2">
                                <i class="bi bi-receipt me-1"></i>Đơn: #DH1025 • 93.000 đ
                            </div>
                            <div class="small text-muted mb-3">
                                <i class="bi bi-clock me-1"></i>Vào lúc: 14:10 (20 phút)
                            </div>
                            <div class="d-flex justify-content-between gap-1 pt-2 border-top border-primary border-opacity-25">
                                <a href="GoiMonThanhToan.aspx" class="btn btn-sm btn-cafe-primary flex-grow-1">Gọi thêm / Thu tiền</a>
                                <button type="button" class="btn btn-sm btn-cafe-outline" data-bs-toggle="modal" data-bs-target="#modalChuyenBan" title="Chuyển bàn (F19)">
                                    <i class="bi bi-arrow-left-right"></i>
                                </button>
                                <button type="button" class="btn btn-sm btn-cafe-outline" data-bs-toggle="modal" data-bs-target="#modalThemBan" title="Sửa bàn (F15)">
                                    <i class="bi bi-pencil"></i>
                                </button>
                            </div>
                        </div>
                    </div>

                    <!-- Bàn B05: Trống -->
                    <div class="col-12 col-sm-6 col-md-4 col-xl-3">
                        <div class="cafe-table-box table-empty">
                            <div class="d-flex justify-content-between align-items-start mb-2">
                                <span class="badge badge-soft-blue">B05 • Tầng 2</span>
                                <span class="badge badge-soft-success">Trống</span>
                            </div>
                            <h6 class="fw-bold mb-1 text-dark">Bàn 05 (4 ghế)</h6>
                            <div class="small text-muted mb-2">
                                <i class="bi bi-check2-circle me-1"></i>Bàn chưa có khách
                            </div>
                            <div class="small text-muted mb-3">
                                <i class="bi bi-geo-alt me-1"></i>Ban công thoáng mát
                            </div>
                            <div class="d-flex justify-content-between gap-1 pt-2 border-top">
                                <a href="GoiMonThanhToan.aspx" class="btn btn-sm btn-cafe-outline flex-grow-1">Mở bàn gọi món</a>
                                <button type="button" class="btn btn-sm btn-cafe-outline" data-bs-toggle="modal" data-bs-target="#modalThemBan">
                                    <i class="bi bi-pencil"></i>
                                </button>
                                <button type="button" class="btn btn-sm btn-outline-danger">
                                    <i class="bi bi-trash"></i>
                                </button>
                            </div>
                        </div>
                    </div>

                    <!-- Bàn B06: Đã đặt trước -->
                    <div class="col-12 col-sm-6 col-md-4 col-xl-3">
                        <div class="cafe-table-box table-reserved">
                            <div class="d-flex justify-content-between align-items-start mb-2">
                                <span class="badge badge-soft-blue">B06 • Tầng 2</span>
                                <span class="badge badge-soft-warning">Đã đặt trước</span>
                            </div>
                            <h6 class="fw-bold mb-1 text-dark">Bàn 06 (8 ghế VIP)</h6>
                            <div class="small text-primary fw-semibold mb-2">
                                <i class="bi bi-person-check me-1"></i>Khách: Lê Hoàng Nam (7 người)
                            </div>
                            <div class="small text-muted mb-3">
                                <i class="bi bi-alarm me-1"></i>Giờ hẹn: 18:00 hôm nay (#DB014)
                            </div>
                            <div class="d-flex justify-content-between gap-1 pt-2 border-top">
                                <a href="GoiMonThanhToan.aspx" class="btn btn-sm btn-cafe-primary flex-grow-1">Khách đến • Nhận bàn</a>
                                <button type="button" class="btn btn-sm btn-cafe-outline" data-bs-toggle="modal" data-bs-target="#modalTaoDatBan">
                                    <i class="bi bi-pencil"></i>
                                </button>
                            </div>
                        </div>
                    </div>

                    <!-- Bàn B07: Đang sử dụng -->
                    <div class="col-12 col-sm-6 col-md-4 col-xl-3">
                        <div class="cafe-table-box table-occupied">
                            <div class="d-flex justify-content-between align-items-start mb-2">
                                <span class="badge bg-primary">B07 • Sân vườn</span>
                                <span class="badge badge-soft-blue">Đang sử dụng</span>
                            </div>
                            <h6 class="fw-bold mb-1 text-dark">Bàn 07 (4 ghế)</h6>
                            <div class="small text-primary fw-semibold mb-2">
                                <i class="bi bi-receipt me-1"></i>Đơn: #DH1026 • 165.000 đ
                            </div>
                            <div class="small text-muted mb-3">
                                <i class="bi bi-clock me-1"></i>Vào lúc: 14:15 (15 phút)
                            </div>
                            <div class="d-flex justify-content-between gap-1 pt-2 border-top border-primary border-opacity-25">
                                <a href="GoiMonThanhToan.aspx" class="btn btn-sm btn-cafe-primary flex-grow-1">Gọi thêm / Thu tiền</a>
                                <button type="button" class="btn btn-sm btn-cafe-outline" data-bs-toggle="modal" data-bs-target="#modalChuyenBan">
                                    <i class="bi bi-arrow-left-right"></i>
                                </button>
                                <button type="button" class="btn btn-sm btn-cafe-outline" data-bs-toggle="modal" data-bs-target="#modalThemBan">
                                    <i class="bi bi-pencil"></i>
                                </button>
                            </div>
                        </div>
                    </div>

                    <!-- Bàn B08: Trống -->
                    <div class="col-12 col-sm-6 col-md-4 col-xl-3">
                        <div class="cafe-table-box table-empty">
                            <div class="d-flex justify-content-between align-items-start mb-2">
                                <span class="badge badge-soft-blue">B08 • Sân vườn</span>
                                <span class="badge badge-soft-success">Trống</span>
                            </div>
                            <h6 class="fw-bold mb-1 text-dark">Bàn 08 (4 ghế)</h6>
                            <div class="small text-muted mb-2">
                                <i class="bi bi-check2-circle me-1"></i>Bàn chưa có khách
                            </div>
                            <div class="small text-muted mb-3">
                                <i class="bi bi-geo-alt me-1"></i>Khu vực ngoài trời
                            </div>
                            <div class="d-flex justify-content-between gap-1 pt-2 border-top">
                                <a href="GoiMonThanhToan.aspx" class="btn btn-sm btn-cafe-outline flex-grow-1">Mở bàn gọi món</a>
                                <button type="button" class="btn btn-sm btn-cafe-outline" data-bs-toggle="modal" data-bs-target="#modalThemBan">
                                    <i class="bi bi-pencil"></i>
                                </button>
                                <button type="button" class="btn btn-sm btn-outline-danger">
                                    <i class="bi bi-trash"></i>
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- TAB 2: DANH SÁCH & LỊCH ĐẶT BÀN TRƯỚC (F21 - F26) -->
        <div class="tab-pane fade" id="tabLichDatBan" role="tabpanel">
            <div class="card-custom">
                <div class="card-header-custom flex-wrap gap-2">
                    <div>
                        <h6 class="fw-bold mb-0 text-dark">Danh sách Lịch đặt bàn theo ngày (F25, F26)</h6>
                        <small class="text-muted">Quy tắc: Số lượng khách &gt; 0 • Không trùng lịch trên cùng 1 bàn • Khách đến chuyển thành đơn phục vụ hoặc đánh dấu No-show</small>
                    </div>
                    <div class="d-flex align-items-center gap-2">
                        <input type="date" class="form-control form-control-sm" value="2026-11-09" style="width: 145px;" />
                        <button type="button" class="btn btn-sm btn-cafe-primary" data-bs-toggle="modal" data-bs-target="#modalTaoDatBan">
                            <i class="bi bi-plus-lg me-1"></i>Thêm lịch đặt (F21)
                        </button>
                    </div>
                </div>
                <div class="table-responsive">
                    <table class="table table-cafe">
                        <thead>
                            <tr>
                                <th>Mã ĐB</th>
                                <th>Khách hàng & SĐT</th>
                                <th>Ngày & Giờ đến</th>
                                <th class="text-center">Số khách</th>
                                <th>Bàn đặt</th>
                                <th>Ghi chú</th>
                                <th>Trạng thái</th>
                                <th class="text-end">Thao tác (F22 - F24)</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td colspan="8" class="text-center text-muted py-5">
                                    <i class="bi bi-calendar2-x fs-1 d-block text-secondary mb-2 opacity-50"></i>
                                    <div class="fw-semibold">Chưa có lịch đặt bàn nào</div>
                                    <small class="text-muted">Nhấn "Thêm lịch đặt" để tạo đặt bàn cho khách</small>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <!-- MODAL THÊM / SỬA BÀN (F14, F15) -->
    <div class="modal fade" id="modalThemBan" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow">
                <div class="modal-header bg-primary text-white">
                    <h6 class="modal-title fw-bold"><i class="bi bi-grid-3x3-gap me-2"></i>Thông tin Bàn phục vụ (F14 / F15)</h6>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body p-4">
                    <div class="row g-3">
                        <div class="col-md-5">
                            <label class="form-label small fw-semibold">Mã định danh bàn <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" placeholder="VD: B01" placeholder="VD: B09" />
                        </div>
                        <div class="col-md-7">
                            <label class="form-label small fw-semibold">Tên hiển thị bàn <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" placeholder="VD: Bàn 09 (Cạnh cửa sổ)" />
                        </div>
                        <div class="col-md-6">
                            <label class="form-label small fw-semibold">Khu vực / Tầng (F17) <span class="text-danger">*</span></label>
                            <select class="form-select">
                                <option selected>KV01 - Tầng 1 (Máy lạnh)</option>
                                <option>KV02 - Tầng 2 (Ban công)</option>
                                <option>KV03 - Sân vườn</option>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label small fw-semibold">Sức chứa (Số ghế)</label>
                            <input type="number" class="form-control" value="2" min="1" />
                        </div>
                        <div class="col-12">
                            <label class="form-label small fw-semibold">Trạng thái bàn (F18)</label>
                            <select class="form-select">
                                <option selected>Trống (Chưa có khách)</option>
                                <option>Đang sử dụng (Đang có khách)</option>
                                <option>Đã đặt trước</option>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="modal-footer bg-light">
                    <button type="button" class="btn btn-sm btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="button" class="btn btn-sm btn-cafe-primary" data-bs-dismiss="modal">Lưu thông tin bàn</button>
                </div>
            </div>
        </div>
    </div>

    <!-- MODAL CHUYỂN BÀN (F19 / F34) -->
    <div class="modal fade" id="modalChuyenBan" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow">
                <div class="modal-header bg-primary text-white">
                    <h6 class="modal-title fw-bold"><i class="bi bi-arrow-left-right me-2"></i>Chuyển khách sang bàn khác (F19 / F34)</h6>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body p-4">
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Bàn hiện tại (Đang có khách)</label>
                        <select class="form-select">
                            <option selected>-- Chọn bàn đang có khách cần chuyển --</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Chuyển sang bàn trống <span class="text-danger">*</span></label>
                        <select class="form-select">
                            <option selected>-- Chọn bàn trống muốn chuyển tới --</option>
                        </select>
                    </div>
                    <div class="mb-0">
                        <label class="form-label small fw-semibold">Lý do chuyển bàn / Ghi chú</label>
                        <input type="text" class="form-control" placeholder="VD: Khách muốn đổi sang khu vực yên tĩnh hơn..." />
                    </div>
                </div>
                <div class="modal-footer bg-light">
                    <button type="button" class="btn btn-sm btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="button" class="btn btn-sm btn-cafe-primary" data-bs-dismiss="modal">Xác nhận chuyển bàn</button>
                </div>
            </div>
        </div>
    </div>

    <!-- MODAL QUẢN LÝ KHU VỰC (F17) -->
    <div class="modal fade" id="modalKhuVuc" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow">
                <div class="modal-header bg-primary text-white">
                    <h6 class="modal-title fw-bold"><i class="bi bi-layers me-2"></i>Quản lý Khu vực & Tầng (F17)</h6>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body p-4">
                    <div class="input-group mb-3">
                        <input type="text" class="form-control" placeholder="Nhập tên khu vực hoặc tầng mới..." />
                        <button class="btn btn-cafe-primary" type="button"><i class="bi bi-plus-lg"></i> Thêm</button>
                    </div>
                    <table class="table table-sm table-cafe border">
                        <thead>
                            <tr>
                                <th>Mã KV</th>
                                <th>Tên khu vực</th>
                                <th class="text-center">Số bàn</th>
                                <th class="text-end">Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td colspan="4" class="text-center text-muted py-3">
                                    <small>Chưa có khu vực nào. Hãy nhập tên khu vực và nhấn Thêm.</small>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <!-- MODAL TẠO / SỬA ĐẶT BÀN TRƯỚC (F21, F22) -->
    <div class="modal fade" id="modalTaoDatBan" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg modal-dialog-centered">
            <div class="modal-content border-0 shadow">
                <div class="modal-header bg-primary text-white">
                    <h6 class="modal-title fw-bold"><i class="bi bi-calendar-plus me-2"></i>Phiếu Đặt bàn trước (F21 / F22)</h6>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body p-4">
                    <div class="row g-3">
                        <div class="col-md-4">
                            <label class="form-label small fw-semibold">Mã đặt bàn</label>
                            <input type="text" class="form-control bg-light" placeholder="Hệ thống tự cấp..." readonly />
                        </div>
                        <div class="col-md-4">
                            <label class="form-label small fw-semibold">Tên khách hàng <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" placeholder="Nhập họ tên khách..." />
                        </div>
                        <div class="col-md-4">
                            <label class="form-label small fw-semibold">Số điện thoại <span class="text-danger">*</span></label>
                            <input type="tel" class="form-control" placeholder="VD: 0909xxxxxx" />
                        </div>
                        <div class="col-md-4">
                            <label class="form-label small fw-semibold">Ngày đặt <span class="text-danger">*</span></label>
                            <input type="date" class="form-control" value="2026-11-09" />
                        </div>
                        <div class="col-md-4">
                            <label class="form-label small fw-semibold">Giờ đến dự kiến <span class="text-danger">*</span></label>
                            <input type="time" class="form-control" value="" />
                        </div>
                        <div class="col-md-4">
                            <label class="form-label small fw-semibold">Số lượng khách (&gt; 0) <span class="text-danger">*</span></label>
                            <input type="number" class="form-control" value="2" min="1" />
                        </div>
                        <div class="col-md-6">
                            <label class="form-label small fw-semibold">Chọn bàn còn trống phù hợp <span class="text-danger">*</span></label>
                            <select class="form-select">
                                <option selected>B02 - Tầng 1 (Trống • 2-4 ghế)</option>
                                <option>B05 - Tầng 2 (Trống • 4 ghế)</option>
                                <option>B08 - Sân vườn (Trống • 4 ghế)</option>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label small fw-semibold">Trạng thái đặt bàn (F24)</label>
                            <select class="form-select">
                                <option selected>Đã xác nhận</option>
                                <option>Chờ xác nhận</option>
                                <option>Khách đã nhận bàn</option>
                                <option>Đã hủy / No-show (F23)</option>
                            </select>
                        </div>
                        <div class="col-12">
                            <label class="form-label small fw-semibold">Ghi chú yêu cầu của khách</label>
                            <textarea class="form-control" rows="2" placeholder="VD: Cần ghế trẻ em, góc yên tĩnh..."></textarea>
                        </div>
                    </div>
                </div>
                <div class="modal-footer bg-light">
                    <button type="button" class="btn btn-sm btn-secondary" data-bs-dismiss="modal">Đóng</button>
                    <button type="button" class="btn btn-sm btn-cafe-primary" data-bs-dismiss="modal"><i class="bi bi-check2-circle me-1"></i>Lưu & Xác nhận đặt bàn</button>
                </div>
            </div>
        </div>
    </div>
</asp:Content>

