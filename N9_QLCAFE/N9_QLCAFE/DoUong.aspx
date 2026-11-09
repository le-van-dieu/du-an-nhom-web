<%@ Page Title="Quản lý Đồ uống & Menu" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="DoUong.aspx.cs" Inherits="N9_QLCAFE.DoUong" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <!-- HEADER -->
    <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 gap-3">
        <div>
            <span class="badge badge-soft-blue mb-1">Phân hệ F06 - F13 • Phụ trách: Nguyễn Anh Kỳ</span>
            <h4 class="fw-bold mb-0 text-dark">Quản lý Đồ uống & Danh mục Menu</h4>
        </div>
        <div class="d-flex gap-2">
            <button type="button" class="btn btn-cafe-outline" data-bs-toggle="modal" data-bs-target="#modalDanhMuc">
                <i class="bi bi-folder-plus me-1"></i>Quản lý Danh mục (F10)
            </button>
            <button type="button" class="btn btn-cafe-primary" data-bs-toggle="modal" data-bs-target="#modalThemDoUong">
                <i class="bi bi-plus-lg me-1"></i>Thêm đồ uống mới (F06)
            </button>
        </div>
    </div>

    <!-- THANH TÌM KIẾM & BỘ LỌC DANH MỤC (F09, F12, F13) -->
    <div class="card-custom p-3 mb-4">
        <div class="row g-3 align-items-center">
            <div class="col-12 col-md-4">
                <div class="input-group">
                    <span class="input-group-text bg-light text-primary border-end-0"><i class="bi bi-search"></i></span>
                    <input type="text" class="form-control border-start-0" placeholder="Tìm theo tên hoặc mã đồ uống (F09)..." />
                </div>
            </div>
            <div class="col-6 col-md-3">
                <select class="form-select">
                    <option selected>-- Tất cả danh mục (F10) --</option>
                    <option>DM01 - Cà phê truyền thống</option>
                    <option>DM02 - Cà phê pha máy (Espresso)</option>
                    <option>DM03 - Trà trái cây & Macchiato</option>
                    <option>DM04 - Đá xay / Freeze</option>
                    <option>DM05 - Bánh ngọt & Topping</option>
                </select>
            </div>
            <div class="col-6 col-md-3">
                <select class="form-select">
                    <option selected>-- Trạng thái kinh doanh (F12) --</option>
                    <option>Còn hàng (Đang bán)</option>
                    <option>Hết hàng tạm thời</option>
                    <option>Ngừng kinh doanh (F08)</option>
                </select>
            </div>
            <div class="col-12 col-md-2 text-md-end">
                <ul class="nav nav-pills nav-pills-blue justify-content-end" role="tablist">
                    <li class="nav-item" role="presentation">
                        <button class="nav-link active py-1 px-3" data-bs-toggle="tab" data-bs-target="#tabBang" type="button" title="Dạng bảng quản lý">
                            <i class="bi bi-table"></i>
                        </button>
                    </li>
                    <li class="nav-item" role="presentation">
                        <button class="nav-link py-1 px-3 me-0" data-bs-toggle="tab" data-bs-target="#tabLuoiMenu" type="button" title="Hiển thị Menu trực quan (F13)">
                            <i class="bi bi-grid-3x3-gap"></i> Menu (F13)
                        </button>
                    </li>
                </ul>
            </div>
        </div>
    </div>

    <div class="tab-content">
        <!-- TAB 1: BẢNG QUẢN LÝ ĐỒ UỐNG CHI TIẾT (F06 - F12) -->
        <div class="tab-pane fade show active" id="tabBang" role="tabpanel">
            <div class="card-custom">
                <div class="card-header-custom">
                    <div>
                        <h6 class="fw-bold mb-0">Danh sách Đồ uống trong hệ thống</h6>
                        <small class="text-muted">Quy tắc: Mã đồ uống không trùng • Giá bán &gt; 0 • Đồ uống đã có giao dịch chỉ chuyển sang Ngừng kinh doanh</small>
                    </div>
                    <span class="badge badge-soft-blue">Tổng: 6 sản phẩm mẫu</span>
                </div>
                <div class="table-responsive">
                    <table class="table table-cafe">
                        <thead>
                            <tr>
                                <th>Mã ĐU</th>
                                <th>Hình ảnh</th>
                                <th>Tên đồ uống & Mô tả</th>
                                <th>Danh mục</th>
                                <th>Giá bán (F11)</th>
                                <th>Trạng thái (F12)</th>
                                <th class="text-end">Thao tác (F07, F08)</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td class="fw-bold text-primary">DU001</td>
                                <td>
                                    <div class="rounded-3 bg-primary bg-opacity-10 text-primary d-flex align-items-center justify-content-center" style="width: 46px; height: 46px;">
                                        <i class="bi bi-cup-hot-fill fs-5"></i>
                                    </div>
                                </td>
                                <td>
                                    <div class="fw-bold text-dark">Cà phê Sữa Đá Sài Gòn</div>
                                    <small class="text-muted">Hạt Robusta nguyên chất pha phin truyền thống kết hợp sữa đặc</small>
                                </td>
                                <td><span class="badge badge-soft-blue">Cà phê truyền thống</span></td>
                                <td class="fw-bold text-primary">29.000 đ</td>
                                <td><span class="badge badge-soft-success"><i class="bi bi-check-circle me-1"></i>Còn hàng</span></td>
                                <td class="text-end">
                                    <button type="button" class="btn btn-sm btn-cafe-outline me-1" data-bs-toggle="modal" data-bs-target="#modalThemDoUong" title="Sửa thông tin & giá (F07, F11)">
                                        <i class="bi bi-pencil-square"></i> Sửa
                                    </button>
                                    <button type="button" class="btn btn-sm btn-outline-danger" title="Ngừng kinh doanh (F08)">
                                        <i class="bi bi-slash-circle"></i>
                                    </button>
                                </td>
                            </tr>
                            <tr>
                                <td class="fw-bold text-primary">DU002</td>
                                <td>
                                    <div class="rounded-3 bg-primary bg-opacity-10 text-primary d-flex align-items-center justify-content-center" style="width: 46px; height: 46px;">
                                        <i class="bi bi-cup-straw fs-5"></i>
                                    </div>
                                </td>
                                <td>
                                    <div class="fw-bold text-dark">Bạc Xỉu Kem Muối</div>
                                    <small class="text-muted">Sữa tươi béo ngậy hòa quyện espresso nhẹ và lớp kem muối biển</small>
                                </td>
                                <td><span class="badge badge-soft-blue">Cà phê truyền thống</span></td>
                                <td class="fw-bold text-primary">35.000 đ</td>
                                <td><span class="badge badge-soft-success"><i class="bi bi-check-circle me-1"></i>Còn hàng</span></td>
                                <td class="text-end">
                                    <button type="button" class="btn btn-sm btn-cafe-outline me-1" data-bs-toggle="modal" data-bs-target="#modalThemDoUong">
                                        <i class="bi bi-pencil-square"></i> Sửa
                                    </button>
                                    <button type="button" class="btn btn-sm btn-outline-danger">
                                        <i class="bi bi-slash-circle"></i>
                                    </button>
                                </td>
                            </tr>
                            <tr>
                                <td class="fw-bold text-primary">DU003</td>
                                <td>
                                    <div class="rounded-3 bg-primary bg-opacity-10 text-primary d-flex align-items-center justify-content-center" style="width: 46px; height: 46px;">
                                        <i class="bi bi-cup-fill fs-5"></i>
                                    </div>
                                </td>
                                <td>
                                    <div class="fw-bold text-dark">Caramel Macchiato</div>
                                    <small class="text-muted">Espresso Arabica chiết xuất chuẩn Ý cùng sốt Caramel thơm dịu</small>
                                </td>
                                <td><span class="badge badge-soft-blue">Cà phê pha máy</span></td>
                                <td class="fw-bold text-primary">45.000 đ</td>
                                <td><span class="badge badge-soft-success"><i class="bi bi-check-circle me-1"></i>Còn hàng</span></td>
                                <td class="text-end">
                                    <button type="button" class="btn btn-sm btn-cafe-outline me-1" data-bs-toggle="modal" data-bs-target="#modalThemDoUong">
                                        <i class="bi bi-pencil-square"></i> Sửa
                                    </button>
                                    <button type="button" class="btn btn-sm btn-outline-danger">
                                        <i class="bi bi-slash-circle"></i>
                                    </button>
                                </td>
                            </tr>
                            <tr>
                                <td class="fw-bold text-primary">DU005</td>
                                <td>
                                    <div class="rounded-3 bg-primary bg-opacity-10 text-primary d-flex align-items-center justify-content-center" style="width: 46px; height: 46px;">
                                        <i class="bi bi-cup-straw fs-5"></i>
                                    </div>
                                </td>
                                <td>
                                    <div class="fw-bold text-dark">Trà Đào Cam Sả</div>
                                    <small class="text-muted">Trà đen ủ lạnh, đào miếng giòn ngọt, cam vàng và hương sả tươi</small>
                                </td>
                                <td><span class="badge badge-soft-blue">Trà trái cây</span></td>
                                <td class="fw-bold text-primary">39.000 đ</td>
                                <td><span class="badge badge-soft-success"><i class="bi bi-check-circle me-1"></i>Còn hàng</span></td>
                                <td class="text-end">
                                    <button type="button" class="btn btn-sm btn-cafe-outline me-1" data-bs-toggle="modal" data-bs-target="#modalThemDoUong">
                                        <i class="bi bi-pencil-square"></i> Sửa
                                    </button>
                                    <button type="button" class="btn btn-sm btn-outline-danger">
                                        <i class="bi bi-slash-circle"></i>
                                    </button>
                                </td>
                            </tr>
                            <tr>
                                <td class="fw-bold text-primary">DU007</td>
                                <td>
                                    <div class="rounded-3 bg-primary bg-opacity-10 text-primary d-flex align-items-center justify-content-center" style="width: 46px; height: 46px;">
                                        <i class="bi bi-snow2 fs-5"></i>
                                    </div>
                                </td>
                                <td>
                                    <div class="fw-bold text-dark">Cookies & Cream Đá Xay</div>
                                    <small class="text-muted">Bánh Oreo xay nhuyễn cùng sữa tươi và kem tươi whipping</small>
                                </td>
                                <td><span class="badge badge-soft-blue">Đá xay / Freeze</span></td>
                                <td class="fw-bold text-primary">49.000 đ</td>
                                <td><span class="badge badge-soft-warning"><i class="bi bi-exclamation-triangle me-1"></i>Hết hàng</span></td>
                                <td class="text-end">
                                    <button type="button" class="btn btn-sm btn-cafe-outline me-1" data-bs-toggle="modal" data-bs-target="#modalThemDoUong">
                                        <i class="bi bi-pencil-square"></i> Sửa
                                    </button>
                                    <button type="button" class="btn btn-sm btn-outline-danger">
                                        <i class="bi bi-slash-circle"></i>
                                    </button>
                                </td>
                            </tr>
                            <tr>
                                <td class="fw-bold text-muted">DU009</td>
                                <td>
                                    <div class="rounded-3 bg-secondary bg-opacity-10 text-secondary d-flex align-items-center justify-content-center" style="width: 46px; height: 46px;">
                                        <i class="bi bi-cup fs-5"></i>
                                    </div>
                                </td>
                                <td>
                                    <div class="fw-bold text-muted text-decoration-line-through">Cà phê Trứng Hà Nội (Theo mùa)</div>
                                    <small class="text-muted">Đã phát sinh giao dịch cũ → Chuyển trạng thái Ngừng kinh doanh</small>
                                </td>
                                <td><span class="badge bg-light text-secondary border">Cà phê truyền thống</span></td>
                                <td class="fw-semibold text-muted">42.000 đ</td>
                                <td><span class="badge badge-soft-danger">Ngừng kinh doanh</span></td>
                                <td class="text-end">
                                    <button type="button" class="btn btn-sm btn-cafe-outline" data-bs-toggle="modal" data-bs-target="#modalThemDoUong">
                                        <i class="bi bi-arrow-counterclockwise"></i> Mở bán lại
                                    </button>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- TAB 2: HIỂN THỊ MENU TRỰC QUAN CHO NHÂN VIÊN (F13) -->
        <div class="tab-pane fade" id="tabLuoiMenu" role="tabpanel">
            <div class="row g-3">
                <div class="col-12 col-sm-6 col-md-4 col-xl-3">
                    <div class="drink-card">
                        <div class="drink-thumb">
                            <i class="bi bi-cup-hot-fill"></i>
                            <span class="badge badge-soft-success position-absolute top-0 end-0 m-2">Còn hàng</span>
                        </div>
                        <div class="p-3">
                            <div class="small text-primary fw-semibold">DU001 • Cà phê truyền thống</div>
                            <h6 class="fw-bold my-1">Cà phê Sữa Đá Sài Gòn</h6>
                            <p class="small text-muted mb-2">Hạt Robusta nguyên chất pha phin đậm đà</p>
                            <div class="d-flex justify-content-between align-items-center pt-2 border-top">
                                <span class="fw-bold text-primary fs-6">29.000 đ</span>
                                <a href="GoiMonThanhToan.aspx" class="btn btn-sm btn-cafe-primary">Chọn món</a>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-12 col-sm-6 col-md-4 col-xl-3">
                    <div class="drink-card">
                        <div class="drink-thumb">
                            <i class="bi bi-cup-straw"></i>
                            <span class="badge badge-soft-success position-absolute top-0 end-0 m-2">Còn hàng</span>
                        </div>
                        <div class="p-3">
                            <div class="small text-primary fw-semibold">DU002 • Cà phê truyền thống</div>
                            <h6 class="fw-bold my-1">Bạc Xỉu Kem Muối</h6>
                            <p class="small text-muted mb-2">Kem muối biển mặn nhẹ hòa quyện sữa tươi</p>
                            <div class="d-flex justify-content-between align-items-center pt-2 border-top">
                                <span class="fw-bold text-primary fs-6">35.000 đ</span>
                                <a href="GoiMonThanhToan.aspx" class="btn btn-sm btn-cafe-primary">Chọn món</a>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-12 col-sm-6 col-md-4 col-xl-3">
                    <div class="drink-card">
                        <div class="drink-thumb">
                            <i class="bi bi-cup-straw"></i>
                            <span class="badge badge-soft-success position-absolute top-0 end-0 m-2">Còn hàng</span>
                        </div>
                        <div class="p-3">
                            <div class="small text-primary fw-semibold">DU005 • Trà trái cây</div>
                            <h6 class="fw-bold my-1">Trà Đào Cam Sả</h6>
                            <p class="small text-muted mb-2">Trà đen ủ lạnh, đào miếng giòn ngọt</p>
                            <div class="d-flex justify-content-between align-items-center pt-2 border-top">
                                <span class="fw-bold text-primary fs-6">39.000 đ</span>
                                <a href="GoiMonThanhToan.aspx" class="btn btn-sm btn-cafe-primary">Chọn món</a>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-12 col-sm-6 col-md-4 col-xl-3">
                    <div class="drink-card opacity-75">
                        <div class="drink-thumb">
                            <i class="bi bi-snow2"></i>
                            <span class="badge badge-soft-warning position-absolute top-0 end-0 m-2">Hết hàng</span>
                        </div>
                        <div class="p-3">
                            <div class="small text-muted fw-semibold">DU007 • Đá xay / Freeze</div>
                            <h6 class="fw-bold my-1">Cookies & Cream Đá Xay</h6>
                            <p class="small text-muted mb-2">Không cho phép gọi món đã hết hàng</p>
                            <div class="d-flex justify-content-between align-items-center pt-2 border-top">
                                <span class="fw-bold text-muted fs-6">49.000 đ</span>
                                <button type="button" class="btn btn-sm btn-secondary" disabled>Tạm hết</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- MODAL THÊM / CẬP NHẬT ĐỒ UỐNG (F06, F07, F11, F12) -->
    <div class="modal fade" id="modalThemDoUong" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg modal-dialog-centered">
            <div class="modal-content border-0 shadow">
                <div class="modal-header bg-primary text-white">
                    <h6 class="modal-title fw-bold"><i class="bi bi-cup-hot me-2"></i>Thông tin Đồ uống (F06 / F07 / F11)</h6>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body p-4">
                    <div class="row g-3">
                        <div class="col-md-4">
                            <label class="form-label small fw-semibold">Mã đồ uống <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" placeholder="VD: DU010 (Không trùng)" value="DU010" />
                        </div>
                        <div class="col-md-8">
                            <label class="form-label small fw-semibold">Tên đồ uống <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" placeholder="Nhập tên đồ uống..." />
                        </div>
                        <div class="col-md-6">
                            <label class="form-label small fw-semibold">Danh mục đồ uống (F10) <span class="text-danger">*</span></label>
                            <select class="form-select">
                                <option selected>DM01 - Cà phê truyền thống</option>
                                <option>DM02 - Cà phê pha máy (Espresso)</option>
                                <option>DM03 - Trà trái cây & Macchiato</option>
                                <option>DM04 - Đá xay / Freeze</option>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label small fw-semibold">Giá bán (VNĐ - Lớn hơn 0) (F11) <span class="text-danger">*</span></label>
                            <input type="number" class="form-control" placeholder="VD: 35000" value="35000" />
                        </div>
                        <div class="col-md-6">
                            <label class="form-label small fw-semibold">Hình ảnh minh họa</label>
                            <input type="file" class="form-control" />
                        </div>
                        <div class="col-md-6">
                            <label class="form-label small fw-semibold">Trạng thái kinh doanh (F12)</label>
                            <select class="form-select">
                                <option selected>Còn hàng (Đang phục vụ)</option>
                                <option>Hết hàng tạm thời</option>
                                <option>Ngừng kinh doanh (F08)</option>
                            </select>
                        </div>
                        <div class="col-12">
                            <label class="form-label small fw-semibold">Mô tả công thức / hương vị</label>
                            <textarea class="form-control" rows="3" placeholder="Nhập mô tả chi tiết sản phẩm..."></textarea>
                        </div>
                    </div>
                </div>
                <div class="modal-footer bg-light">
                    <button type="button" class="btn btn-sm btn-secondary" data-bs-dismiss="modal">Hủy bỏ</button>
                    <button type="button" class="btn btn-sm btn-cafe-primary" data-bs-dismiss="modal"><i class="bi bi-save me-1"></i>Lưu thông tin đồ uống</button>
                </div>
            </div>
        </div>
    </div>

    <!-- MODAL QUẢN LÝ DANH MỤC (F10) -->
    <div class="modal fade" id="modalDanhMuc" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow">
                <div class="modal-header bg-primary text-white">
                    <h6 class="modal-title fw-bold"><i class="bi bi-folder2-open me-2"></i>Quản lý Danh mục Đồ uống (F10)</h6>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body p-4">
                    <div class="input-group mb-3">
                        <input type="text" class="form-control" placeholder="Nhập tên danh mục mới..." />
                        <button class="btn btn-cafe-primary" type="button"><i class="bi bi-plus-lg"></i> Thêm</button>
                    </div>
                    <table class="table table-sm table-cafe border">
                        <thead>
                            <tr>
                                <th>Mã DM</th>
                                <th>Tên danh mục</th>
                                <th class="text-center">Số món</th>
                                <th class="text-end">Xử lý</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td class="fw-bold text-primary">DM01</td>
                                <td>Cà phê truyền thống</td>
                                <td class="text-center">8</td>
                                <td class="text-end">
                                    <button type="button" class="btn btn-sm text-primary py-0"><i class="bi bi-pencil"></i></button>
                                    <button type="button" class="btn btn-sm text-danger py-0"><i class="bi bi-trash"></i></button>
                                </td>
                            </tr>
                            <tr>
                                <td class="fw-bold text-primary">DM02</td>
                                <td>Cà phê pha máy</td>
                                <td class="text-center">6</td>
                                <td class="text-end">
                                    <button type="button" class="btn btn-sm text-primary py-0"><i class="bi bi-pencil"></i></button>
                                    <button type="button" class="btn btn-sm text-danger py-0"><i class="bi bi-trash"></i></button>
                                </td>
                            </tr>
                            <tr>
                                <td class="fw-bold text-primary">DM03</td>
                                <td>Trà trái cây & Macchiato</td>
                                <td class="text-center">10</td>
                                <td class="text-end">
                                    <button type="button" class="btn btn-sm text-primary py-0"><i class="bi bi-pencil"></i></button>
                                    <button type="button" class="btn btn-sm text-danger py-0"><i class="bi bi-trash"></i></button>
                                </td>
                            </tr>
                            <tr>
                                <td class="fw-bold text-primary">DM04</td>
                                <td>Đá xay / Freeze</td>
                                <td class="text-center">5</td>
                                <td class="text-end">
                                    <button type="button" class="btn btn-sm text-primary py-0"><i class="bi bi-pencil"></i></button>
                                    <button type="button" class="btn btn-sm text-danger py-0"><i class="bi bi-trash"></i></button>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
