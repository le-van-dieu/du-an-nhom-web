<%@ Page Title="Quản lý Bàn & Đặt bàn" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="BanVaDatBan.aspx.cs" Inherits="N9_QLCAFE.BanVaDatBan" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        /* CSS Tùy biến chuẩn SaaS Dashboard */
        :root {
            --cafe-primary: #1e3a8a;
            --cafe-accent: #3b82f6;
            --success-soft: #ecfdf5;
            --success-text: #059669;
            --warning-soft: #fffbeb;
            --warning-text: #b45309;
            --info-soft: #eff6ff;
            --info-text: #1d4ed8;
        }

        .page-header-title {
            letter-spacing: -0.02em;
        }

        /* Thẻ thống kê KPI */
        .stat-card-pro {
            background: #ffffff;
            border-radius: 14px;
            border: 1px solid #e2e8f0;
            padding: 20px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            box-shadow: 0 1px 3px rgba(0,0,0,0.02);
            transition: transform 0.2s, box-shadow 0.2s;
        }
        .stat-card-pro:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(0,0,0,0.05);
        }
        .stat-icon-pro {
            width: 52px;
            height: 52px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
        }

        /* Khối Khu Vực (Cấp 1) */
        .zone-wrapper {
            background: #ffffff;
            border-radius: 16px;
            border: 1px solid #e2e8f0;
            margin-bottom: 24px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.02);
            overflow: hidden;
        }
        .zone-header-pro {
            background: linear-gradient(180deg, #ffffff 0%, #f8fafc 100%);
            border-bottom: 1px solid #e2e8f0;
            padding: 16px 24px;
        }

        /* Card Bàn Ăn (Cấp 2) */
        .table-item-card {
            border-radius: 12px;
            border: 1.5px solid #e2e8f0;
            background: #ffffff;
            padding: 16px;
            position: relative;
            transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1);
            overflow: hidden;
        }
        .table-item-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 25px rgba(0,0,0,0.06);
        }
        
        /* Dải viền màu trạng thái tinh tế ở đỉnh */
        .table-item-card::before {
            content: "";
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
        }
        .table-state-empty::before { background-color: #10b981; }
        .table-state-occupied::before { background-color: #2563eb; }
        .table-state-reserved::before { background-color: #f59e0b; }

        /* Soft Badge cho trạng thái */
        .badge-soft-empty { background: var(--success-soft); color: var(--success-text); border: 1px solid #a7f3d0; }
        .badge-soft-occupied { background: var(--info-soft); color: var(--info-text); border: 1px solid #bfdbfe; }
        .badge-soft-reserved { background: var(--warning-soft); color: var(--warning-text); border: 1px solid #fde68a; }

        /* Nút hành động nhanh trên bàn */
        .btn-action-light {
            background: #f8fafc;
            border: 1px solid #e2e8f0;
            color: #475569;
            font-weight: 500;
        }
        .btn-action-light:hover {
            background: #e2e8f0;
            color: #0f172a;
        }

        .filter-container {
            background: #ffffff;
            border-radius: 14px;
            border: 1px solid #e2e8f0;
            padding: 12px 20px;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    
    <!-- 1. TIÊU ĐỀ TRANG VÀ CÁC NÚT TÁC VỤ CHÍNH -->
    <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 gap-3">
        <div>
            <div class="d-flex align-items-center gap-2 mb-1">
                <span class="badge bg-primary-subtle text-primary border border-primary-subtle px-2 py-1 fw-semibold">
                    <i class="bi bi-shield-check me-1"></i>Phân hệ Quản Lý F14 - F26
                </span>
                <span class="text-secondary small">• Phụ trách: Lư Quốc Thắng</span>
            </div>
            <h3 class="fw-bold text-dark page-header-title mb-0">Sơ Đồ Bàn & Điều Phối Đặt Bàn</h3>
        </div>
        <div class="d-flex flex-wrap gap-2">
            <button type="button" class="btn btn-outline-secondary rounded-3" data-bs-toggle="modal" data-bs-target="#modalKhuVuc">
                <i class="bi bi-layers me-1 text-primary"></i>Khu vực (F17)
            </button>
            <button type="button" class="btn btn-outline-secondary rounded-3" data-bs-toggle="modal" data-bs-target="#modalChuyenBan">
                <i class="bi bi-arrow-left-right me-1 text-warning"></i>Chuyển bàn (F19)
            </button>
            <button type="button" class="btn btn-outline-primary rounded-3" data-bs-toggle="modal" data-bs-target="#modalThemBan">
                <i class="bi bi-plus-square me-1"></i>Thêm bàn (F14)
            </button>
            <button type="button" class="btn btn-primary rounded-3 shadow-sm px-3" data-bs-toggle="modal" data-bs-target="#modalTaoDatBan">
                <i class="bi bi-calendar-plus me-1"></i>Tạo đặt bàn mới (F21)
            </button>
        </div>
    </div>

    <!-- 2. THẺ CHỈ SỐ KPI TỔNG THỂ -->
    <div class="row g-3 mb-4">
        <div class="col-6 col-xl-3">
            <div class="stat-card-pro">
                <div>
                    <span class="text-muted small fw-medium">Tổng số bàn quán</span>
                    <h2 class="fw-bold my-1 text-dark">8</h2>
                    <span class="badge bg-light text-secondary border">3 Khu vực trực thuộc</span>
                </div>
                <div class="stat-icon-pro bg-light text-secondary">
                    <i class="bi bi-grid-3x3-gap-fill"></i>
                </div>
            </div>
        </div>
        <div class="col-6 col-xl-3">
            <div class="stat-card-pro">
                <div>
                    <span class="text-muted small fw-medium">Bàn sẵn sàng (Trống)</span>
                    <h2 class="fw-bold my-1 text-success">3</h2>
                    <span class="small text-success fw-medium"><i class="bi bi-check-circle me-1"></i>Có thể đón khách</span>
                </div>
                <div class="stat-icon-pro bg-success-subtle text-success">
                    <i class="bi bi-cup-hot-fill"></i>
                </div>
            </div>
        </div>
        <div class="col-6 col-xl-3">
            <div class="stat-card-pro border-primary-subtle" style="background: linear-gradient(145deg, #ffffff, #eff6ff);">
                <div>
                    <span class="text-primary small fw-semibold">Bàn đang sử dụng</span>
                    <h2 class="fw-bold my-1 text-primary">3</h2>
                    <span class="small text-primary fw-medium"><i class="bi bi-people-fill me-1"></i>Đang phục vụ đơn</span>
                </div>
                <div class="stat-icon-pro bg-primary text-white shadow-sm">
                    <i class="bi bi-person-check-fill"></i>
                </div>
            </div>
        </div>
        <div class="col-6 col-xl-3">
            <div class="stat-card-pro">
                <div>
                    <span class="text-muted small fw-medium">Lịch đặt trước hôm nay</span>
                    <h2 class="fw-bold my-1 text-warning">2</h2>
                    <span class="small text-warning fw-medium"><i class="bi bi-clock-history me-1"></i>Chờ khách đến</span>
                </div>
                <div class="stat-icon-pro bg-warning-subtle text-warning">
                    <i class="bi bi-calendar-check-fill"></i>
                </div>
            </div>
        </div>
    </div>

    <!-- 3. THANH ĐIỀU HƯỚNG TAB & BỘ LỌC TÌM KIẾM -->
    <div class="filter-container mb-4 shadow-sm">
        <div class="d-flex flex-wrap justify-content-between align-items-center gap-3">
            <ul class="nav nav-pills gap-2" role="tablist">
                <li class="nav-item" role="presentation">
                    <button class="nav-link active rounded-pill px-3 py-2 fw-semibold" data-bs-toggle="tab" data-bs-target="#tabSoDoBan" type="button">
                        <i class="bi bi-diagram-3-fill me-1"></i>Sơ đồ trực quan 2 cấp
                    </button>
                </li>
                <li class="nav-item" role="presentation">
                    <button class="nav-link rounded-pill px-3 py-2 fw-semibold text-secondary" data-bs-toggle="tab" data-bs-target="#tabLichDatBan" type="button">
                        <i class="bi bi-calendar2-week-fill me-1"></i>Lịch hẹn đặt trước (F25, F26)
                    </button>
                </li>
            </ul>

            <div class="d-flex flex-wrap align-items-center gap-2">
                <div class="input-group" style="width: 250px;">
                    <span class="input-group-text bg-light border-end-0 text-muted"><i class="bi bi-search"></i></span>
                    <input type="text" class="form-control form-control-sm border-start-0" placeholder="Tìm theo tên bàn, số ghế..." />
                </div>
                <select class="form-select form-select-sm" style="width: 170px;">
                    <option selected>Tất cả khu vực</option>
                    <option>KV01 - Tầng 1 (Lạnh)</option>
                    <option>KV02 - Tầng 2 (Ban công)</option>
                    <option>KV03 - Sân vườn</option>
                </select>
                <select class="form-select form-select-sm" style="width: 150px;">
                    <option selected>Mọi trạng thái</option>
                    <option>Trống</option>
                    <option>Đang sử dụng</option>
                    <option>Đã đặt trước</option>
                </select>
            </div>
        </div>
    </div>

    <!-- NỘI DUNG CHÍNH (TAB CONTENT) -->
    <div class="tab-content">
        
        <!-- ======================================================== -->
        <!-- TAB 1: SƠ ĐỒ BÀN 2 CẤP (KHU VỰC CHA -> BÀN CON) -->
        <!-- ======================================================== -->
        <div class="tab-pane fade show active" id="tabSoDoBan" role="tabpanel">

            <!-- CẤP 1: KHU VỰC 01 (TẦNG 1) -->
            <div class="zone-wrapper">
                <div class="zone-header-pro d-flex flex-wrap justify-content-between align-items-center gap-2">
                    <div class="d-flex align-items-center gap-2">
                        <span class="p-2 bg-primary-subtle text-primary rounded-3"><i class="bi bi-snow2 fs-5"></i></span>
                        <div>
                            <h6 class="fw-bold mb-0 text-dark">Khu Vực 01: Tầng 1 • Máy Lạnh & Quầy Bar</h6>
                            <small class="text-muted">Không gian yên tĩnh làm việc • 4 bàn hiện hữu</small>
                        </div>
                    </div>
                    <div class="d-flex align-items-center gap-2">
                        <span class="badge badge-soft-empty rounded-pill px-2 py-1"><i class="bi bi-circle-fill small me-1"></i>1 Trống</span>
                        <span class="badge badge-soft-occupied rounded-pill px-2 py-1"><i class="bi bi-circle-fill small me-1"></i>2 Đang dùng</span>
                        <span class="badge badge-soft-reserved rounded-pill px-2 py-1"><i class="bi bi-circle-fill small me-1"></i>1 Đặt trước</span>
                    </div>
                </div>

                <!-- CẤP 2: DANH SÁCH BÀN TẦNG 1 -->
                <div class="p-4">
                    <div class="row g-3">
                        <!-- Bàn 01 (Đang sử dụng) -->
                        <div class="col-12 col-sm-6 col-md-4 col-xl-3">
                            <div class="table-item-card table-state-occupied">
                                <div class="d-flex justify-content-between align-items-center mb-2">
                                    <span class="badge bg-primary px-2 py-1">B01</span>
                                    <span class="badge badge-soft-occupied rounded-pill">Đang phục vụ</span>
                                </div>
                                <h6 class="fw-bold text-dark mb-1">Bàn 01 <span class="text-muted fw-normal small">(4 ghế)</span></h6>
                                <div class="p-2 rounded-3 bg-light my-2">
                                    <div class="d-flex justify-content-between small mb-1">
                                        <span class="text-secondary"><i class="bi bi-receipt me-1"></i>Hóa đơn:</span>
                                        <strong class="text-primary">#DH1024</strong>
                                    </div>
                                    <div class="d-flex justify-content-between small">
                                        <span class="text-secondary"><i class="bi bi-cash-stack me-1"></i>Tạm tính:</span>
                                        <strong class="text-danger">138.000 đ</strong>
                                    </div>
                                </div>
                                <div class="small text-muted mb-3 d-flex align-items-center">
                                    <i class="bi bi-stopwatch text-warning me-1"></i>Vào lúc: 13:45 (45 phút)
                                </div>
                                <div class="d-flex gap-1 pt-2 border-top">
                                    <a href="GoiMonThanhToan.aspx" class="btn btn-sm btn-primary flex-grow-1 fw-semibold"><i class="bi bi-receipt-cutoff me-1"></i>Thu tiền</a>
                                    <button type="button" class="btn btn-sm btn-action-light" data-bs-toggle="modal" data-bs-target="#modalChuyenBan" title="Chuyển bàn"><i class="bi bi-arrow-left-right"></i></button>
                                    <button type="button" class="btn btn-sm btn-action-light" data-bs-toggle="modal" data-bs-target="#modalThemBan" title="Sửa bàn"><i class="bi bi-pencil"></i></button>
                                </div>
                            </div>
                        </div>

                        <!-- Bàn 02 (Trống) -->
                        <div class="col-12 col-sm-6 col-md-4 col-xl-3">
                            <div class="table-item-card table-state-empty">
                                <div class="d-flex justify-content-between align-items-center mb-2">
                                    <span class="badge bg-secondary px-2 py-1">B02</span>
                                    <span class="badge badge-soft-empty rounded-pill">Trống</span>
                                </div>
                                <h6 class="fw-bold text-dark mb-1">Bàn 02 <span class="text-muted fw-normal small">(2 ghế)</span></h6>
                                <div class="p-2 rounded-3 bg-light my-2">
                                    <div class="small text-muted"><i class="bi bi-geo-alt me-1"></i>Cạnh cửa sổ lối vào</div>
                                    <div class="small text-success fw-medium"><i class="bi bi-check2-circle me-1"></i>Bàn sạch, sẵn sàng</div>
                                </div>
                                <div class="small text-muted mb-3">
                                    <i class="bi bi-info-circle me-1"></i>Chưa phát sinh order
                                </div>
                                <div class="d-flex gap-1 pt-2 border-top">
                                    <a href="GoiMonThanhToan.aspx" class="btn btn-sm btn-outline-success flex-grow-1 fw-semibold"><i class="bi bi-plus-circle me-1"></i>Mở gọi món</a>
                                    <button type="button" class="btn btn-sm btn-action-light" data-bs-toggle="modal" data-bs-target="#modalThemBan" title="Sửa bàn"><i class="bi bi-pencil"></i></button>
                                    <button type="button" class="btn btn-sm btn-outline-danger" title="Xóa bàn"><i class="bi bi-trash"></i></button>
                                </div>
                            </div>
                        </div>

                        <!-- Bàn 03 (Đã đặt trước) -->
                        <div class="col-12 col-sm-6 col-md-4 col-xl-3">
                            <div class="table-item-card table-state-reserved">
                                <div class="d-flex justify-content-between align-items-center mb-2">
                                    <span class="badge bg-warning text-dark px-2 py-1">B03</span>
                                    <span class="badge badge-soft-reserved rounded-pill">Đã đặt trước</span>
                                </div>
                                <h6 class="fw-bold text-dark mb-1">Bàn 03 <span class="text-muted fw-normal small">(6 ghế)</span></h6>
                                <div class="p-2 rounded-3 bg-warning-subtle my-2">
                                    <div class="fw-semibold text-dark small"><i class="bi bi-person me-1"></i>Trần Minh Tâm (5 khách)</div>
                                    <div class="small text-secondary"><i class="bi bi-telephone me-1"></i>0912 345 678</div>
                                </div>
                                <div class="small text-warning-emphasis mb-3 fw-medium">
                                    <i class="bi bi-alarm me-1"></i>Giờ hẹn: <strong>15:30</strong> (Hôm nay)
                                </div>
                                <div class="d-flex gap-1 pt-2 border-top">
                                    <a href="GoiMonThanhToan.aspx" class="btn btn-sm btn-warning flex-grow-1 fw-semibold text-dark"><i class="bi bi-box-arrow-in-right me-1"></i>Nhận bàn</a>
                                    <button type="button" class="btn btn-sm btn-action-light" data-bs-toggle="modal" data-bs-target="#modalTaoDatBan" title="Chỉnh sửa lịch"><i class="bi bi-pencil"></i></button>
                                </div>
                            </div>
                        </div>

                        <!-- Bàn 04 (Đang sử dụng) -->
                        <div class="col-12 col-sm-6 col-md-4 col-xl-3">
                            <div class="table-item-card table-state-occupied">
                                <div class="d-flex justify-content-between align-items-center mb-2">
                                    <span class="badge bg-primary px-2 py-1">B04</span>
                                    <span class="badge badge-soft-occupied rounded-pill">Đang phục vụ</span>
                                </div>
                                <h6 class="fw-bold text-dark mb-1">Bàn 04 <span class="text-muted fw-normal small">(4 ghế)</span></h6>
                                <div class="p-2 rounded-3 bg-light my-2">
                                    <div class="d-flex justify-content-between small mb-1">
                                        <span class="text-secondary"><i class="bi bi-receipt me-1"></i>Hóa đơn:</span>
                                        <strong class="text-primary">#DH1025</strong>
                                    </div>
                                    <div class="d-flex justify-content-between small">
                                        <span class="text-secondary"><i class="bi bi-cash-stack me-1"></i>Tạm tính:</span>
                                        <strong class="text-danger">93.000 đ</strong>
                                    </div>
                                </div>
                                <div class="small text-muted mb-3 d-flex align-items-center">
                                    <i class="bi bi-stopwatch text-warning me-1"></i>Vào lúc: 14:10 (20 phút)
                                </div>
                                <div class="d-flex gap-1 pt-2 border-top">
                                    <a href="GoiMonThanhToan.aspx" class="btn btn-sm btn-primary flex-grow-1 fw-semibold"><i class="bi bi-receipt-cutoff me-1"></i>Thu tiền</a>
                                    <button type="button" class="btn btn-sm btn-action-light" data-bs-toggle="modal" data-bs-target="#modalChuyenBan" title="Chuyển bàn"><i class="bi bi-arrow-left-right"></i></button>
                                    <button type="button" class="btn btn-sm btn-action-light" data-bs-toggle="modal" data-bs-target="#modalThemBan" title="Sửa bàn"><i class="bi bi-pencil"></i></button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- CẤP 1: KHU VỰC 02 (TẦNG 2) -->
            <div class="zone-wrapper">
                <div class="zone-header-pro d-flex flex-wrap justify-content-between align-items-center gap-2">
                    <div class="d-flex align-items-center gap-2">
                        <span class="p-2 bg-info-subtle text-info rounded-3"><i class="bi bi-clouds fs-5"></i></span>
                        <div>
                            <h6 class="fw-bold mb-0 text-dark">Khu Vực 02: Tầng 2 • Ban Công & Phòng Họp VIP</h6>
                            <small class="text-muted">Góc ngắm cảnh, phòng họp nhóm • 2 bàn hiện hữu</small>
                        </div>
                    </div>
                    <div class="d-flex align-items-center gap-2">
                        <span class="badge badge-soft-empty rounded-pill px-2 py-1"><i class="bi bi-circle-fill small me-1"></i>1 Trống</span>
                        <span class="badge badge-soft-reserved rounded-pill px-2 py-1"><i class="bi bi-circle-fill small me-1"></i>1 Đặt trước</span>
                    </div>
                </div>

                <div class="p-4">
                    <div class="row g-3">
                        <!-- Bàn 05 (Trống) -->
                        <div class="col-12 col-sm-6 col-md-4 col-xl-3">
                            <div class="table-item-card table-state-empty">
                                <div class="d-flex justify-content-between align-items-center mb-2">
                                    <span class="badge bg-secondary px-2 py-1">B05</span>
                                    <span class="badge badge-soft-empty rounded-pill">Trống</span>
                                </div>
                                <h6 class="fw-bold text-dark mb-1">Bàn 05 <span class="text-muted fw-normal small">(4 ghế)</span></h6>
                                <div class="p-2 rounded-3 bg-light my-2">
                                    <div class="small text-muted"><i class="bi bi-geo-alt me-1"></i>Góc ban công ngắm phố</div>
                                    <div class="small text-success fw-medium"><i class="bi bi-check2-circle me-1"></i>Bàn sạch, sẵn sàng</div>
                                </div>
                                <div class="small text-muted mb-3"><i class="bi bi-info-circle me-1"></i>Chưa phát sinh order</div>
                                <div class="d-flex gap-1 pt-2 border-top">
                                    <a href="GoiMonThanhToan.aspx" class="btn btn-sm btn-outline-success flex-grow-1 fw-semibold"><i class="bi bi-plus-circle me-1"></i>Mở gọi món</a>
                                    <button type="button" class="btn btn-sm btn-action-light" data-bs-toggle="modal" data-bs-target="#modalThemBan"><i class="bi bi-pencil"></i></button>
                                    <button type="button" class="btn btn-sm btn-outline-danger"><i class="bi bi-trash"></i></button>
                                </div>
                            </div>
                        </div>

                        <!-- Bàn 06 (Đặt trước VIP) -->
                        <div class="col-12 col-sm-6 col-md-4 col-xl-3">
                            <div class="table-item-card table-state-reserved">
                                <div class="d-flex justify-content-between align-items-center mb-2">
                                    <span class="badge bg-warning text-dark px-2 py-1">B06</span>
                                    <span class="badge badge-soft-reserved rounded-pill">Đã đặt trước</span>
                                </div>
                                <h6 class="fw-bold text-dark mb-1">Bàn 06 VIP <span class="text-muted fw-normal small">(8 ghế)</span></h6>
                                <div class="p-2 rounded-3 bg-warning-subtle my-2">
                                    <div class="fw-semibold text-dark small"><i class="bi bi-person me-1"></i>Lê Hoàng Nam (7 khách)</div>
                                    <div class="small text-secondary"><i class="bi bi-telephone me-1"></i>0987 654 321</div>
                                </div>
                                <div class="small text-warning-emphasis mb-3 fw-medium">
                                    <i class="bi bi-alarm me-1"></i>Giờ hẹn: <strong>18:00</strong> (Hôm nay)
                                </div>
                                <div class="d-flex gap-1 pt-2 border-top">
                                    <a href="GoiMonThanhToan.aspx" class="btn btn-sm btn-warning flex-grow-1 fw-semibold text-dark"><i class="bi bi-box-arrow-in-right me-1"></i>Nhận bàn</a>
                                    <button type="button" class="btn btn-sm btn-action-light" data-bs-toggle="modal" data-bs-target="#modalTaoDatBan"><i class="bi bi-pencil"></i></button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- CẤP 1: KHU VỰC 03 (SÂN VƯỜN) -->
            <div class="zone-wrapper">
                <div class="zone-header-pro d-flex flex-wrap justify-content-between align-items-center gap-2">
                    <div class="d-flex align-items-center gap-2">
                        <span class="p-2 bg-success-subtle text-success rounded-3"><i class="bi bi-tree fs-5"></i></span>
                        <div>
                            <h6 class="fw-bold mb-0 text-dark">Khu Vực 03: Sân Vườn Ngoài Trời</h6>
                            <small class="text-muted">Không gian mở thoáng đãng • 2 bàn hiện hữu</small>
                        </div>
                    </div>
                    <div class="d-flex align-items-center gap-2">
                        <span class="badge badge-soft-empty rounded-pill px-2 py-1"><i class="bi bi-circle-fill small me-1"></i>1 Trống</span>
                        <span class="badge badge-soft-occupied rounded-pill px-2 py-1"><i class="bi bi-circle-fill small me-1"></i>1 Đang dùng</span>
                    </div>
                </div>

                <div class="p-4">
                    <div class="row g-3">
                        <!-- Bàn 07 (Đang sử dụng) -->
                        <div class="col-12 col-sm-6 col-md-4 col-xl-3">
                            <div class="table-item-card table-state-occupied">
                                <div class="d-flex justify-content-between align-items-center mb-2">
                                    <span class="badge bg-primary px-2 py-1">B07</span>
                                    <span class="badge badge-soft-occupied rounded-pill">Đang phục vụ</span>
                                </div>
                                <h6 class="fw-bold text-dark mb-1">Bàn 07 <span class="text-muted fw-normal small">(4 ghế)</span></h6>
                                <div class="p-2 rounded-3 bg-light my-2">
                                    <div class="d-flex justify-content-between small mb-1">
                                        <span class="text-secondary"><i class="bi bi-receipt me-1"></i>Hóa đơn:</span>
                                        <strong class="text-primary">#DH1026</strong>
                                    </div>
                                    <div class="d-flex justify-content-between small">
                                        <span class="text-secondary"><i class="bi bi-cash-stack me-1"></i>Tạm tính:</span>
                                        <strong class="text-danger">165.000 đ</strong>
                                    </div>
                                </div>
                                <div class="small text-muted mb-3 d-flex align-items-center">
                                    <i class="bi bi-stopwatch text-warning me-1"></i>Vào lúc: 14:15 (15 phút)
                                </div>
                                <div class="d-flex gap-1 pt-2 border-top">
                                    <a href="GoiMonThanhToan.aspx" class="btn btn-sm btn-primary flex-grow-1 fw-semibold"><i class="bi bi-receipt-cutoff me-1"></i>Thu tiền</a>
                                    <button type="button" class="btn btn-sm btn-action-light" data-bs-toggle="modal" data-bs-target="#modalChuyenBan"><i class="bi bi-arrow-left-right"></i></button>
                                    <button type="button" class="btn btn-sm btn-action-light" data-bs-toggle="modal" data-bs-target="#modalThemBan"><i class="bi bi-pencil"></i></button>
                                </div>
                            </div>
                        </div>

                        <!-- Bàn 08 (Trống) -->
                        <div class="col-12 col-sm-6 col-md-4 col-xl-3">
                            <div class="table-item-card table-state-empty">
                                <div class="d-flex justify-content-between align-items-center mb-2">
                                    <span class="badge bg-secondary px-2 py-1">B08</span>
                                    <span class="badge badge-soft-empty rounded-pill">Trống</span>
                                </div>
                                <h6 class="fw-bold text-dark mb-1">Bàn 08 <span class="text-muted fw-normal small">(4 ghế)</span></h6>
                                <div class="p-2 rounded-3 bg-light my-2">
                                    <div class="small text-muted"><i class="bi bi-geo-alt me-1"></i>Cạnh tiểu cảnh sân vườn</div>
                                    <div class="small text-success fw-medium"><i class="bi bi-check2-circle me-1"></i>Bàn sạch, sẵn sàng</div>
                                </div>
                                <div class="small text-muted mb-3"><i class="bi bi-info-circle me-1"></i>Chưa phát sinh order</div>
                                <div class="d-flex gap-1 pt-2 border-top">
                                    <a href="GoiMonThanhToan.aspx" class="btn btn-sm btn-outline-success flex-grow-1 fw-semibold"><i class="bi bi-plus-circle me-1"></i>Mở gọi món</a>
                                    <button type="button" class="btn btn-sm btn-action-light" data-bs-toggle="modal" data-bs-target="#modalThemBan"><i class="bi bi-pencil"></i></button>
                                    <button type="button" class="btn btn-sm btn-outline-danger"><i class="bi bi-trash"></i></button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

        </div>

        <!-- ======================================================== -->
        <!-- TAB 2: LỊCH ĐẶT BÀN TRƯỚC (QUẢN TRỊ DỮ LIỆU BẢNG) -->
        <!-- ======================================================== -->
        <div class="tab-pane fade" id="tabLichDatBan" role="tabpanel">
            <div class="zone-wrapper">
                <div class="zone-header-pro d-flex flex-wrap justify-content-between align-items-center gap-2">
                    <div>
                        <h6 class="fw-bold mb-0 text-dark"><i class="bi bi-calendar2-range me-2 text-primary"></i>Danh Sách Lịch Hẹn Đặt Bàn</h6>
                        <small class="text-muted">Theo dõi và tiếp nhận khách đặt trước theo thời gian thực</small>
                    </div>
                    <div class="d-flex align-items-center gap-2">
                        <input type="date" class="form-control form-control-sm" value="2026-11-09" style="width: 150px;" />
                        <button type="button" class="btn btn-sm btn-primary rounded-3" data-bs-toggle="modal" data-bs-target="#modalTaoDatBan">
                            <i class="bi bi-plus-lg me-1"></i>Thêm đặt bàn mới
                        </button>
                    </div>
                </div>

                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light text-secondary small text-uppercase">
                            <tr>
                                <th class="ps-4">Mã Đặt</th>
                                <th>Khách Hàng</th>
                                <th>Số Điện Thoại</th>
                                <th>Giờ Hẹn Đến</th>
                                <th class="text-center">Số Khách</th>
                                <th>Vị Trí Bàn</th>
                                <th>Ghi Chú Yêu Cầu</th>
                                <th>Trạng Thái</th>
                                <th class="text-end pe-4">Thao Tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td class="ps-4 fw-bold text-primary">#DB012</td>
                                <td class="fw-semibold">Trần Minh Tâm</td>
                                <td class="text-secondary font-monospace">0912 345 678</td>
                                <td><span class="badge bg-light text-dark border"><i class="bi bi-clock me-1 text-primary"></i>15:30 (Hôm nay)</span></td>
                                <td class="text-center"><span class="badge bg-primary-subtle text-primary rounded-pill px-2">5 người</span></td>
                                <td><span class="badge bg-secondary-subtle text-dark border">B03 (Tầng 1)</span></td>
                                <td class="text-muted small">Cần kê thêm 1 ghế trẻ em</td>
                                <td><span class="badge badge-soft-reserved rounded-pill">Đã xác nhận</span></td>
                                <td class="text-end pe-4">
                                    <a href="GoiMonThanhToan.aspx" class="btn btn-sm btn-outline-success py-1 px-2" title="Tiếp nhận khách"><i class="bi bi-box-arrow-in-right me-1"></i>Nhận</a>
                                    <button type="button" class="btn btn-sm btn-action-light py-1 px-2" data-bs-toggle="modal" data-bs-target="#modalTaoDatBan"><i class="bi bi-pencil"></i></button>
                                    <button type="button" class="btn btn-sm btn-outline-danger py-1 px-2" title="Hủy đặt bàn"><i class="bi bi-x-circle"></i></button>
                                </td>
                            </tr>
                            <tr>
                                <td class="ps-4 fw-bold text-primary">#DB014</td>
                                <td class="fw-semibold">Lê Hoàng Nam</td>
                                <td class="text-secondary font-monospace">0987 654 321</td>
                                <td><span class="badge bg-light text-dark border"><i class="bi bi-clock me-1 text-primary"></i>18:00 (Hôm nay)</span></td>
                                <td class="text-center"><span class="badge bg-primary-subtle text-primary rounded-pill px-2">7 người</span></td>
                                <td><span class="badge bg-secondary-subtle text-dark border">B06 (VIP Tầng 2)</span></td>
                                <td class="text-muted small">Khách tổ chức tiệc sinh nhật</td>
                                <td><span class="badge badge-soft-reserved rounded-pill">Đã xác nhận</span></td>
                                <td class="text-end pe-4">
                                    <a href="GoiMonThanhToan.aspx" class="btn btn-sm btn-outline-success py-1 px-2" title="Tiếp nhận khách"><i class="bi bi-box-arrow-in-right me-1"></i>Nhận</a>
                                    <button type="button" class="btn btn-sm btn-action-light py-1 px-2" data-bs-toggle="modal" data-bs-target="#modalTaoDatBan"><i class="bi bi-pencil"></i></button>
                                    <button type="button" class="btn btn-sm btn-outline-danger py-1 px-2" title="Hủy đặt bàn"><i class="bi bi-x-circle"></i></button>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <!-- 4. CÁC MODAL HỆ THỐNG ĐÃ ĐƯỢC CHUẨN HÓA GIAO DIỆN -->

    <!-- MODAL THÊM / SỬA BÀN -->
    <div class="modal fade" id="modalThemBan" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow-lg rounded-4 overflow-hidden">
                <div class="modal-header bg-primary text-white py-3">
                    <h6 class="modal-title fw-bold"><i class="bi bi-grid-3x3-gap me-2"></i>Thiết Lập Thông Tin Bàn Ăn</h6>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body p-4">
                    <div class="row g-3">
                        <div class="col-md-5">
                            <label class="form-label small fw-semibold">Mã Bàn <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" placeholder="VD: B09" />
                        </div>
                        <div class="col-md-7">
                            <label class="form-label small fw-semibold">Tên Hiển Thị <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" placeholder="VD: Bàn 09 (Cạnh hồ cá)" />
                        </div>
                        <div class="col-md-6">
                            <label class="form-label small fw-semibold">Khu Vực Phục Vụ <span class="text-danger">*</span></label>
                            <select class="form-select">
                                <option>KV01 - Tầng 1 (Lạnh)</option>
                                <option>KV02 - Tầng 2 (Ban công)</option>
                                <option selected>KV03 - Sân vườn</option>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label small fw-semibold">Sức Chứa (Ghế)</label>
                            <input type="number" class="form-control" value="4" min="1" />
                        </div>
                        <div class="col-12">
                            <label class="form-label small fw-semibold">Trạng Thái Khởi Tạo</label>
                            <select class="form-select">
                                <option selected>Trống (Sẵn sàng)</option>
                                <option>Đang sử dụng</option>
                                <option>Đã đặt trước</option>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="modal-footer bg-light py-2 px-4">
                    <button type="button" class="btn btn-sm btn-secondary rounded-3" data-bs-dismiss="modal">Đóng</button>
                    <button type="button" class="btn btn-sm btn-primary rounded-3 px-3" data-bs-dismiss="modal"><i class="bi bi-check2 me-1"></i>Lưu dữ liệu bàn</button>
                </div>
            </div>
        </div>
    </div>

    <!-- MODAL CHUYỂN BÀN -->
    <div class="modal fade" id="modalChuyenBan" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow-lg rounded-4 overflow-hidden">
                <div class="modal-header bg-warning text-dark py-3">
                    <h6 class="modal-title fw-bold"><i class="bi bi-arrow-left-right me-2"></i>Điều Phối & Chuyển Khách Sang Bàn Khác</h6>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body p-4">
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Bàn hiện tại (Đang phục vụ)</label>
                        <select class="form-select">
                            <option selected>B01 - Tầng 1 (Đơn #DH1024 • 138.000 đ)</option>
                            <option>B04 - Tầng 1 (Đơn #DH1025 • 93.000 đ)</option>
                            <option>B07 - Sân vườn (Đơn #DH1026 • 165.000 đ)</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Chuyển đến bàn trống <span class="text-danger">*</span></label>
                        <select class="form-select border-primary">
                            <option selected>B02 - Tầng 1 (2 ghế)</option>
                            <option>B05 - Tầng 2 (4 ghế)</option>
                            <option>B08 - Sân vườn (4 ghế)</option>
                        </select>
                    </div>
                    <div class="mb-0">
                        <label class="form-label small fw-semibold">Lý do điều chuyển</label>
                        <input type="text" class="form-control" placeholder="VD: Khách đổi sang bàn rộng hơn..." />
                    </div>
                </div>
                <div class="modal-footer bg-light py-2 px-4">
                    <button type="button" class="btn btn-sm btn-secondary rounded-3" data-bs-dismiss="modal">Hủy bỏ</button>
                    <button type="button" class="btn btn-sm btn-warning rounded-3 fw-semibold text-dark px-3" data-bs-dismiss="modal"><i class="bi bi-arrow-repeat me-1"></i>Xác nhận chuyển bàn</button>
                </div>
            </div>
        </div>
    </div>

    <!-- MODAL QUẢN LÝ KHU VỰC -->
    <div class="modal fade" id="modalKhuVuc" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow-lg rounded-4 overflow-hidden">
                <div class="modal-header bg-primary text-white py-3">
                    <h6 class="modal-title fw-bold"><i class="bi bi-layers me-2"></i>Danh Mục Khu Vực Quán</h6>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body p-4">
                    <div class="input-group mb-3">
                        <input type="text" class="form-control" placeholder="Nhập tên tầng / khu vực mới..." />
                        <button class="btn btn-primary" type="button"><i class="bi bi-plus-lg me-1"></i>Thêm</button>
                    </div>
                    <table class="table table-sm table-bordered align-middle">
                        <thead class="table-light">
                            <tr>
                                <th>Mã KV</th>
                                <th>Tên Phân Vùng</th>
                                <th class="text-center">Số Bàn</th>
                                <th class="text-end">Thao Tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td class="fw-semibold">KV01</td>
                                <td>Tầng 1 (Phòng Lạnh)</td>
                                <td class="text-center"><span class="badge bg-light text-dark border">4</span></td>
                                <td class="text-end"><button class="btn btn-sm btn-outline-danger py-0 px-2"><i class="bi bi-trash"></i></button></td>
                            </tr>
                            <tr>
                                <td class="fw-semibold">KV02</td>
                                <td>Tầng 2 (Ban công)</td>
                                <td class="text-center"><span class="badge bg-light text-dark border">2</span></td>
                                <td class="text-end"><button class="btn btn-sm btn-outline-danger py-0 px-2"><i class="bi bi-trash"></i></button></td>
                            </tr>
                            <tr>
                                <td class="fw-semibold">KV03</td>
                                <td>Sân vườn ngoài trời</td>
                                <td class="text-center"><span class="badge bg-light text-dark border">2</span></td>
                                <td class="text-end"><button class="btn btn-sm btn-outline-danger py-0 px-2"><i class="bi bi-trash"></i></button></td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <!-- MODAL TẠO ĐẶT BÀN -->
    <div class="modal fade" id="modalTaoDatBan" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg modal-dialog-centered">
            <div class="modal-content border-0 shadow-lg rounded-4 overflow-hidden">
                <div class="modal-header bg-primary text-white py-3">
                    <h6 class="modal-title fw-bold"><i class="bi bi-calendar-plus me-2"></i>Lập Phiếu Đặt Bàn Trước Cho Khách</h6>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body p-4">
                    <div class="row g-3">
                        <div class="col-md-4">
                            <label class="form-label small fw-semibold">Mã Đặt Bàn</label>
                            <input type="text" class="form-control bg-light font-monospace" value="#DB015" readonly />
                        </div>
                        <div class="col-md-4">
                            <label class="form-label small fw-semibold">Họ Tên Khách Hàng <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" placeholder="Nhập tên khách..." />
                        </div>
                        <div class="col-md-4">
                            <label class="form-label small fw-semibold">Số Điện Thoại <span class="text-danger">*</span></label>
                            <input type="tel" class="form-control" placeholder="VD: 0912xxxxxx" />
                        </div>
                        <div class="col-md-4">
                            <label class="form-label small fw-semibold">Ngày Đến <span class="text-danger">*</span></label>
                            <input type="date" class="form-control" value="2026-11-09" />
                        </div>
                        <div class="col-md-4">
                            <label class="form-label small fw-semibold">Giờ Đến Dự Kiến <span class="text-danger">*</span></label>
                            <input type="time" class="form-control" value="19:00" />
                        </div>
                        <div class="col-md-4">
                            <label class="form-label small fw-semibold">Số Lượng Khách <span class="text-danger">*</span></label>
                            <input type="number" class="form-control" value="4" min="1" />
                        </div>
                        <div class="col-md-6">
                            <label class="form-label small fw-semibold">Chỉ Định Bàn Trống Phù Hợp <span class="text-danger">*</span></label>
                            <select class="form-select">
                                <option>B02 - Tầng 1 (Trống • 2 ghế)</option>
                                <option selected>B05 - Tầng 2 (Trống • 4 ghế)</option>
                                <option>B08 - Sân vườn (Trống • 4 ghế)</option>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label small fw-semibold">Trạng Thái Đặt</label>
                            <select class="form-select">
                                <option selected>Đã xác nhận</option>
                                <option>Chờ xác nhận</option>
                                <option>Khách đã nhận bàn</option>
                                <option>Đã hủy / No-show</option>
                            </select>
                        </div>
                        <div class="col-12">
                            <label class="form-label small fw-semibold">Yêu Cầu Đặc Biệt / Ghi Chú</label>
                            <textarea class="form-control" rows="2" placeholder="VD: Khách mang bánh kem sinh nhật, cần góc yên tĩnh..."></textarea>
                        </div>
                    </div>
                </div>
                <div class="modal-footer bg-light py-2 px-4">
                    <button type="button" class="btn btn-sm btn-secondary rounded-3" data-bs-dismiss="modal">Đóng</button>
                    <button type="button" class="btn btn-sm btn-primary rounded-3 px-3" data-bs-dismiss="modal"><i class="bi bi-check2-circle me-1"></i>Lưu thông tin đặt bàn</button>
                </div>
            </div>
        </div>
    </div>

</asp:Content>
