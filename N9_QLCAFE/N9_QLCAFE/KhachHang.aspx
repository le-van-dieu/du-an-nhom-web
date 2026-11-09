<%@ Page Title="Quản lý Khách hàng" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="KhachHang.aspx.cs" Inherits="N9_QLCAFE.KhachHang" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <!-- HEADER -->
    <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 gap-3">
        <div>
            <span class="badge badge-soft-blue mb-1">Phạm vi hệ thống (Mục 1.2 & 1.3) • Quản lý Khách hàng & Thành viên</span>
            <h4 class="fw-bold mb-0 text-dark">Quản lý Thông tin Khách hàng & Ưu đãi</h4>
        </div>
        <div class="d-flex flex-wrap gap-2">
            <a href="BanVaDatBan.aspx" class="btn btn-cafe-outline">
                <i class="bi bi-calendar2-plus me-1"></i>Đặt bàn cho khách (F21)
            </a>
            <button type="button" class="btn btn-cafe-primary" data-bs-toggle="modal" data-bs-target="#modalThemKhachHang">
                <i class="bi bi-person-plus-fill me-1"></i>Thêm Khách hàng mới
            </button>
        </div>
    </div>

    <!-- THỐNG KÊ NHANH KHÁCH HÀNG -->
    <div class="row g-3 mb-4">
        <div class="col-12 col-sm-6 col-xl-3">
            <div class="stat-card stat-card-primary">
                <div>
                    <div class="small opacity-75 fw-medium">Tổng khách hàng lưu trữ</div>
                    <h3 class="fw-bold my-1">348 khách</h3>
                    <div class="small opacity-75">+18 khách mới tuần này</div>
                </div>
                <div class="stat-icon">
                    <i class="bi bi-people-fill"></i>
                </div>
            </div>
        </div>
        <div class="col-12 col-sm-6 col-xl-3">
            <div class="stat-card">
                <div>
                    <div class="text-muted small fw-medium">Khách hàng thân thiết (VIP)</div>
                    <h3 class="fw-bold my-1 text-primary">56 khách</h3>
                    <div class="small text-muted">Ưu đãi giảm giá 10% (F38)</div>
                </div>
                <div class="stat-icon">
                    <i class="bi bi-award-fill"></i>
                </div>
            </div>
        </div>
        <div class="col-12 col-sm-6 col-xl-3">
            <div class="stat-card">
                <div>
                    <div class="text-muted small fw-medium">Khách đặt bàn hôm nay (F26)</div>
                    <h3 class="fw-bold my-1 text-dark">12 lượt</h3>
                    <div class="small text-success">Đã xác nhận 10 lượt</div>
                </div>
                <div class="stat-icon">
                    <i class="bi bi-calendar2-check"></i>
                </div>
            </div>
        </div>
        <div class="col-12 col-sm-6 col-xl-3">
            <div class="stat-card">
                <div>
                    <div class="text-muted small fw-medium">Tỷ lệ khách quay lại</div>
                    <h3 class="fw-bold my-1 text-primary">68.5%</h3>
                    <div class="small text-muted">Theo lịch sử hóa đơn (F44)</div>
                </div>
                <div class="stat-icon">
                    <i class="bi bi-arrow-repeat"></i>
                </div>
            </div>
        </div>
    </div>

    <!-- THANH TÌM KIẾM & BỘ LỌC -->
    <div class="card-custom p-3 mb-4">
        <div class="row g-3 align-items-center">
            <div class="col-12 col-md-5">
                <div class="input-group">
                    <span class="input-group-text bg-light text-primary border-end-0"><i class="bi bi-search"></i></span>
                    <input type="text" class="form-control border-start-0" placeholder="Tìm khách hàng theo tên, số điện thoại hoặc mã KH..." />
                </div>
            </div>
            <div class="col-6 col-md-4">
                <select class="form-select">
                    <option selected>-- Tất cả hạng thành viên --</option>
                    <option>Khách VIP (Giảm 10% - F38)</option>
                    <option>Thành viên Thân thiết (Giảm 5%)</option>
                    <option>Khách vãng lai / Mới</option>
                </select>
            </div>
            <div class="col-6 col-md-3 text-end">
                <button type="button" class="btn btn-cafe-outline w-100">
                    <i class="bi bi-funnel me-1"></i>Lọc danh sách
                </button>
            </div>
        </div>
    </div>

    <!-- BẢNG DANH SÁCH KHÁCH HÀNG -->
    <div class="card-custom">
        <div class="card-header-custom">
            <div>
                <h6 class="fw-bold mb-0 text-dark">Danh sách Khách hàng đặt bàn & sử dụng dịch vụ</h6>
                <small class="text-muted">Liên kết trực tiếp với lịch sử Đặt bàn (F21 - F26) và Chương trình Giảm giá thanh toán (F38)</small>
            </div>
            <span class="badge badge-soft-blue">Hiển thị: 5 khách hàng tiêu biểu</span>
        </div>
        <div class="table-responsive">
            <table class="table table-cafe">
                <thead>
                    <tr>
                        <th>Mã KH</th>
                        <th>Họ tên khách hàng</th>
                        <th>Số điện thoại</th>
                        <th>Hạng thành viên</th>
                        <th class="text-center">Số lần đến</th>
                        <th class="text-end">Tổng chi tiêu</th>
                        <th>Lần cuối giao dịch</th>
                        <th class="text-end">Thao tác</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td class="fw-bold text-primary">KH001</td>
                        <td>
                            <div class="fw-bold text-dark">Trần Minh Tâm</div>
                            <small class="text-muted">Khách hay đặt bàn họp nhóm tầng 1</small>
                        </td>
                        <td class="fw-semibold">0908.234.567</td>
                        <td><span class="badge bg-primary"><i class="bi bi-star-fill me-1"></i>Khách VIP (-10%)</span></td>
                        <td class="text-center fw-bold">18 lần</td>
                        <td class="text-end fw-bold text-primary">3.450.000 đ</td>
                        <td>09/11/2026 (#DB012)</td>
                        <td class="text-end">
                            <button type="button" class="btn btn-sm btn-cafe-outline me-1" data-bs-toggle="modal" data-bs-target="#modalThemKhachHang">
                                <i class="bi bi-pencil-square"></i> Sửa
                            </button>
                            <a href="BanVaDatBan.aspx" class="btn btn-sm btn-cafe-primary">Đặt bàn</a>
                        </td>
                    </tr>
                    <tr>
                        <td class="fw-bold text-primary">KH002</td>
                        <td>
                            <div class="fw-bold text-dark">Lê Hoàng Nam</div>
                            <small class="text-muted">Thích khu vực Ban công tầng 2</small>
                        </td>
                        <td class="fw-semibold">0912.888.999</td>
                        <td><span class="badge bg-primary"><i class="bi bi-star-fill me-1"></i>Khách VIP (-10%)</span></td>
                        <td class="text-center fw-bold">14 lần</td>
                        <td class="text-end fw-bold text-primary">2.890.000 đ</td>
                        <td>09/11/2026 (#DB014)</td>
                        <td class="text-end">
                            <button type="button" class="btn btn-sm btn-cafe-outline me-1" data-bs-toggle="modal" data-bs-target="#modalThemKhachHang">
                                <i class="bi bi-pencil-square"></i> Sửa
                            </button>
                            <a href="BanVaDatBan.aspx" class="btn btn-sm btn-cafe-primary">Đặt bàn</a>
                        </td>
                    </tr>
                    <tr>
                        <td class="fw-bold text-primary">KH003</td>
                        <td>
                            <div class="fw-bold text-dark">Phạm Thu Hà</div>
                            <small class="text-muted">Hay gọi Bạc Xỉu Kem Muối</small>
                        </td>
                        <td class="fw-semibold">0987.654.321</td>
                        <td><span class="badge badge-soft-blue">Thân thiết (-5%)</span></td>
                        <td class="text-center fw-bold">9 lần</td>
                        <td class="text-end fw-bold text-primary">1.120.000 đ</td>
                        <td>09/11/2026 (#DH1018)</td>
                        <td class="text-end">
                            <button type="button" class="btn btn-sm btn-cafe-outline me-1" data-bs-toggle="modal" data-bs-target="#modalThemKhachHang">
                                <i class="bi bi-pencil-square"></i> Sửa
                            </button>
                            <a href="BanVaDatBan.aspx" class="btn btn-sm btn-cafe-primary">Đặt bàn</a>
                        </td>
                    </tr>
                    <tr>
                        <td class="fw-bold text-primary">KH004</td>
                        <td>
                            <div class="fw-bold text-dark">Đặng Ngọc Lan</div>
                            <small class="text-muted">Khách đặt mang đi buổi sáng</small>
                        </td>
                        <td class="fw-semibold">0976.123.456</td>
                        <td><span class="badge badge-soft-blue">Thân thiết (-5%)</span></td>
                        <td class="text-center fw-bold">7 lần</td>
                        <td class="text-end fw-bold text-primary">680.000 đ</td>
                        <td>08/11/2026 (#HD2039)</td>
                        <td class="text-end">
                            <button type="button" class="btn btn-sm btn-cafe-outline me-1" data-bs-toggle="modal" data-bs-target="#modalThemKhachHang">
                                <i class="bi bi-pencil-square"></i> Sửa
                            </button>
                            <a href="BanVaDatBan.aspx" class="btn btn-sm btn-cafe-primary">Đặt bàn</a>
                        </td>
                    </tr>
                    <tr>
                        <td class="fw-bold text-muted">KH005</td>
                        <td>
                            <div class="fw-bold text-dark">Nguyễn Quốc Bảo</div>
                            <small class="text-muted">Ghi chú: 1 lần No-show (#DB009)</small>
                        </td>
                        <td class="fw-semibold">0933.111.222</td>
                        <td><span class="badge bg-light text-dark border">Khách mới</span></td>
                        <td class="text-center">1 lần</td>
                        <td class="text-end fw-semibold">145.000 đ</td>
                        <td>05/11/2026</td>
                        <td class="text-end">
                            <button type="button" class="btn btn-sm btn-cafe-outline me-1" data-bs-toggle="modal" data-bs-target="#modalThemKhachHang">
                                <i class="bi bi-pencil-square"></i> Sửa
                            </button>
                            <a href="BanVaDatBan.aspx" class="btn btn-sm btn-cafe-primary">Đặt bàn</a>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>

    <!-- MODAL THÊM / SỬA KHÁCH HÀNG -->
    <div class="modal fade" id="modalThemKhachHang" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow">
                <div class="modal-header bg-primary text-white">
                    <h6 class="modal-title fw-bold"><i class="bi bi-person-heart me-2"></i>Thông tin Khách hàng</h6>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body p-4">
                    <div class="row g-3">
                        <div class="col-md-4">
                            <label class="form-label small fw-semibold">Mã KH</label>
                            <input type="text" class="form-control bg-light" value="KH006" readonly />
                        </div>
                        <div class="col-md-8">
                            <label class="form-label small fw-semibold">Họ và tên khách hàng <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" placeholder="Nhập tên khách hàng..." />
                        </div>
                        <div class="col-md-6">
                            <label class="form-label small fw-semibold">Số điện thoại <span class="text-danger">*</span></label>
                            <input type="tel" class="form-control" placeholder="VD: 0909xxxxxx" />
                        </div>
                        <div class="col-md-6">
                            <label class="form-label small fw-semibold">Hạng khách hàng (F38)</label>
                            <select class="form-select">
                                <option selected>Khách mới (Mặc định)</option>
                                <option>Thành viên Thân thiết (-5%)</option>
                                <option>Khách hàng VIP (-10%)</option>
                            </select>
                        </div>
                        <div class="col-12">
                            <label class="form-label small fw-semibold">Ghi chú sở thích / Đặt bàn</label>
                            <textarea class="form-control" rows="2" placeholder="VD: Thích ít ngọt, thường ngồi khu vực tầng 1..."></textarea>
                        </div>
                    </div>
                </div>
                <div class="modal-footer bg-light">
                    <button type="button" class="btn btn-sm btn-secondary" data-bs-dismiss="modal">Đóng</button>
                    <button type="button" class="btn btn-sm btn-cafe-primary" data-bs-dismiss="modal">Lưu thông tin khách</button>
                </div>
            </div>
        </div>
    </div>
</asp:Content>

