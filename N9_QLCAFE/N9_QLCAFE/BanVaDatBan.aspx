<%@ Page Title="Quản lý Bàn & Đặt bàn" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="BanVaDatBan.aspx.cs" Inherits="N9_QLCAFE.BanVaDatBan" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
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

        .badge-soft-empty { background: var(--success-soft); color: var(--success-text); border: 1px solid #a7f3d0; }
        .badge-soft-occupied { background: var(--info-soft); color: var(--info-text); border: 1px solid #bfdbfe; }
        .badge-soft-reserved { background: var(--warning-soft); color: var(--warning-text); border: 1px solid #fde68a; }

        .filter-container {
            background: #ffffff;
            border-radius: 14px;
            border: 1px solid #e2e8f0;
            padding: 12px 20px;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    
    <!-- THÔNG BÁO HỆ THỐNG -->
    <asp:Panel ID="pnlThongBao" runat="server" Visible="false" CssClass="alert alert-info alert-dismissible fade show" role="alert">
        <asp:Label ID="lblThongBao" runat="server"></asp:Label>
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </asp:Panel>

    <!-- HEADER & BUTTONS -->
    <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 gap-3">
        <div>
            <div class="d-flex align-items-center gap-2 mb-1">
                <span class="badge bg-primary-subtle text-primary border border-primary-subtle px-2 py-1 fw-semibold">
                    <i class="bi bi-shield-check me-1"></i>Hệ Thống Phục Vụ
                </span>
                <span class="text-secondary small">• Phân hệ Sơ đồ bàn & Đặt bàn trước</span>
            </div>
            <h3 class="fw-bold text-dark mb-0">Quản Lý Sơ Đồ Bàn & Lịch Hẹn Đặt Bàn</h3>
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

    <!-- THẺ KPI TỔNG QUAN -->
    <div class="row g-3 mb-4">
        <div class="col-6 col-xl-3">
            <div class="stat-card-pro">
                <div>
                    <span class="text-muted small fw-medium">Tổng số bàn quán</span>
                    <h2 class="fw-bold my-1 text-dark"><asp:Literal ID="litTongBan" runat="server">0</asp:Literal></h2>
                    <span class="badge bg-light text-secondary border"><asp:Literal ID="litTongKhuVuc" runat="server">0</asp:Literal> Khu vực</span>
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
                    <h2 class="fw-bold my-1 text-success"><asp:Literal ID="litBanTrong" runat="server">0</asp:Literal></h2>
                    <span class="small text-success fw-medium"><i class="bi bi-check-circle me-1"></i>Sẵn sàng đón khách</span>
                </div>
                <div class="stat-icon-pro bg-success-subtle text-success">
                    <i class="bi bi-cup-hot-fill"></i>
                </div>
            </div>
        </div>
        <div class="col-6 col-xl-3">
            <div class="stat-card-pro border-primary-subtle" style="background: linear-gradient(145deg, #ffffff, #eff6ff);">
                <div>
                    <span class="text-primary small fw-semibold">Bàn đang phục vụ</span>
                    <h2 class="fw-bold my-1 text-primary"><asp:Literal ID="litBanDangDung" runat="server">0</asp:Literal></h2>
                    <span class="small text-primary fw-medium"><i class="bi bi-people-fill me-1"></i>Có khách ngồi</span>
                </div>
                <div class="stat-icon-pro bg-primary text-white shadow-sm">
                    <i class="bi bi-person-check-fill"></i>
                </div>
            </div>
        </div>
        <div class="col-6 col-xl-3">
            <div class="stat-card-pro">
                <div>
                    <span class="text-muted small fw-medium">Lịch hẹn đặt trước</span>
                    <h2 class="fw-bold my-1 text-warning"><asp:Literal ID="litLichDatHomNay" runat="server">0</asp:Literal></h2>
                    <span class="small text-warning fw-medium"><i class="bi bi-clock-history me-1"></i>Đã đặt trước</span>
                </div>
                <div class="stat-icon-pro bg-warning-subtle text-warning">
                    <i class="bi bi-calendar-check-fill"></i>
                </div>
            </div>
        </div>
    </div>

    <!-- THANH TÁC VỤ & BỘ LỌC -->
    <div class="filter-container mb-4 shadow-sm">
        <div class="d-flex flex-wrap justify-content-between align-items-center gap-3">
            <ul class="nav nav-pills gap-2" role="tablist">
                <li class="nav-item" role="presentation">
                    <button class="nav-link active rounded-pill px-3 py-2 fw-semibold" data-bs-toggle="tab" data-bs-target="#tabSoDoBan" type="button">
                        <i class="bi bi-diagram-3-fill me-1"></i> Khu Vực & Bàn 
                    </button>
                </li>
                <li class="nav-item" role="presentation">
                    <button class="nav-link rounded-pill px-3 py-2 fw-semibold text-secondary" data-bs-toggle="tab" data-bs-target="#tabLichDatBan" type="button">
                        <i class="bi bi-calendar2-week-fill me-1"></i>Danh sách lịch đặt bàn
                    </button>
                </li>
            </ul>

            <div class="d-flex flex-wrap align-items-center gap-2">
                <div class="input-group" style="width: 230px;">
                    <span class="input-group-text bg-light border-end-0 text-muted"><i class="bi bi-search"></i></span>
                    <asp:TextBox ID="txtTimKiem" runat="server" CssClass="form-control form-control-sm border-start-0" placeholder="Tìm tên bàn..."></asp:TextBox>
                </div>
                <asp:DropDownList ID="ddlLocKhuVuc" runat="server" CssClass="form-select form-select-sm" AutoPostBack="true" OnSelectedIndexChanged="ddlLoc_SelectedIndexChanged" style="width: 170px;">
                </asp:DropDownList>
                <asp:DropDownList ID="ddlLocTrangThai" runat="server" CssClass="form-select form-select-sm" AutoPostBack="true" OnSelectedIndexChanged="ddlLoc_SelectedIndexChanged" style="width: 160px;">
                    <asp:ListItem Value="">-- Mọi trạng thái --</asp:ListItem>
                    <asp:ListItem Value="Trong">Trống</asp:ListItem>
                    <asp:ListItem Value="DangPhucVu">Đang phục vụ</asp:ListItem>
                    <asp:ListItem Value="DaDat">Đã đặt trước</asp:ListItem>
                </asp:DropDownList>
                <asp:Button ID="btnTimKiem" runat="server" Text="Lọc" CssClass="btn btn-sm btn-outline-primary" OnClick="btnTimKiem_Click" />
            </div>
        </div>
    </div>

    <!-- TABS NỘI DUNG -->
    <div class="tab-content">
        
        <!-- TAB 1: SƠ ĐỒ 2 CẤP -->
        <div class="tab-pane fade show active" id="tabSoDoBan" role="tabpanel">
            <asp:Repeater ID="rptKhuVuc" runat="server" OnItemDataBound="rptKhuVuc_ItemDataBound">
                <ItemTemplate>
                    <div class="zone-wrapper">
                        <div class="zone-header-pro d-flex flex-wrap justify-content-between align-items-center gap-2">
                            <div class="d-flex align-items-center gap-2">
                                <span class="p-2 bg-primary-subtle text-primary rounded-3"><i class="bi bi-geo-alt-fill fs-5"></i></span>
                                <div>
                                    <h6 class="fw-bold mb-0 text-dark"><%# Eval("TenKhuVuc") %></h6>
                                    <small class="text-muted"><%# Eval("GhiChu") %></small>
                                </div>
                            </div>
                            <asp:HiddenField ID="hfMaKhuVuc" runat="server" Value='<%# Eval("MaKhuVuc") %>' />
                        </div>

                        <div class="p-4">
                            <div class="row g-3">
                                <asp:Repeater ID="rptBanAn" runat="server">
                                    <ItemTemplate>
                                        <div class="col-12 col-sm-6 col-md-4 col-xl-3">
                                            <div class='table-item-card <%# LayClassTrangThai(Eval("TrangThai").ToString()) %>'>
                                                <div class="d-flex justify-content-between align-items-center mb-2">
                                                    <span class="badge bg-secondary px-2 py-1">B<%# Eval("MaBan") %></span>
                                                    <span class='badge <%# LayBadgeClass(Eval("TrangThai").ToString()) %> rounded-pill'>
                                                        <%# LayTenTrangThai(Eval("TrangThai").ToString()) %>
                                                    </span>
                                                </div>
                                                <h6 class="fw-bold text-dark mb-1"><%# Eval("TenBan") %> <span class="text-muted fw-normal small">(<%# Eval("SoGhe") %> ghế)</span></h6>
                                                
                                                <div class="p-2 rounded-3 bg-light my-2">
                                                    <div class="small text-muted"><i class="bi bi-info-circle me-1"></i>Trạng thái: <strong><%# LayTenTrangThai(Eval("TrangThai").ToString()) %></strong></div>
                                                </div>

                                                <div class="d-flex gap-1 pt-2 border-top">
                                                    <a href='GoiMonThanhToan.aspx?maban=<%# Eval("MaBan") %>' class='btn btn-sm flex-grow-1 fw-semibold <%# Eval("TrangThai").ToString() == "DangPhucVu" ? "btn-primary" : "btn-outline-success" %>'>
                                                        <%# Eval("TrangThai").ToString() == "DangPhucVu" ? "<i class='bi bi-receipt-cutoff me-1'></i>Thu tiền / Thêm" : "<i class='bi bi-plus-circle me-1'></i>Mở gọi món" %>
                                                    </a>
                                                    <asp:LinkButton ID="btnXoaBan" runat="server" CssClass="btn btn-sm btn-outline-danger" 
                                                        CommandArgument='<%# Eval("MaBan") %>' OnClick="btnXoaBan_Click" 
                                                        OnClientClick="return confirm('Bạn có chắc chắn muốn xóa bàn này?');"
                                                        Visible='<%# Eval("TrangThai").ToString() == "Trong" %>'>
                                                        <i class="bi bi-trash"></i>
                                                    </asp:LinkButton>
                                                </div>
                                            </div>
                                        </div>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </div>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>

        <!-- TAB 2: LỊCH HẸN ĐẶT BÀN -->
        <div class="tab-pane fade" id="tabLichDatBan" role="tabpanel">
            <div class="zone-wrapper">
                <div class="zone-header-pro d-flex flex-wrap justify-content-between align-items-center gap-2">
                    <div>
                        <h6 class="fw-bold mb-0 text-dark"><i class="bi bi-calendar2-range me-2 text-primary"></i>Danh Sách Lịch Hẹn Đặt Bàn</h6>
                        <small class="text-muted">Quản lý các lịch đặt từ bảng DATBAN & KHACHHANG</small>
                    </div>
                    <div class="d-flex align-items-center gap-2">
                        <asp:TextBox ID="txtNgayXemLich" runat="server" TextMode="Date" CssClass="form-control form-control-sm" AutoPostBack="true" OnTextChanged="txtNgayXemLich_TextChanged" style="width: 150px;"></asp:TextBox>
                        <button type="button" class="btn btn-sm btn-primary rounded-3" data-bs-toggle="modal" data-bs-target="#modalTaoDatBan">
                            <i class="bi bi-plus-lg me-1"></i>Tạo đặt bàn mới
                        </button>
                    </div>
                </div>

                <div class="table-responsive">
                    <asp:GridView ID="gvLichDatBan" runat="server" AutoGenerateColumns="false" CssClass="table table-hover align-middle mb-0" GridLines="None" EmptyDataText="Không có lịch đặt bàn nào.">
                        <HeaderStyle CssClass="table-light text-secondary small text-uppercase" />
                        <Columns>
                            <asp:BoundField DataField="MaDatBan" HeaderText="Mã Đặt" ItemStyle-CssClass="ps-4 fw-bold text-primary font-monospace" />
                            <asp:BoundField DataField="TenKhachHang" HeaderText="Khách Hàng" ItemStyle-CssClass="fw-semibold" />
                            <asp:BoundField DataField="SoDienThoai" HeaderText="Số Điện Thoại" ItemStyle-CssClass="font-monospace text-secondary" />
                            <asp:BoundField DataField="NgayGioDenDuKien" HeaderText="Thời Gian Hẹn" DataFormatString="{0:dd/MM/yyyy HH:mm}" />
                            <asp:BoundField DataField="SoLuongKhach" HeaderText="Số Khách" ItemStyle-CssClass="text-center" />
                            <asp:BoundField DataField="TenBan" HeaderText="Bàn Chỉ Định" ItemStyle-CssClass="fw-bold text-dark" />
                            <asp:BoundField DataField="GhiChu" HeaderText="Ghi Chú" ItemStyle-CssClass="text-muted small" />
                            <asp:TemplateField HeaderText="Trạng Thái">
                                <ItemTemplate>
                                    <span class='badge <%# Eval("TrangThaiDat").ToString() == "DaNhanBan" ? "bg-success" : (Eval("TrangThaiDat").ToString() == "DaHuy" ? "bg-danger" : "badge-soft-reserved") %> rounded-pill'>
                                        <%# Eval("TrangThaiDat") %>
                                    </span>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Thao Tác" ItemStyle-CssClass="text-end pe-4">
                                <ItemTemplate>
                                    <asp:LinkButton ID="btnNhanBan" runat="server" CssClass="btn btn-sm btn-outline-success py-1 px-2 me-1" CommandArgument='<%# Eval("MaDatBan") %>' OnClick="btnNhanBan_Click" Visible='<%# Eval("TrangThaiDat").ToString() == "DaXacNhan" %>'>
                                        <i class="bi bi-box-arrow-in-right me-1"></i>Nhận bàn
                                    </asp:LinkButton>
                                    <asp:LinkButton ID="btnHuyDatBan" runat="server" CssClass="btn btn-sm btn-outline-danger py-1 px-2" CommandArgument='<%# Eval("MaDatBan") %>' OnClick="btnHuyDatBan_Click" OnClientClick="return confirm('Bạn có muốn hủy lịch đặt bàn này?');" Visible='<%# Eval("TrangThaiDat").ToString() == "DaXacNhan" %>'>
                                        <i class="bi bi-x-circle"></i>
                                    </asp:LinkButton>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>
            </div>
        </div>
    </div>

    <!-- MODAL THÊM BÀN (F14) -->
    <div class="modal fade" id="modalThemBan" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow-lg rounded-4 overflow-hidden">
                <div class="modal-header bg-primary text-white py-3">
                    <h6 class="modal-title fw-bold"><i class="bi bi-grid-3x3-gap me-2"></i>Thêm Mới Bàn Phục Vụ</h6>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body p-4">
                    <div class="row g-3">
                        <div class="col-12">
                            <label class="form-label small fw-semibold">Tên Hiển Thị Bàn <span class="text-danger">*</span></label>
                            <asp:TextBox ID="txtTenBanMoi" runat="server" CssClass="form-control" placeholder="VD: Bàn 07"></asp:TextBox>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label small fw-semibold">Khu Vực Phục Vụ <span class="text-danger">*</span></label>
                            <asp:DropDownList ID="ddlKhuVucThemBan" runat="server" CssClass="form-select"></asp:DropDownList>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label small fw-semibold">Sức Chứa (Số Ghế)</label>
                            <asp:TextBox ID="txtSoGheMoi" runat="server" TextMode="Number" CssClass="form-control" Text="4"></asp:TextBox>
                        </div>
                    </div>
                </div>
                <div class="modal-footer bg-light py-2 px-4">
                    <button type="button" class="btn btn-sm btn-secondary rounded-3" data-bs-dismiss="modal">Đóng</button>
                    <asp:Button ID="btnLuuBanMoi" runat="server" Text="Lưu Bàn Mới" CssClass="btn btn-sm btn-primary rounded-3 px-3" OnClick="btnLuuBanMoi_Click" />
                </div>
            </div>
        </div>
    </div>

    <!-- MODAL CHUYỂN BÀN (F19) -->
    <div class="modal fade" id="modalChuyenBan" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow-lg rounded-4 overflow-hidden">
                <div class="modal-header bg-warning text-dark py-3">
                    <h6 class="modal-title fw-bold"><i class="bi bi-arrow-left-right me-2"></i>Điều Phối & Chuyển Khách Sang Bàn Khác</h6>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body p-4">
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Bàn Hiện Tại (Đang có khách) <span class="text-danger">*</span></label>
                        <asp:DropDownList ID="ddlBanChuyenDi" runat="server" CssClass="form-select"></asp:DropDownList>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Chuyển Sang Bàn Trống <span class="text-danger">*</span></label>
                        <asp:DropDownList ID="ddlBanChuyenDen" runat="server" CssClass="form-select border-primary"></asp:DropDownList>
                    </div>
                </div>
                <div class="modal-footer bg-light py-2 px-4">
                    <button type="button" class="btn btn-sm btn-secondary rounded-3" data-bs-dismiss="modal">Hủy</button>
                    <asp:Button ID="btnXacNhanChuyenBan" runat="server" Text="Xác Nhận Chuyển Bàn" CssClass="btn btn-sm btn-warning rounded-3 fw-semibold text-dark px-3" OnClick="btnXacNhanChuyenBan_Click" />
                </div>
            </div>
        </div>
    </div>

    <!-- MODAL QUẢN LÝ KHU VỰC (F17) -->
    <div class="modal fade" id="modalKhuVuc" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow-lg rounded-4 overflow-hidden">
                <div class="modal-header bg-primary text-white py-3">
                    <h6 class="modal-title fw-bold"><i class="bi bi-layers me-2"></i>Thêm Mới Khu Vực Quán</h6>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body p-4">
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Tên Phân Vùng / Khu Vực Mới <span class="text-danger">*</span></label>
                        <asp:TextBox ID="txtTenKhuVucMoi" runat="server" CssClass="form-control" placeholder="VD: Tầng 2"></asp:TextBox>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Ghi Chú Mô Tả</label>
                        <asp:TextBox ID="txtGhiChuKhuVuc" runat="server" CssClass="form-control" placeholder="VD: Khu vực phòng lạnh riêng tư..."></asp:TextBox>
                    </div>
                </div>
                <div class="modal-footer bg-light py-2 px-4">
                    <button type="button" class="btn btn-sm btn-secondary rounded-3" data-bs-dismiss="modal">Đóng</button>
                    <asp:Button ID="btnLuuKhuVucMoi" runat="server" Text="Thêm Khu Vực" CssClass="btn btn-sm btn-primary rounded-3 px-3" OnClick="btnLuuKhuVucMoi_Click" />
                </div>
            </div>
        </div>
    </div>

    <!-- MODAL TẠO ĐẶT BÀN (F21) -->
    <div class="modal fade" id="modalTaoDatBan" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg modal-dialog-centered">
            <div class="modal-content border-0 shadow-lg rounded-4 overflow-hidden">
                <div class="modal-header bg-primary text-white py-3">
                    <h6 class="modal-title fw-bold"><i class="bi bi-calendar-plus me-2"></i>Phiếu Đặt Bàn Trước Cho Khách</h6>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body p-4">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label small fw-semibold">Họ Tên Khách Hàng <span class="text-danger">*</span></label>
                            <asp:TextBox ID="txtTenKhachDat" runat="server" CssClass="form-control" placeholder="Nhập tên khách..."></asp:TextBox>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label small fw-semibold">Số Điện Thoại <span class="text-danger">*</span></label>
                            <asp:TextBox ID="txtSDTKhachDat" runat="server" CssClass="form-control" placeholder="VD: 0912xxxxxx"></asp:TextBox>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label small fw-semibold">Ngày Đến <span class="text-danger">*</span></label>
                            <asp:TextBox ID="txtNgayDenDat" runat="server" TextMode="Date" CssClass="form-control"></asp:TextBox>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label small fw-semibold">Giờ Đến Dự Kiến <span class="text-danger">*</span></label>
                            <asp:TextBox ID="txtGioDenDat" runat="server" TextMode="Time" CssClass="form-control"></asp:TextBox>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label small fw-semibold">Số Lượng Khách <span class="text-danger">*</span></label>
                            <asp:TextBox ID="txtSoLuongKhachDat" runat="server" TextMode="Number" CssClass="form-control" Text="4"></asp:TextBox>
                        </div>
                        <div class="col-12">
                            <label class="form-label small fw-semibold">Chỉ Định Bàn Trống <span class="text-danger">*</span></label>
                            <asp:DropDownList ID="ddlBanDatTruoc" runat="server" CssClass="form-select"></asp:DropDownList>
                        </div>
                        <div class="col-12">
                            <label class="form-label small fw-semibold">Ghi Chú Yêu Cầu</label>
                            <asp:TextBox ID="txtGhiChuDat" runat="server" TextMode="MultiLine" Rows="2" CssClass="form-control" placeholder="VD: Cần góc yên tĩnh..."></asp:TextBox>
                        </div>
                    </div>
                </div>
                <div class="modal-footer bg-light py-2 px-4">
                    <button type="button" class="btn btn-sm btn-secondary rounded-3" data-bs-dismiss="modal">Đóng</button>
                    <asp:Button ID="btnLuuDatBan" runat="server" Text="Lưu Thông Tin Đặt Bàn" CssClass="btn btn-sm btn-primary rounded-3 px-3" OnClick="btnLuuDatBan_Click" />
                </div>
            </div>
        </div>
    </div>

</asp:Content>
