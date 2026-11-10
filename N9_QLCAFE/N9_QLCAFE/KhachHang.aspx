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
            <asp:LinkButton ID="btnMoModalThem" runat="server" CssClass="btn btn-cafe-primary" OnClick="btnMoModalThem_Click">
                <i class="bi bi-person-plus-fill me-1"></i>Thêm Khách hàng mới
            </asp:LinkButton>
        </div>
    </div>

    <!-- THỐNG KÊ NHANH KHÁCH HÀNG -->
    <div class="row g-3 mb-4">
        <div class="col-12 col-sm-6 col-xl-3">
            <div class="stat-card stat-card-primary">
                <div>
                    <div class="small opacity-75 fw-medium">Tổng khách hàng lưu trữ</div>
                    <asp:Literal ID="litTongKhach" runat="server" Text="<h3 class='fw-bold my-1'>0 khách</h3>" />
                    <div class="small opacity-75">Đang hoạt động trong CSDL</div>
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
                    <asp:Literal ID="litKhachVIP" runat="server" Text="<h3 class='fw-bold my-1 text-primary'>0 khách</h3>" />
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
                    <asp:Literal ID="litDatBanHomNay" runat="server" Text="<h3 class='fw-bold my-1 text-dark'>0 lượt</h3>" />
                    <div class="small text-muted">Lịch hẹn trong ngày</div>
                </div>
                <div class="stat-icon">
                    <i class="bi bi-calendar2-check"></i>
                </div>
            </div>
        </div>
        <div class="col-12 col-sm-6 col-xl-3">
            <div class="stat-card">
                <div>
                    <div class="text-muted small fw-medium">Tổng doanh thu từ KH</div>
                    <asp:Literal ID="litTongChiTieu" runat="server" Text="<h3 class='fw-bold my-1 text-primary'>0 đ</h3>" />
                    <div class="small text-muted">Theo lịch sử hóa đơn (F44)</div>
                </div>
                <div class="stat-icon">
                    <i class="bi bi-cash-stack"></i>
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
                    <asp:TextBox ID="txtTimKiem" runat="server" CssClass="form-control border-start-0" placeholder="Tìm khách hàng theo tên, số điện thoại hoặc mã KH..." />
                </div>
            </div>
            <div class="col-6 col-md-4">
                <asp:DropDownList ID="ddlLocHang" runat="server" CssClass="form-select">
                    <asp:ListItem Text="-- Tất cả hạng thành viên --" Value="0" />
                    <asp:ListItem Text="Khách VIP (Giảm 10% - F38)" Value="VIP" />
                    <asp:ListItem Text="Thành viên Thân thiết (Giảm 5%)" Value="ThanThiet" />
                    <asp:ListItem Text="Khách vãng lai / Mới" Value="Moi" />
                </asp:DropDownList>
            </div>
            <div class="col-6 col-md-3 text-end">
                <asp:Button ID="btnTimKiem" runat="server" Text="Lọc danh sách" CssClass="btn btn-cafe-outline w-100" OnClick="btnTimKiem_Click" />
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
            <asp:Label ID="lblHienThi" runat="server" CssClass="badge badge-soft-blue" Text="Hiển thị: 0 khách hàng" />
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
                        <th>Ngày tạo tài khoản</th>
                        <th class="text-end">Thao tác</th>
                    </tr>
                </thead>
                <tbody>
                    <asp:Repeater ID="rptKhachHang" runat="server">
                        <ItemTemplate>
                            <tr>
                                <td class="fw-bold text-primary">KH<%# Eval("MaKhachHang") %></td>
                                <td><div class="fw-semibold"><%# Eval("TenKhachHang") %></div></td>
                                <td><i class="bi bi-telephone text-muted me-1"></i><%# Eval("SoDienThoai") %></td>
                                <td>
                                    <span class='badge <%# Eval("HangThanhVien").ToString() == "VIP" ? "bg-danger" : (Eval("HangThanhVien").ToString() == "ThanThiet" ? "bg-success" : "bg-secondary") %>'>
                                        <%# Eval("HangThanhVien") %>
                                    </span>
                                </td>
                                <td class="text-center"><span class="badge bg-light text-dark border"><%# Eval("SoLanDen") %> lần</span></td>
                                <td class="text-end fw-bold text-success"><%# string.Format("{0:N0} đ", Eval("TongChiTieu")) %></td>
                                <td><%# Eval("NgayTao", "{0:dd/MM/yyyy HH:mm}") %></td>
                                <td class="text-end">
                                    <asp:LinkButton ID="btnEdit" runat="server" CssClass="btn btn-sm text-primary py-0" 
                                                    CommandName="EditKH" CommandArgument='<%# Eval("MaKhachHang") %>' 
                                                    OnCommand="btnEditKhachHang_Command" title="Sửa">
                                        <i class="bi bi-pencil"></i>
                                    </asp:LinkButton>
                                    <asp:LinkButton ID="btnDelete" runat="server" CssClass="btn btn-sm text-danger py-0 ms-1" 
                                                    CommandName="DeleteKH" CommandArgument='<%# Eval("MaKhachHang") %>' 
                                                    OnCommand="btnDeleteKhachHang_Command" 
                                                    OnClientClick="return confirm('Bạn có chắc chắn muốn xóa khách hàng này?');" title="Xóa">
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
                            <asp:TextBox ID="txtMaKhachHang" runat="server" CssClass="form-control bg-light" placeholder="Tự sinh..." ReadOnly="true" />
                        </div>
                        <div class="col-md-8">
                            <label class="form-label small fw-semibold">Họ và tên khách hàng <span class="text-danger">*</span></label>
                            <asp:TextBox ID="txtTenKhachHang" runat="server" CssClass="form-control" placeholder="Nhập tên khách hàng..." />
                        </div>
                        <div class="col-md-6">
                            <label class="form-label small fw-semibold">Số điện thoại <span class="text-danger">*</span></label>
                            <asp:TextBox ID="txtSoDienThoai" runat="server" TextMode="Phone" CssClass="form-control" placeholder="VD: 0909xxxxxx" />
                        </div>
                        <div class="col-md-6">
                            <label class="form-label small fw-semibold">Hạng khách hàng (F38)</label>
                            <asp:DropDownList ID="ddlHangThanhVien" runat="server" CssClass="form-select">
                                <asp:ListItem Text="Khách mới (Mặc định)" Value="Moi" />
                                <asp:ListItem Text="Thành viên Thân thiết (-5%)" Value="ThanThiet" />
                                <asp:ListItem Text="Khách hàng VIP (-10%)" Value="VIP" />
                            </asp:DropDownList>
                        </div>
                        <div class="col-12">
                            <label class="form-label small fw-semibold">Ghi chú sở thích / Đặt bàn</label>
                            <asp:TextBox ID="txtGhiChu" runat="server" TextMode="MultiLine" Rows="2" CssClass="form-control" placeholder="VD: Thích ít ngọt, thường ngồi khu vực tầng 1..." />
                        </div>
                    </div>
                </div>
                <div class="modal-footer bg-light">
                    <button type="button" class="btn btn-sm btn-secondary" data-bs-dismiss="modal">Đóng</button>
                    <asp:Button ID="btnSaveKhachHang" runat="server" Text="Lưu thông tin khách" CssClass="btn btn-sm btn-cafe-primary" OnClick="btnSaveKhachHang_Click" />
                </div>
            </div>
        </div>
    </div>
</asp:Content>
