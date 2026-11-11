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
            <asp:LinkButton runat="server" CssClass="btn btn-cafe-outline" OnClick="NewAccount">
                <i class="bi bi-person-lock me-1"></i>Tạo Tài khoản (F05, F50)
            </asp:LinkButton>
            <asp:LinkButton ID="btnMoModalThem" runat="server" CssClass="btn btn-cafe-primary" OnClick="btnMoModalThem_Click">
                <i class="bi bi-person-plus-fill me-1"></i>Thêm Nhân viên mới (F45)
            </asp:LinkButton>
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
                    <asp:TextBox ID="txtTimKiem" runat="server" CssClass="form-control border-start-0" placeholder="Tìm mã NV, họ tên, SĐT (F48)..." />
                </div>
                <asp:DropDownList ID="ddlBoLocChucVu" runat="server" CssClass="form-select form-select-sm" style="width: 180px;" AutoPostBack="true" OnSelectedIndexChanged="btnTimKiem_Click">
                </asp:DropDownList>
                <asp:Button ID="btnTimKiem" runat="server" Text="Tìm" CssClass="btn btn-sm btn-cafe-primary" OnClick="btnTimKiem_Click" style="display:none;" />
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
                    <asp:Label ID="lblTongNhanSu" runat="server" CssClass="badge badge-soft-blue" Text="Tổng: 0 nhân sự" />
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
                            <asp:Repeater ID="rptNhanVien" runat="server">
                                <ItemTemplate>
                                    <tr>
                                        <td class="fw-bold text-primary"><%# Eval("MaNhanVien") %></td>
                                        <td>
                                            <div class="fw-semibold"><%# Eval("HoTen") %></div>
                                            <small class="text-muted"><%# Eval("NgaySinh", "{0:dd/MM/yyyy}") %></small>
                                        </td>
                                        <td><%# Eval("GioiTinh") %></td>
                                        <td>
                                            <div><i class="bi bi-telephone text-muted me-1"></i><%# Eval("SoDienThoai") %></div>
                                            <div><small class="text-muted"><%# Eval("Email") %></small></div>
                                            <div><small class="text-muted"><%# Eval("DiaChi") %></small></div>
                                        </td>
                                        <td><span class="badge bg-light text-dark border"><%# Eval("TenChucVu") %></span></td>
                                        <td><%# Eval("NgayVaoLam", "{0:dd/MM/yyyy}") %></td>
                                        <td>
                                            <%# Eval("TenDangNhap") != DBNull.Value ? "<span class='badge bg-success'>Đã cấp (" + Eval("TenDangNhap") + ")</span>" : "<span class='badge bg-warning text-dark'>Chưa có</span>" %>
                                        </td>
                                        <td>
                                            <span class='badge <%# Eval("TrangThaiLamViec").ToString() == "DangLamViec" ? "bg-primary" : "bg-secondary" %>'>
                                                <%# Eval("TrangThaiLamViec") %>
                                            </span>
                                        </td>
                                        <td class="text-end">
                                            <!-- Nút Sửa nhân viên -->
                                            <asp:LinkButton ID="btnEdit" runat="server" CssClass="btn btn-sm text-primary py-0" 
                                                            CommandName="EditNhanVien" CommandArgument='<%# Eval("MaNhanVien") %>' 
                                                            OnCommand="btnEditNhanVien_Command" title="Sửa">
                                                <i class="bi bi-pencil"></i>
                                            </asp:LinkButton>
                                            <!-- Nút Xóa / Chuyển nghỉ việc nhân viên (F47) -->
                                            <asp:LinkButton ID="btnDelete" runat="server" CssClass="btn btn-sm text-danger py-0 ms-1" 
                                                            CommandName="DeleteNhanVien" CommandArgument='<%# Eval("MaNhanVien") %>' 
                                                            OnCommand="btnDeleteNhanVien_Command" 
                                                            OnClientClick="return confirm('Bạn có chắc chắn muốn xóa hoặc chuyển nhân viên này sang trạng thái nghỉ việc?');" title="Xóa / Ngừng việc">
                                                <i class="bi bi-trash"></i>
                                            </asp:LinkButton>
                                        </td>
                                    </tr>
                                </ItemTemplate>
                            </asp:Repeater>
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
                            <asp:LinkButton runat="server" CssClass="btn btn-sm btn-cafe-primary" OnClick="NewAccount">
                                <i class="bi bi-plus-lg"></i> Cấp tài khoản
                            </asp:LinkButton>
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
                                    <asp:Repeater ID="rptTaiKhoan" runat="server">
                                        <ItemTemplate>
                                            <tr>
                                                <td class="fw-bold text-primary"><%# Eval("TenDangNhap") %></td>
                                                <td><%# Eval("HoTen") %> (<%# Eval("MaNhanVien") %>)</td>
                                                <td><span class="badge bg-info text-dark"><%# Eval("VaiTro") %></span></td>
                                                <td>
                                                    <%# Convert.ToInt32(Eval("TrangThaiKhoa")) == 0 ? "<span class='badge bg-success'>Hoạt động</span>" : "<span class='badge bg-danger'>Đã khóa</span>" %>
                                                </td>
                                                <td class="text-end">
                                                    <asp:LinkButton runat="server" CssClass="btn btn-sm text-primary py-0"
                                                        CommandArgument='<%# Eval("TenDangNhap") %>' OnCommand="EditAccount">Sửa</asp:LinkButton>
                                                    <asp:LinkButton ID="btnToggleLock" runat="server" CssClass="btn btn-sm text-danger py-0" 
                                                                    CommandName="ToggleLock" CommandArgument='<%# Eval("TenDangNhap") %>' 
                                                                    OnCommand="btnToggleLock_Command" title="Khóa/Mở khóa">
                                                        <i class="bi bi-lock"></i>
                                                    </asp:LinkButton>
                                                </td>
                                            </tr>
                                        </ItemTemplate>
                                    </asp:Repeater>
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
                                        <th>Nhân viên / Thu ngân</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td class="text-start fw-semibold">Nhân sự, tài khoản & phân quyền</td>
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
                                        <td class="text-start fw-semibold">Thống kê Doanh thu (F51 - F58)</td>
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
                            <asp:TextBox ID="txtMaNhanVien" runat="server" CssClass="form-control" placeholder="Tự sinh nếu trống..." />
                        </div>
                        <div class="col-md-5">
                            <label class="form-label small fw-semibold">Họ và tên <span class="text-danger">*</span></label>
                            <asp:TextBox ID="txtHoTenNhanVien" runat="server" CssClass="form-control" placeholder="Nhập họ tên nhân viên..." />
                        </div>
                        <div class="col-md-3">
                            <label class="form-label small fw-semibold">Giới tính</label>
                            <asp:DropDownList ID="ddlGioiTinh" runat="server" CssClass="form-select">
                                <asp:ListItem Text="Nam" Value="Nam" />
                                <asp:ListItem Text="Nữ" Value="Nữ" />
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label small fw-semibold">Ngày sinh</label>
                            <asp:TextBox ID="txtNgaySinh" runat="server" TextMode="Date" CssClass="form-control" />
                        </div>
                        <div class="col-md-4">
                            <label class="form-label small fw-semibold">Số điện thoại <span class="text-danger">*</span></label>
                            <asp:TextBox ID="txtSoDienThoai" runat="server" TextMode="Phone" CssClass="form-control" placeholder="Số ĐT hợp lệ..." />
                        </div>
                        <div class="col-md-4">
                            <label class="form-label small fw-semibold">Email</label>
                            <asp:TextBox ID="txtEmail" runat="server" TextMode="Email" CssClass="form-control" placeholder="ten@quanlycafe.com" />
                        </div>
                        <div class="col-md-4">
                            <label class="form-label small fw-semibold">Chức vụ (F49) <span class="text-danger">*</span></label>
                            <asp:DropDownList ID="ddlChucVuModal" runat="server" CssClass="form-select"></asp:DropDownList>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label small fw-semibold">Ngày vào làm</label>
                            <asp:TextBox ID="txtNgayVaoLam" runat="server" TextMode="Date" CssClass="form-control" />
                        </div>
                        <div class="col-md-4">
                            <label class="form-label small fw-semibold">Trạng thái làm việc</label>
                            <asp:DropDownList ID="ddlTrangThaiLamViec" runat="server" CssClass="form-select">
                                <asp:ListItem Text="Đang làm việc" Value="DangLamViec" />
                                <asp:ListItem Text="Tạm nghỉ phép" Value="TamNghi" />
                                <asp:ListItem Text="Đã nghỉ việc" Value="DaNghiViec" />
                            </asp:DropDownList>
                        </div>
                        <div class="col-12">
                            <label class="form-label small fw-semibold">Địa chỉ thường trú</label>
                            <asp:TextBox ID="txtDiaChi" runat="server" CssClass="form-control" placeholder="Nhập số nhà, đường, quận/huyện..." />
                        </div>
                    </div>
                </div>
                <div class="modal-footer bg-light">
                    <button type="button" class="btn btn-sm btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <asp:Button ID="btnSaveNhanVien" runat="server" Text="Lưu hồ sơ nhân viên" CssClass="btn btn-sm btn-cafe-primary" OnClick="btnSaveNhanVien_Click" />
                </div>
            </div>
        </div>
    </div>

    <!-- MODAL TẠO / SỬA TÀI KHOẢN & GẮN NHÂN VIÊN (F04, F05, F50) -->
    <asp:Label ID="accountMessage" runat="server" Visible="false" CssClass="alert alert-info d-block" role="status" />
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
                        <asp:DropDownList ID="ddlNhanVienTaiKhoan" runat="server" CssClass="form-select"></asp:DropDownList>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Tên đăng nhập <span class="text-danger">*</span></label>
                        <asp:TextBox ID="txtTenDangNhap" runat="server" CssClass="form-control" placeholder="Nhập username..." />
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Mật khẩu khởi tạo / Đặt lại (NF02)</label>
                        <asp:TextBox ID="txtMatKhau" runat="server" TextMode="Password" CssClass="form-control" autocomplete="new-password" placeholder="Tối thiểu 8 ký tự" />
                    </div>
                    <div class="row g-2">
                        <div class="col-6">
                            <label class="form-label small fw-semibold">Vai trò Phân quyền (F04)</label>
                            <asp:DropDownList ID="ddlVaiTro" runat="server" CssClass="form-select">
                                <asp:ListItem Text="Admin" Value="Admin" />
                                <asp:ListItem Text="Quản lý" Value="QuanLy" />
                                <asp:ListItem Text="ThuNgan" Value="ThuNgan" />
                                <asp:ListItem Text="NhanVien" Value="NhanVien" />
                            </asp:DropDownList>
                        </div>
                        <div class="col-6">
                            <label class="form-label small fw-semibold">Trạng thái Tài khoản (F05)</label>
                            <asp:DropDownList ID="ddlTrangThaiKhoa" runat="server" CssClass="form-select">
                                <asp:ListItem Text="Đang hoạt động" Value="0" />
                                <asp:ListItem Text="Khóa tài khoản" Value="1" />
                            </asp:DropDownList>
                        </div>
                    </div>
                </div>
                <div class="modal-footer bg-light">
                    <button type="button" class="btn btn-sm btn-secondary" data-bs-dismiss="modal">Đóng</button>
                    <asp:Button ID="btnSaveTaiKhoan" runat="server" Text="Lưu tài khoản" CssClass="btn btn-sm btn-cafe-primary" OnClick="btnSaveTaiKhoan_Click" />
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
                        <asp:TextBox ID="txtTenChucVuMoi" runat="server" CssClass="form-control" placeholder="Nhập tên chức vụ mới..." />
                        <asp:Button ID="btnThemChucVu" runat="server" Text="Thêm" CssClass="btn btn-cafe-primary" OnClick="btnSaveChucVu_Click" />
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
                            <asp:Repeater ID="rptChucVu" runat="server">
                                <ItemTemplate>
                                    <tr>
                                        <td class="fw-bold text-primary"><%# Eval("MaChucVu") %></td>
                                        <td><%# Eval("TenChucVu") %></td>
                                        <td class="text-end">
                                            <asp:LinkButton ID="btnEditCV" runat="server" CssClass="btn btn-sm text-primary py-0" 
                                                            CommandName="EditChucVu" CommandArgument='<%# Eval("MaChucVu") %>' 
                                                            OnCommand="btnEditChucVu_Command" title="Sửa tên chức vụ">
                                                <i class="bi bi-pencil"></i>
                                            </asp:LinkButton>
                                        </td>
                                    </tr>
                                </ItemTemplate>
                            </asp:Repeater>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
