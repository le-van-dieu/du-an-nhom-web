<%@ Page Title="Nhân viên & Tài khoản Phân quyền" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="NhanVienTaiKhoan.aspx.cs" Inherits="N9_QLCAFE.NhanVienTaiKhoan" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <!-- HEADER -->
    <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 gap-3">
        <div>
            <span class="badge badge-soft-blue mb-1">Phân hệ F04 - F05 & F45 - F50 • Phụ trách: Nguyễn Nhật Anh</span>
            <h4 class="fw-bold mb-0 text-dark">Quản lý Hồ sơ Nhân viên, Tài khoản & Phân quyền</h4>
        </div>
        <div class="d-flex flex-wrap gap-2">
            <button type="button" class="btn btn-cafe-outline" data-bs-toggle="modal" data-bs-target="#modalChucVu">
                <i class="bi bi-briefcase me-1"></i>Quản lý Chức vụ (F49)
            </button>
            <button type="button" class="btn btn-cafe-outline" data-bs-toggle="modal" data-bs-target="#modalTaiKhoan">
                <i class="bi bi-person-lock me-1"></i>Tạo Tài khoản (F05, F50)
            </button>
            <button type="button" class="btn btn-cafe-primary" data-bs-toggle="modal" data-bs-target="#modalThemNhanVien">
                <i class="bi bi-person-plus-fill me-1"></i>Thêm Nhân viên mới (F45)
            </button>
        </div>
    </div>

    <!-- THANH ĐIỀU HƯỚNG TAB & BỘ LỌC TÌM KIẾM (F48) -->
    <div class="card-custom p-3 mb-4">
        <div class="d-flex flex-wrap justify-content-between align-items-center gap-3">
            <ul class="nav nav-pills nav-pills-blue" role="tablist">
                <li class="nav-item" role="presentation">
                    <button class="nav-link active" data-bs-toggle="tab" data-bs-target="#tabHoSoNhanVien" type="button">
                        <i class="bi bi-people-fill me-1"></i>Hồ sơ Nhân viên (F45 - F49)
                    </button>
                </li>
                <li class="nav-item" role="presentation">
                    <button class="nav-link me-0" data-bs-toggle="tab" data-bs-target="#tabTaiKhoanPhanQuyen" type="button">
                        <i class="bi bi-shield-lock-fill me-1"></i>Tài khoản & Phân quyền (F04, F05, F50)
                    </button>
                </li>
            </ul>

            <div class="d-flex flex-wrap align-items-center gap-2">
                <div class="input-group input-group-sm" style="width: 250px;">
                    <span class="input-group-text bg-light text-primary border-end-0"><i class="bi bi-search"></i></span>
                    <input type="text" class="form-control border-start-0" placeholder="Tìm mã NV, họ tên, SĐT (F48)..." />
                </div>
                <select class="form-select form-select-sm" style="width: 170px;">
                    <option selected>-- Tất cả chức vụ (F49) --</option>
                    <option>Quản lý cửa hàng</option>
                    <option>Thu ngân / Phục vụ</option>
                    <option>Pha chế (Barista)</option>
                </select>
            </div>
        </div>
    </div>

    <div class="tab-content">
        <!-- TAB 1: DANH SÁCH HỒ SƠ NHÂN VIÊN (F45 - F50) -->
        <div class="tab-pane fade show active" id="tabHoSoNhanVien" role="tabpanel">
            <div class="card-custom">
                <div class="card-header-custom">
                    <div>
                        <h6 class="fw-bold mb-0 text-dark">Danh sách Hồ sơ Nhân viên</h6>
                        <small class="text-muted">Quy tắc: Mã NV không trùng • SĐT hợp lệ • NV đã có giao dịch không xóa vật lý, chỉ chuyển sang Nghỉ việc</small>
                    </div>
                    <span class="badge badge-soft-blue">Tổng: 0 nhân sự</span>
                </div>
                <div class="table-responsive">
                    <table class="table table-cafe">
                        <thead>
                            <tr>
                                <th>Mã NV</th>
                                <th>Họ tên & Ngày sinh</th>
                                <th>Giới tính</th>
                                <th>Liên hệ (SĐT / Email / Địa chỉ)</th>
                                <th>Chức vụ (F49)</th>
                                <th>Ngày vào làm</th>
                                <th>Tài khoản (F50)</th>
                                <th>Trạng thái</th>
                                <th class="text-end">Thao tác (F46, F47)</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td colspan="9" class="text-center text-muted py-5">
                                    <i class="bi bi-people fs-1 d-block text-secondary mb-2 opacity-50"></i>
                                    <div class="fw-semibold">Chưa có hồ sơ nhân viên</div>
                                    <small class="text-muted">Nhấn "Thêm Nhân viên mới" để tạo hồ sơ nhân viên</small>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- TAB 2: QUẢN LÝ TÀI KHOẢN & MA TRẬN PHÂN QUYỀN (F04, F05, F50) -->
        <div class="tab-pane fade" id="tabTaiKhoanPhanQuyen" role="tabpanel">
            <div class="row g-4">
                <!-- Danh sách tài khoản (F05, F50) -->
                <div class="col-12 col-xl-7">
                    <div class="card-custom h-100">
                        <div class="card-header-custom">
                            <div>
                                <h6 class="fw-bold mb-0 text-dark">Danh sách Tài khoản Hệ thống (F05, F50)</h6>
                                <small class="text-muted">Mỗi nhân viên chỉ liên kết với tài khoản phù hợp • Mật khẩu mã hóa (NF02)</small>
                            </div>
                            <button type="button" class="btn btn-sm btn-cafe-primary" data-bs-toggle="modal" data-bs-target="#modalTaiKhoan">
                                <i class="bi bi-plus-lg"></i> Cấp tài khoản
                            </button>
                        </div>
                        <div class="table-responsive">
                            <table class="table table-cafe">
                                <thead>
                                    <tr>
                                        <th>Tên đăng nhập</th>
                                        <th>Nhân viên gắn kết (F50)</th>
                                        <th>Vai trò (F04)</th>
                                        <th>Trạng thái</th>
                                        <th class="text-end">Xử lý (F03, F05)</th>
                                    </tr>
                                </thead>
                                <tbody>
                            <tr>
                                <td colspan="7" class="text-center text-muted py-5">
                                    <i class="bi bi-shield-lock fs-1 d-block text-secondary mb-2 opacity-50"></i>
                                    <div class="fw-semibold">Chưa có tài khoản nào</div>
                                    <small class="text-muted">Nhấn "Cấp tài khoản mới" để tạo tài khoản đăng nhập</small>
                                </td>
                            </tr>
                        </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <!-- Bảng Ma trận Phân quyền (F04, NF03) -->
                <div class="col-12 col-xl-5">
                    <div class="card-custom h-100">
                        <div class="card-header-custom">
                            <div>
                                <h6 class="fw-bold mb-0 text-dark">Ma trận Phân quyền Vai trò (F04 / NF03)</h6>
                                <small class="text-muted">Nhân viên không được truy cập chức năng quản trị nếu không có quyền</small>
                            </div>
                        </div>
                        <div class="table-responsive">
                            <table class="table table-cafe text-center">
                                <thead>
                                    <tr>
                                        <th class="text-start">Phân hệ Nghiệp vụ</th>
                                        <th>Admin</th>
                                        <th>Quản lý</th>
                                        <th>Nhân viên</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td class="text-start fw-semibold">Quản lý Tài khoản & Phân quyền (F04, F05)</td>
                                        <td><i class="bi bi-check-circle-fill text-primary"></i></td>
                                        <td><i class="bi bi-dash-circle text-muted"></i></td>
                                        <td><i class="bi bi-dash-circle text-muted"></i></td>
                                    </tr>
                                    <tr>
                                        <td class="text-start fw-semibold">Quản lý Đồ uống, Menu & Giá (F06 - F12)</td>
                                        <td><i class="bi bi-check-circle-fill text-primary"></i></td>
                                        <td><i class="bi bi-check-circle-fill text-primary"></i></td>
                                        <td><span class="badge bg-light text-dark border">Chỉ xem (F13)</span></td>
                                    </tr>
                                    <tr>
                                        <td class="text-start fw-semibold">Bàn, Đặt bàn & Chuyển bàn (F14 - F26)</td>
                                        <td><i class="bi bi-check-circle-fill text-primary"></i></td>
                                        <td><i class="bi bi-check-circle-fill text-primary"></i></td>
                                        <td><i class="bi bi-check-circle-fill text-primary"></i></td>
                                    </tr>
                                    <tr>
                                        <td class="text-start fw-semibold">Gọi món & Thanh toán Hóa đơn (F27 - F44)</td>
                                        <td><i class="bi bi-check-circle-fill text-primary"></i></td>
                                        <td><i class="bi bi-check-circle-fill text-primary"></i></td>
                                        <td><i class="bi bi-check-circle-fill text-primary"></i></td>
                                    </tr>
                                    <tr>
                                        <td class="text-start fw-semibold">Áp dụng Giảm giá đặc biệt (F38)</td>
                                        <td><i class="bi bi-check-circle-fill text-primary"></i></td>
                                        <td><i class="bi bi-check-circle-fill text-primary"></i></td>
                                        <td><i class="bi bi-dash-circle text-muted"></i></td>
                                    </tr>
                                    <tr>
                                        <td class="text-start fw-semibold">Quản lý Nhân sự & Doanh thu (F45 - F58)</td>
                                        <td><i class="bi bi-check-circle-fill text-primary"></i></td>
                                        <td><i class="bi bi-check-circle-fill text-primary"></i></td>
                                        <td><i class="bi bi-dash-circle text-muted"></i></td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- MODAL THÊM / SỬA HỒ SƠ NHÂN VIÊN (F45, F46) -->
    <div class="modal fade" id="modalThemNhanVien" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg modal-dialog-centered">
            <div class="modal-content border-0 shadow">
                <div class="modal-header bg-primary text-white">
                    <h6 class="modal-title fw-bold"><i class="bi bi-person-vcard me-2"></i>Hồ sơ Nhân viên (F45 / F46)</h6>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body p-4">
                    <div class="row g-3">
                        <div class="col-md-4">
                            <label class="form-label small fw-semibold">Mã nhân viên <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" placeholder="Hệ thống tự cấp..." placeholder="Không trùng..." />
                        </div>
                        <div class="col-md-5">
                            <label class="form-label small fw-semibold">Họ và tên <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" placeholder="Nhập họ tên nhân viên..." />
                        </div>
                        <div class="col-md-3">
                            <label class="form-label small fw-semibold">Giới tính</label>
                            <select class="form-select">
                                <option selected>Nam</option>
                                <option>Nữ</option>
                            </select>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label small fw-semibold">Ngày sinh</label>
                            <input type="date" class="form-control" value="2003-06-15" />
                        </div>
                        <div class="col-md-4">
                            <label class="form-label small fw-semibold">Số điện thoại <span class="text-danger">*</span></label>
                            <input type="tel" class="form-control" placeholder="Số ĐT hợp lệ..." />
                        </div>
                        <div class="col-md-4">
                            <label class="form-label small fw-semibold">Email</label>
                            <input type="email" class="form-control" placeholder="ten@n9cafe.vn" />
                        </div>
                        <div class="col-md-4">
                            <label class="form-label small fw-semibold">Chức vụ (F49) <span class="text-danger">*</span></label>
                            <select class="form-select">
                                <option>Quản lý cửa hàng</option>
                                <option selected>Thu ngân & Phục vụ</option>
                                <option>Pha chế (Barista)</option>
                            </select>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label small fw-semibold">Ngày vào làm</label>
                            <input type="date" class="form-control" value="2026-11-09" />
                        </div>
                        <div class="col-md-4">
                            <label class="form-label small fw-semibold">Trạng thái làm việc</label>
                            <select class="form-select">
                                <option selected>Đang làm việc</option>
                                <option>Tạm nghỉ phép</option>
                                <option>Đã nghỉ việc (F47)</option>
                            </select>
                        </div>
                        <div class="col-12">
                            <label class="form-label small fw-semibold">Địa chỉ thường trú</label>
                            <input type="text" class="form-control" placeholder="Nhập số nhà, đường, quận/huyện..." />
                        </div>
                    </div>
                </div>
                <div class="modal-footer bg-light">
                    <button type="button" class="btn btn-sm btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="button" class="btn btn-sm btn-cafe-primary" data-bs-dismiss="modal"><i class="bi bi-save me-1"></i>Lưu hồ sơ nhân viên</button>
                </div>
            </div>
        </div>
    </div>

    <!-- MODAL TẠO / SỬA TÀI KHOẢN & GẮN NHÂN VIÊN (F04, F05, F50) -->
    <div class="modal fade" id="modalTaiKhoan" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow">
                <div class="modal-header bg-primary text-white">
                    <h6 class="modal-title fw-bold"><i class="bi bi-person-lock me-2"></i>Quản lý Tài khoản & Phân quyền (F04 / F05 / F50)</h6>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body p-4">
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Gắn với Nhân viên (F50) <span class="text-danger">*</span></label>
                        <select class="form-select">
                            <option selected>NV004 - Lê Văn Điều (Thu ngân)</option>
                            <option>NV002 - Nguyễn Anh Kỳ (Quản lý)</option>
                            <option>NV003 - Lư Quốc Thắng (Điều phối bàn)</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Tên đăng nhập <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" placeholder="Nhập username..." value="vandieu_pos" />
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Mật khẩu khởi tạo / Đặt lại (NF02)</label>
                        <input type="password" class="form-control" value="123456" />
                    </div>
                    <div class="row g-2">
                        <div class="col-6">
                            <label class="form-label small fw-semibold">Vai trò Phân quyền (F04)</label>
                            <select class="form-select">
                                <option>Admin (Toàn quyền)</option>
                                <option>Quản lý (Kinh doanh)</option>
                                <option selected>Nhân viên (Bán hàng)</option>
                            </select>
                        </div>
                        <div class="col-6">
                            <label class="form-label small fw-semibold">Trạng thái Tài khoản (F05)</label>
                            <select class="form-select">
                                <option selected>Đang hoạt động</option>
                                <option>Khóa tài khoản</option>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="modal-footer bg-light">
                    <button type="button" class="btn btn-sm btn-secondary" data-bs-dismiss="modal">Đóng</button>
                    <button type="button" class="btn btn-sm btn-cafe-primary" data-bs-dismiss="modal">Lưu tài khoản</button>
                </div>
            </div>
        </div>
    </div>

    <!-- MODAL QUẢN LÝ CHỨC VỤ (F49) -->
    <div class="modal fade" id="modalChucVu" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow">
                <div class="modal-header bg-primary text-white">
                    <h6 class="modal-title fw-bold"><i class="bi bi-briefcase me-2"></i>Quản lý Vị trí & Chức vụ làm việc (F49)</h6>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body p-4">
                    <div class="input-group mb-3">
                        <input type="text" class="form-control" placeholder="Nhập tên chức vụ mới..." />
                        <button class="btn btn-cafe-primary" type="button"><i class="bi bi-plus-lg"></i> Thêm</button>
                    </div>
                    <table class="table table-sm table-cafe border">
                        <thead>
                            <tr>
                                <th>Mã CV</th>
                                <th>Tên chức vụ</th>
                                <th class="text-end">Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td class="fw-bold text-primary">CV01</td>
                                <td>Quản lý cửa hàng</td>
                                <td class="text-end"><button type="button" class="btn btn-sm text-primary py-0"><i class="bi bi-pencil"></i></button></td>
                            </tr>
                            <tr>
                                <td class="fw-bold text-primary">CV02</td>
                                <td>Thu ngân & Phục vụ</td>
                                <td class="text-end"><button type="button" class="btn btn-sm text-primary py-0"><i class="bi bi-pencil"></i></button></td>
                            </tr>
                            <tr>
                                <td class="fw-bold text-primary">CV03</td>
                                <td>Pha chế (Barista)</td>
                                <td class="text-end"><button type="button" class="btn btn-sm text-primary py-0"><i class="bi bi-pencil"></i></button></td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</asp:Content>

