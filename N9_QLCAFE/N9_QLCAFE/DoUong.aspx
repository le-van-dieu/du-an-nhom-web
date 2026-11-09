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
                    <span class="badge badge-soft-blue">Tổng: 0 sản phẩm</span>
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
                                <td colspan="7" class="text-center text-muted py-5">
                                    <i class="bi bi-cup-straw fs-1 d-block text-secondary mb-2 opacity-50"></i>
                                    <div class="fw-semibold">Chưa có đồ uống nào trong danh sách</div>
                                    <small class="text-muted">Nhấn "Thêm đồ uống mới" để thêm món vào hệ thống</small>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- TAB 2: HIỂN THỊ MENU TRỰC QUAN CHO NHÂN VIÊN (F13) -->
        <div class="tab-pane fade" id="tabLuoiMenu" role="tabpanel">
            <div class="card-custom p-5 text-center text-muted">
                <i class="bi bi-grid-3x3-gap fs-1 d-block text-secondary mb-2 opacity-50"></i>
                <div class="fw-semibold">Chưa có đồ uống nào trên Menu</div>
                <small class="text-muted">Các món đang ở trạng thái Còn hàng sẽ hiển thị trực quan tại đây</small>
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
                            <input type="text" class="form-control" placeholder="VD: DU010 (Không trùng)" placeholder="VD: DU001 (Không trùng)" />
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
                            <input type="number" class="form-control" placeholder="VD: 35000" placeholder="VD: 35000" />
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
                                <td colspan="4" class="text-center text-muted py-4">
                                    <small>Chưa có danh mục nào. Hãy nhập tên danh mục và nhấn Thêm.</small>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
