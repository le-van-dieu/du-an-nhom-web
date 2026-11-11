<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="N9_QLCAFE.Login" %>
<!DOCTYPE html>
<html lang="vi">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Đăng nhập · MOON CAFÉ</title>
    <link href="Content/bootstrap.min.css" rel="stylesheet" />
    <link href="Content/site.css" rel="stylesheet" />
</head>
<body class="bg-primary">
    <main class="min-vh-100 d-flex align-items-center justify-content-center p-3">
        <form id="form1" runat="server" class="bg-white rounded-4 shadow-lg p-4 p-sm-5 w-100" style="max-width: 420px">
            <img src="Content/moon-logo.svg" width="46" height="46" alt="MOON CAFÉ" class="mb-3" />
            <h1 class="h3 fw-bold mb-4">Đăng nhập MOON CAFÉ</h1>
            <asp:Label ID="loginError" runat="server" CssClass="alert alert-danger d-block" Visible="false" role="alert" />
            <asp:Label runat="server" AssociatedControlID="username" CssClass="form-label" Text="Tên đăng nhập" />
            <asp:TextBox ID="username" runat="server" CssClass="form-control mb-3" MaxLength="50" autocomplete="username" required="required" />
            <asp:Label runat="server" AssociatedControlID="password" CssClass="form-label" Text="Mật khẩu" />
            <asp:TextBox ID="password" runat="server" CssClass="form-control mb-4" TextMode="Password" autocomplete="current-password" required="required" />
            <asp:Button runat="server" CssClass="btn btn-primary w-100" Text="Đăng nhập" OnClick="SignIn" />
        </form>
    </main>
</body>
</html>
