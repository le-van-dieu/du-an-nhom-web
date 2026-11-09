<%@ Page Title="Gọi món & Thanh toán Hóa đơn" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="GoiMonThanhToan.aspx.cs" Inherits="N9_QLCAFE.GoiMonThanhToan" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <!-- HEADER -->
    <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 gap-3">
        <div>
            <span class="badge badge-soft-blue mb-1">Phân hệ F27 - F44 • Phụ trách: Lê Văn Điều</span>
            <h4 class="fw-bold mb-0 text-dark">Màn hình Gọi món (POS), Đơn hàng & Thanh toán Hóa đơn</h4>
        </div>
        <ul class="nav nav-pills nav-pills-blue" role="tablist">
            <li class="nav-item" role="presentation">
                <button class="nav-link active" data-bs-toggle="tab" data-bs-target="#tabPOS" type="button">
                    <i class="bi bi-cart-plus me-1"></i>Quầy Gọi món & Thu ngân (F27 - F42)
                </button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link me-0" data-bs-toggle="tab" data-bs-target="#tabLichSuHoaDon" type="button">
                    <i class="bi bi-receipt-cutoff me-1"></i>Theo dõi Đơn & Lịch sử Hóa đơn (F35, F43, F44)
                </button>
            </li>
        </ul>
    </div>

    <div class="tab-content">
        <!-- TAB 1: MÀN HÌNH POS GỌI MÓN & THANH TOÁN TRỰC TIẾP (F27 - F42) -->
        <div class="tab-pane fade show active" id="tabPOS" role="tabpanel">
            <div class="row g-4">
                <!-- CỘT TRÁI (7 CỘT): CHỌN ĐỒ UỐNG TỪ MENU (F28, F29) -->
                <div class="col-12 col-xl-7">
                    <div class="card-custom h-100">
                        <div class="card-header-custom flex-wrap gap-2">
                            <div>
                                <h6 class="fw-bold mb-0 text-dark"><i class="bi bi-cup-straw text-primary me-2"></i>Thực đơn chọn món nhanh (F28)</h6>
                                <small class="text-muted">Quy tắc: Không cho phép thêm món đã hết hàng hoặc ngừng kinh doanh</small>
                            </div>
                            <div class="input-group input-group-sm" style="width: 230px;">
                                <span class="input-group-text bg-light text-primary border-end-0"><i class="bi bi-search"></i></span>
                                <input type="text" class="form-control border-start-0" placeholder="Tìm tên hoặc mã đồ uống..." />
                            </div>
                        </div>

                        <div class="p-3">
                            <!-- Bộ lọc danh mục nhanh -->
                            <div class="d-flex flex-wrap gap-2 mb-3 pb-2 border-bottom">
                                <button type="button" class="btn btn-sm btn-cafe-primary">Tất cả (0)</button>
                                <button type="button" class="btn btn-sm btn-cafe-outline">Cà phê truyền thống</button>
                                <button type="button" class="btn btn-sm btn-cafe-outline">Cà phê pha máy</button>
                                <button type="button" class="btn btn-sm btn-cafe-outline">Trà trái cây</button>
                                <button type="button" class="btn btn-sm btn-cafe-outline">Đá xay / Freeze</button>
                            </div>

                            <!-- Lưới món nước (F28, F29) -->
                            <div class="row g-3">
                                <div class="col-12">
                                    <div class="p-5 text-center text-muted border rounded-3 bg-light">
                                        <i class="bi bi-cup-straw fs-1 d-block text-secondary mb-2 opacity-50"></i>
                                        <div class="fw-semibold">Chưa có món nào trên thực đơn</div>
                                        <small class="text-muted">Các đồ uống đang kinh doanh sẽ xuất hiện tại đây để nhân viên chọn món</small>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- CỘT PHẢI (5 CỘT): CHI TIẾT ĐƠN HÀNG & THANH TOÁN HÓA ĐƠN (F27, F30 - F42) -->
                <div class="col-12 col-xl-5">
                    <div class="card-custom">
                        <!-- Thông tin chung của Đơn hàng (F27, F34) -->
                        <div class="card-header-custom bg-primary text-white">
                            <div>
                                <div class="d-flex align-items-center gap-2">
                                    <h6 class="fw-bold mb-0">Đơn hàng mới</h6>
                                    <span class="badge bg-white text-primary">Chờ gọi món</span>
                                </div>
                                <small class="opacity-75">Chọn bàn hoặc mang đi để bắt đầu phục vụ</small>
                            </div>
                            <button type="button" class="btn btn-sm btn-light text-primary fw-semibold" title="Tạo đơn mới (F27)">
                                <i class="bi bi-file-earmark-plus"></i> Đơn mới
                            </button>
                        </div>

                        <div class="p-3">
                            <!-- Chọn bàn hoặc Mang đi + Nút chuyển bàn (F27, F34) -->
                            <div class="row g-2 mb-3">
                                <div class="col-8">
                                    <label class="form-label small fw-semibold mb-1">Bàn phục vụ / Hình thức (F27)</label>
                                    <select class="form-select form-select-sm fw-semibold text-primary">
                                        <option selected>-- Chọn bàn phục vụ --</option>
                                        <option>MANG ĐI (Take-away)</option>
                                    </select>
                                </div>
                                <div class="col-4 d-flex align-items-end">
                                    <a href="BanVaDatBan.aspx" class="btn btn-sm btn-cafe-outline w-100">
                                        <i class="bi bi-arrow-left-right me-1"></i>Đổi bàn (F34)
                                    </a>
                                </div>
                            </div>

                            <!-- Danh sách món trong đơn (F30, F31, F32) -->
                            <div class="table-responsive border rounded-3 mb-3">
                                <table class="table table-sm table-cafe mb-0">
                                    <thead>
                                        <tr>
                                            <th>Món & Ghi chú (F32)</th>
                                            <th class="text-center" style="width: 105px;">SL (F30)</th>
                                            <th class="text-end">Thành tiền</th>
                                            <th style="width: 36px;"></th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td colspan="4" class="text-center text-muted py-4">
                                                <i class="bi bi-cart-x fs-2 d-block text-secondary mb-1 opacity-50"></i>
                                                <span class="fw-semibold">Chưa có món trong đơn hàng</span>
                                                <small class="d-block text-muted">Chọn món từ danh sách bên trái để thêm vào đơn</small>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>

                            <!-- KHU VỰC TÍNH TIỀN, GIẢM GIÁ & PHƯƠNG THỨC THANH TOÁN (F33, F36 - F42) -->
                            <div class="bg-light p-3 rounded-3 border mb-3">
                                <div class="d-flex justify-content-between small mb-2">
                                    <span class="text-muted">Tạm tính (4 ly - F33):</span>
                                    <span class="fw-semibold">0 đ</span>
                                </div>
                                <div class="d-flex justify-content-between align-items-center small mb-2">
                                    <span class="text-muted">Giảm giá / Khuyến mãi (F38):</span>
                                    <div class="input-group input-group-sm" style="width: 145px;">
                                        <input type="text" class="form-control text-end" value="10.000" />
                                        <span class="input-group-text">đ</span>
                                    </div>
                                </div>
                                <div class="d-flex justify-content-between align-items-center pt-2 border-top">
                                    <span class="fw-bold text-dark">TỔNG THANH TOÁN (F37):</span>
                                    <span class="fw-bold text-primary fs-5">0 đ</span>
                                </div>
                            </div>

                            <!-- Lựa chọn phương thức thanh toán (F39, F40) -->
                            <div class="mb-3">
                                <label class="form-label small fw-semibold mb-2">Phương thức thanh toán (F39 / F40)</label>
                                <div class="row g-2">
                                    <div class="col-6">
                                        <input type="radio" class="btn-check" name="pttt" id="ptTienMat" checked />
                                        <label class="btn btn-sm btn-cafe-outline w-100 py-2" for="ptTienMat">
                                            <i class="bi bi-cash-coin me-1"></i>Tiền mặt (F39)
                                        </label>
                                    </div>
                                    <div class="col-6">
                                        <input type="radio" class="btn-check" name="pttt" id="ptChuyenKhoan" />
                                        <label class="btn btn-sm btn-cafe-outline w-100 py-2" for="ptChuyenKhoan">
                                            <i class="bi bi-qr-code me-1"></i>Chuyển khoản (F40)
                                        </label>
                                    </div>
                                </div>
                            </div>

                            <!-- Các nút xử lý Đơn hàng & Hóa đơn (F36, F41, F42) -->
                            <div class="d-flex gap-2">
                                <button type="button" class="btn btn-cafe-outline flex-grow-1">
                                    <i class="bi bi-save me-1"></i>Lưu đơn (F27)
                                </button>
                                <button type="button" class="btn btn-cafe-outline" data-bs-toggle="modal" data-bs-target="#modalInHoaDon" title="Xem & In hóa đơn (F42)">
                                    <i class="bi bi-printer"></i> In (F42)
                                </button>
                                <button type="button" class="btn btn-cafe-primary flex-grow-1" data-bs-toggle="modal" data-bs-target="#modalInHoaDon">
                                    <i class="bi bi-check2-circle me-1"></i>Thanh toán (F41)
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- TAB 2: TRA CỨU & LỊCH SỬ HÓA ĐƠN GIAO DỊCH (F35, F43, F44) -->
        <div class="tab-pane fade" id="tabLichSuHoaDon" role="tabpanel">
            <div class="card-custom">
                <div class="card-header-custom flex-wrap gap-2">
                    <div>
                        <h6 class="fw-bold mb-0 text-dark">Tra cứu Hóa đơn & Lịch sử Giao dịch (F43, F44)</h6>
                        <small class="text-muted">Quy tắc: Không thanh toán 2 lần cho cùng 1 hóa đơn • Không chỉnh sửa đơn đã thanh toán</small>
                    </div>
                    <div class="d-flex flex-wrap gap-2">
                        <div class="input-group input-group-sm" style="width: 240px;">
                            <span class="input-group-text bg-light text-primary border-end-0"><i class="bi bi-search"></i></span>
                            <input type="text" class="form-control border-start-0" placeholder="Tìm theo mã HĐ, mã đơn (F43)..." />
                        </div>
                        <input type="date" class="form-control form-control-sm" value="2026-11-09" style="width: 145px;" />
                    </div>
                </div>

                <div class="table-responsive">
                    <table class="table table-cafe">
                        <thead>
                            <tr>
                                <th>Mã HĐ</th>
                                <th>Mã Đơn</th>
                                <th>Bàn / Hình thức</th>
                                <th>Thời gian</th>
                                <th>Nhân viên</th>
                                <th>Tổng tiền</th>
                                <th>Giảm giá</th>
                                <th>Thực thu</th>
                                <th>Phương thức</th>
                                <th>Trạng thái</th>
                                <th class="text-end">Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td colspan="11" class="text-center text-muted py-5">
                                    <i class="bi bi-inbox fs-1 d-block text-secondary mb-2 opacity-50"></i>
                                    <div class="fw-semibold">Chưa có hóa đơn nào</div>
                                    <small class="text-muted">Lịch sử hóa đơn sau khi thanh toán sẽ hiển thị tại đây</small>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <!-- MODAL XÁC NHẬN THANH TOÁN & IN HÓA ĐƠN (F36, F41, F42) -->
    <div class="modal fade" id="modalInHoaDon" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow">
                <div class="modal-header bg-primary text-white">
                    <h6 class="modal-title fw-bold"><i class="bi bi-receipt me-2"></i>Phiếu Hóa đơn Thanh toán (F36 / F42)</h6>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body p-4">
                    <div class="text-center border-bottom pb-3 mb-3">
                        <h5 class="fw-bold text-primary mb-1">N9 QLCAFÉ - HÓA ĐƠN BÁN HÀNG</h5>
                        <div class="small text-muted">Mã HĐ: <strong>--</strong> • Đơn hàng: <strong>--</strong></div>
                        <div class="small text-muted">Bàn: <strong>--</strong> • Thu ngân: <strong>--</strong></div>
                        <div class="small text-muted">Ngày giờ: 09/11/2026 14:35</div>
                    </div>

                    <table class="table table-sm small mb-3">
                        <thead>
                            <tr class="border-bottom">
                                <th>Tên đồ uống</th>
                                <th class="text-center">SL</th>
                                <th class="text-end">Đơn giá</th>
                                <th class="text-end">Thành tiền</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td colspan="4" class="text-center text-muted py-3">
                                    <small>Chưa có chi tiết món thanh toán</small>
                                </td>
                            </tr>
                        </tbody>
                    </table>

                    <div class="border-top pt-2 small">
                        <div class="d-flex justify-content-between mb-1">
                            <span>Tổng tiền hàng:</span>
                            <span class="fw-semibold">0 đ</span>
                        </div>
                        <div class="d-flex justify-content-between mb-1">
                            <span>Giảm giá (F38):</span>
                            <span class="fw-semibold">0 đ</span>
                        </div>
                        <div class="d-flex justify-content-between fs-6 fw-bold text-primary pt-1 border-top">
                            <span>TỔNG THANH TOÁN (F37):</span>
                            <span>0 đ</span>
                        </div>
                        <div class="d-flex justify-content-between mt-1 text-muted">
                            <span>Phương thức:</span>
                            <span>Tiền mặt / Chuyển khoản QR</span>
                        </div>
                    </div>
                </div>
                <div class="modal-footer bg-light">
                    <button type="button" class="btn btn-sm btn-secondary" data-bs-dismiss="modal">Đóng</button>
                    <button type="button" class="btn btn-sm btn-cafe-outline" onclick="window.print();">
                        <i class="bi bi-printer me-1"></i>In hóa đơn (F42)
                    </button>
                    <button type="button" class="btn btn-sm btn-cafe-primary" data-bs-dismiss="modal">
                        <i class="bi bi-check2-all me-1"></i>Xác nhận hoàn tất (F41)
                    </button>
                </div>
            </div>
        </div>
    </div>
</asp:Content>

