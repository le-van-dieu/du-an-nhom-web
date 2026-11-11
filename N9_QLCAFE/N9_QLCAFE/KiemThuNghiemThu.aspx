<%@ Page Title="Kiểm thử, Nghiệm thu & Báo lỗi" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="KiemThuNghiemThu.aspx.cs" Inherits="N9_QLCAFE.KiemThuNghiemThu" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <asp:Label ID="issueMessage" runat="server" Visible="false" CssClass="alert alert-info d-block" role="status" />
    <!-- HEADER -->
    <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 gap-3">
        <div>
            <span class="badge badge-soft-blue mb-1">Phân hệ NF01 - NF08 • Phụ trách: Mẫn Vinh (Test, Nghiệm thu & Lỗi)</span>
            <h4 class="fw-bold mb-0 text-dark">Trung tâm Kiểm thử, Nghiệm thu Nghiệp vụ & Sao lưu Hệ thống</h4>
        </div>
        <div class="d-flex flex-wrap gap-2">
            <button type="button" class="btn btn-cafe-outline" data-bs-toggle="modal" data-bs-target="#modalSaoLuu">
                <i class="bi bi-cloud-arrow-up me-1"></i>Sao lưu & Phục hồi DB (NF07)
            </button>
            <button type="button" class="btn btn-cafe-primary" data-bs-toggle="modal" data-bs-target="#modalBaoLoi">
                <i class="bi bi-bug-fill me-1"></i>Ghi nhận Lỗi / Bug mới
            </button>
        </div>
    </div>

    <div class="row g-4 mb-4">
        <!-- CỘT TRÁI: BẢNG NGHIỆM THU YÊU CẦU PHI CHỨC NĂNG (NF01 - NF08) -->
        <div class="col-12 col-lg-6">
            <div class="card-custom h-100">
                <div class="card-header-custom">
                    <div>
                        <h6 class="fw-bold mb-0 text-dark"><i class="bi bi-shield-fill-check text-primary me-2"></i>Nghiệm thu Yêu cầu Phi chức năng (Mục 3)</h6>
                        <small class="text-muted">Đánh giá các tiêu chí NF01 → NF08 theo tài liệu đặc tả Nhóm 9</small>
                    </div>
                    <span class="badge badge-soft-blue">NF01 - NF08</span>
                </div>
                <div class="table-responsive">
                    <table class="table table-cafe">
                        <thead>
                            <tr>
                                <th>Mã</th>
                                <th>Yêu cầu & Mô tả</th>
                                <th class="text-end">Kết quả</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td class="fw-bold text-primary">NF01</td>
                                <td>
                                    <div class="fw-semibold">Hiệu năng</div>
                                    <small class="text-muted">Các thao tác thông thường phản hồi nhanh</small>
                                </td>
                                <td class="text-end"><span class="badge bg-secondary">Cần nghiệm thu</span></td>
                            </tr>
                            <tr>
                                <td class="fw-bold text-primary">NF02</td>
                                <td>
                                    <div class="fw-semibold">Bảo mật</div>
                                    <small class="text-muted">Mật khẩu được mã hóa trước khi lưu</small>
                                </td>
                                <td class="text-end"><span class="badge bg-secondary">Cần nghiệm thu</span></td>
                            </tr>
                            <tr>
                                <td class="fw-bold text-primary">NF03</td>
                                <td>
                                    <div class="fw-semibold">Phân quyền</div>
                                    <small class="text-muted">Người dùng chỉ truy cập chức năng được cấp quyền</small>
                                </td>
                                <td class="text-end"><span class="badge bg-secondary">Cần nghiệm thu</span></td>
                            </tr>
                            <tr>
                                <td class="fw-bold text-primary">NF04</td>
                                <td>
                                    <div class="fw-semibold">Tính chính xác</div>
                                    <small class="text-muted">Tính tiền và doanh thu chính xác</small>
                                </td>
                                <td class="text-end"><span class="badge bg-secondary">Cần nghiệm thu</span></td>
                            </tr>
                            <tr>
                                <td class="fw-bold text-primary">NF05</td>
                                <td>
                                    <div class="fw-semibold">Dễ sử dụng</div>
                                    <small class="text-muted">Giao diện trực quan, dễ thao tác (Xanh dương & Trắng)</small>
                                </td>
                                <td class="text-end"><span class="badge bg-secondary">Cần nghiệm thu</span></td>
                            </tr>
                            <tr>
                                <td class="fw-bold text-primary">NF06</td>
                                <td>
                                    <div class="fw-semibold">Toàn vẹn dữ liệu</div>
                                    <small class="text-muted">Đảm bảo quan hệ khóa ngoại giữa các bảng SQL Server</small>
                                </td>
                                <td class="text-end"><span class="badge bg-secondary">Cần nghiệm thu</span></td>
                            </tr>
                            <tr>
                                <td class="fw-bold text-primary">NF07</td>
                                <td>
                                    <div class="fw-semibold">Sao lưu</div>
                                    <small class="text-muted">Có khả năng sao lưu và phục hồi dữ liệu</small>
                                </td>
                                <td class="text-end"><span class="badge bg-secondary">Cần nghiệm thu</span></td>
                            </tr>
                            <tr>
                                <td class="fw-bold text-primary">NF08</td>
                                <td>
                                    <div class="fw-semibold">Khả năng mở rộng</div>
                                    <small class="text-muted">Có thể bổ sung chức năng mới dễ dàng</small>
                                </td>
                                <td class="text-end"><span class="badge bg-secondary">Cần nghiệm thu</span></td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- CỘT PHẢI: KIỂM THỬ QUY TẮC NGHIỆP VỤ & NHẬT KÝ BÁO LỖI -->
        <div class="col-12 col-lg-6">
            <div class="card-custom h-100">
                <div class="card-header-custom">
                    <div>
                        <h6 class="fw-bold mb-0 text-dark"><i class="bi bi-bug text-primary me-2"></i>Kịch bản Kiểm thử Quy tắc Nghiệp vụ & Báo lỗi</h6>
                        <small class="text-muted">Kiểm tra các ràng buộc nghiệp vụ trong mục 2.1 → 2.8</small>
                    </div>
                    <span class="badge badge-soft-blue">QC: Mẫn Vinh</span>
                </div>
                <div class="table-responsive">
                    <table class="table table-cafe">
                        <thead>
                            <tr>
                                <th>Mã TC</th>
                                <th>Nội dung kiểm thử quy tắc</th>
                                <th>Phân hệ</th>
                                <th class="text-end">Trạng thái</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td class="fw-bold text-primary">TC01</td>
                                <td>
                                    <div class="fw-semibold">Chặn xóa vật lý đồ uống đã có giao dịch</div>
                                    <small class="text-muted">Chỉ chuyển sang trạng thái "Ngừng kinh doanh" (F08)</small>
                                </td>
                                <td><span class="badge badge-soft-blue">Đồ uống</span></td>
                                <td class="text-end"><span class="badge bg-secondary">Cần chạy thử</span></td>
                            </tr>
                            <tr>
                                <td class="fw-bold text-primary">TC02</td>
                                <td>
                                    <div class="fw-semibold">Chặn gọi món đã hết hàng trên màn hình POS</div>
                                    <small class="text-muted">Nút Thêm món bị vô hiệu hóa khi trạng thái Hết hàng (F12)</small>
                                </td>
                                <td><span class="badge badge-soft-blue">Gọi món</span></td>
                                <td class="text-end"><span class="badge bg-secondary">Cần chạy thử</span></td>
                            </tr>
                            <tr>
                                <td class="fw-bold text-primary">TC03</td>
                                <td>
                                    <div class="fw-semibold">Không cho phép trùng lịch đặt bàn cùng thời điểm</div>
                                    <small class="text-muted">Kiểm tra bàn trống trước khi xác nhận đặt bàn (F21, F24)</small>
                                </td>
                                <td><span class="badge badge-soft-blue">Đặt bàn</span></td>
                                <td class="text-end"><span class="badge bg-secondary">Cần chạy thử</span></td>
                            </tr>
                            <tr>
                                <td class="fw-bold text-primary">TC04</td>
                                <td>
                                    <div class="fw-semibold">Không xóa bàn đang có đơn chưa thanh toán</div>
                                    <small class="text-muted">Ẩn/khóa nút xóa đối với bàn đang sử dụng (F16)</small>
                                </td>
                                <td><span class="badge badge-soft-blue">Bàn</span></td>
                                <td class="text-end"><span class="badge bg-secondary">Cần chạy thử</span></td>
                            </tr>
                            <tr>
                                <td class="fw-bold text-primary">TC05</td>
                                <td>
                                    <div class="fw-semibold">Lưu đơn giá tại thời điểm gọi món</div>
                                    <small class="text-muted">Tránh thay đổi hóa đơn cũ khi cập nhật giá menu (F11, F33)</small>
                                </td>
                                <td><span class="badge badge-soft-blue">Hóa đơn</span></td>
                                <td class="text-end"><span class="badge bg-secondary">Cần chạy thử</span></td>
                            </tr>
                            <tr>
                                <td class="fw-bold text-primary">TC06</td>
                                <td>
                                    <div class="fw-semibold">Doanh thu chỉ tính hóa đơn đã thanh toán thành công</div>
                                    <small class="text-muted">Loại trừ đơn hàng đang phục vụ hoặc hóa đơn đã hủy (F51-F57)</small>
                                </td>
                                <td><span class="badge badge-soft-blue">Thống kê</span></td>
                                <td class="text-end"><span class="badge bg-secondary">Cần chạy thử</span></td>
                            </tr>
                            <tr>
                                <td class="fw-bold text-primary">BUG01</td>
                                <td>
                                    <div class="fw-semibold">Xác nhận giao dịch chuyển khoản QR trước khi đóng bàn</div>
                                    <small class="text-muted">Cần nhân viên bấm Xác nhận hoàn tất (F40, F41)</small>
                                </td>
                                <td><span class="badge badge-soft-blue">Thanh toán</span></td>
                                <td class="text-end"><span class="badge badge-soft-warning">Đang kiểm tra</span></td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <!-- MODAL SAO LƯU & PHỤC HỒI DỮ LIỆU (NF07) -->
    <div class="modal fade" id="modalSaoLuu" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header"><h2 class="modal-title h5">Sao lưu SQL Server</h2>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Đóng"></button>
                </div>
                <div class="modal-body">
                    <asp:Button runat="server" Text="Tạo bản sao lưu" CssClass="btn btn-primary mb-3" OnClick="CreateBackup" />
                    <label for="backupId" class="form-label">Mã bản sao lưu</label>
                    <input id="backupId" name="backupId" class="form-control" maxlength="23" />
                    <p class="form-text">Phục hồi vào một cơ sở dữ liệu riêng để kiểm tra bản sao.</p>
                    <asp:Button runat="server" Text="Phục hồi bản sao" CssClass="btn btn-outline-primary" OnClick="RestoreBackup" />
                </div>
            </div>
        </div>
    </div>
    <div class="modal fade" id="modalBaoLoi" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header"><h2 class="modal-title h5">Phiếu báo lỗi</h2>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Đóng"></button>
                </div>
                <div class="modal-body">
                    <label for="issueArea" class="form-label">Phân hệ</label>
                    <select id="issueArea" name="issueArea" class="form-select mb-3">
                        <option value="sanpham">Đồ uống</option><option value="datban">Bàn và đặt bàn</option>
                        <option value="pos">POS và hóa đơn</option><option value="hethong">Tài khoản và báo cáo</option>
                    </select>
                    <label for="issueTitle" class="form-label">Tiêu đề</label>
                    <input id="issueTitle" name="issueTitle" class="form-control mb-3" maxlength="160" />
                    <label for="issueSeverity" class="form-label">Mức độ ưu tiên</label>
                    <select id="issueSeverity" name="issueSeverity" class="form-select mb-3">
                        <option value="cao">Cao</option><option value="trungbinh" selected>Trung bình</option><option value="thap">Thấp</option>
                    </select>
                    <label for="issueDetails" class="form-label">Các bước tái hiện và kết quả mong đợi</label>
                    <textarea id="issueDetails" name="issueDetails" class="form-control mb-3" rows="4" maxlength="4000"></textarea>
                    <asp:Button runat="server" Text="Lưu phiếu báo lỗi" CssClass="btn btn-primary" OnClick="SaveIssue" />
                </div>
            </div>
        </div>
    </div>
</asp:Content>

