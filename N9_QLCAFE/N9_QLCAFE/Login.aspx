<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="N9_QLCAFE.Login" %>
<!DOCTYPE html>
<html lang="vi">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Đăng nhập hệ thống (F01) - MOON CAFÉ</title>
    <!-- Google Fonts for Vietnamese Typography -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="~/Content/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet" />
    <link href="~/Content/site.css" rel="stylesheet" />
    <style>
        .login-wrapper {
            min-height: 100vh;
            background: linear-gradient(135deg, #1d4ed8 0%, #2563eb 50%, rgb(60, 131, 246) 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 1.5rem;
        }
        .login-card {
            max-width: 920px;
            width: 100%;
            background: #ffffff;
            border-radius: 20px;
            overflow: hidden;
            box-shadow: 0 24px 60px rgba(15, 23, 42, 0.35);
        }
        .login-banner {
            background: linear-gradient(180deg, #eff6ff 0%, #dbeafe 100%);
            padding: 2.75rem 2.25rem;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            border-right: 1px solid #dce7f9;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="login-wrapper">
            <div class="login-card">
                <div class="row g-0">
                    <!-- CỘT TRÁI: THÔNG TIN HỆ THỐNG NHÓM 9 -->
                    <div class="col-lg-5 login-banner d-none d-lg-flex">
                        <div>
                            <div class="d-flex align-items-center gap-3 mb-4">
                                <div class="brand-icon rounded-3 bg-white d-flex align-items-center justify-content-center p-2 shadow-sm" style="width: 48px; height: 48px;">
                                    <img src="Content/moon-logo.svg" alt="MOON CAFÉ Logo" style="width: 36px; height: 36px;" />
                                </div>
                                <div>
                                    <h4 class="fw-bold text-primary mb-0">MOON CAFÉ</h4>
                                    <small class="text-muted">Hệ thống Quản lý Quán Café</small>
                                </div>
                            </div>

                            <h4 class="fw-bold text-dark mb-3">Hệ thống Quản lý Cửa hàng MOON CAFÉ</h4>
                            <p class="text-muted small mb-4">
                                Giải pháp quản lý đồng bộ từ đồ uống, bàn & khu vực, đặt bàn trước, gọi món POS, hóa đơn thanh toán đến báo cáo doanh thu.
                            </p>

                            <div class="bg-white p-3 rounded-3 border mb-3">
                                <div class="small fw-bold text-primary mb-2"><i class="bi bi-people-fill me-1"></i>Thành viên Nhóm 9:</div>
                                <ul class="list-unstyled small text-dark mb-0" style="line-height: 1.75;">
                                    <li>• <strong>Nguyễn Nhật Anh</strong> (Tài khoản, NV, Thống kê)</li>
                                    <li>• <strong>Nguyễn Anh Kỳ</strong> (Quản lý Đồ uống & Menu)</li>
                                    <li>• <strong>Lư Quốc Thắng</strong> (Quản lý Bàn & Đặt bàn)</li>
                                    <li>• <strong>Lê Văn Điều</strong> (Gọi món & Thanh toán)</li>
                                    <li>• <strong>Mẫn Vinh</strong> (Kiểm thử, Nghiệm thu & Lỗi)</li>
                                </ul>
                            </div>
                        </div>

                        <div class="small text-muted">
                            <i class="bi bi-shield-check text-primary me-1"></i>Đáp ứng tiêu chuẩn bảo mật NF02 & phân quyền NF03
                        </div>
                    </div>

                    <!-- CỘT PHẢI: FORM ĐĂNG NHẬP (F01) -->
                    <div class="col-lg-7 p-4 p-md-5">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <span class="badge badge-soft-blue">Chức năng F01 - F04</span>
                            <a href="Default.aspx" class="small text-decoration-none text-primary fw-semibold">
                                Vào trang Tổng quan <i class="bi bi-arrow-right"></i>
                            </a>
                        </div>

                        <h4 class="fw-bold text-dark mb-1">Đăng nhập Hệ thống</h4>
                        <p class="text-muted small mb-4">Vui lòng nhập tài khoản được cấp quyền để tiếp tục phiên làm việc</p>

                        <!-- Thông báo kiểm tra quy tắc xử lý (Mô phỏng UI) -->
                        <div class="alert alert-primary bg-primary bg-opacity-10 border-primary border-opacity-25 py-2 px-3 small mb-3">
                            <i class="bi bi-info-circle-fill text-primary me-1"></i>
                            <strong>Quy tắc F01:</strong> Kiểm tra tài khoản tồn tại, mật khẩu mã hóa an toàn và phân quyền theo vai trò.
                        </div>

                        <div class="mb-3">
                            <label class="form-label small fw-semibold">Tên đăng nhập <span class="text-danger">*</span></label>
                            <div class="input-group">
                                <span class="input-group-text bg-light text-primary"><i class="bi bi-person-fill"></i></span>
                                <input type="text" class="form-control"  placeholder="Nhập tên đăng nhập..." />
                            </div>
                        </div>

                        <div class="mb-3">
                            <div class="d-flex justify-content-between">
                                <label class="form-label small fw-semibold">Mật khẩu <span class="text-danger">*</span></label>
                                <span class="small text-primary" style="cursor:pointer;">Quên mật khẩu?</span>
                            </div>
                            <div class="input-group">
                                <span class="input-group-text bg-light text-primary"><i class="bi bi-key-fill"></i></span>
                                <input type="password" class="form-control"  placeholder="Nhập mật khẩu..." />
                            </div>
                        </div>

                        <div class="mb-4">
                            <label class="form-label small fw-semibold">Vai trò truy cập (F04 - Phân quyền)</label>
                            <select class="form-select">
                                <option selected>Admin - Quản lý toàn bộ hệ thống</option>
                                <option>Quản lý - Quản lý hoạt động kinh doanh</option>
                                <option>Nhân viên - Gọi món, phục vụ và thanh toán</option>
                            </select>
                        </div>

                        <div class="d-grid gap-2">
                            <a href="Default.aspx" class="btn btn-cafe-primary py-2 fw-semibold">
                                <i class="bi bi-box-arrow-in-right me-1"></i>Đăng nhập vào Hệ thống (F01)
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </form>
</body>
</html>

