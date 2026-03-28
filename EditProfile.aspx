<%@ Page Title="Edit Profile" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="EditProfile.aspx.cs" Inherits="MovieTicketBooking.EditProfile" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container mt-4">
        <div class="row justify-content-center">
            <div class="col-md-8 col-lg-6">
                <div class="card shadow-sm border-0 rounded-4">
                    <div class="card-header bg-primary text-white p-4 rounded-top-4">
                        <h4 class="mb-0 fw-bold"><i class="fas fa-user-edit me-2"></i>Edit Profile</h4>
                    </div>
                    <div class="card-body p-4 p-md-5">
                        <asp:Label ID="lblMessage" runat="server" CssClass="alert alert-success d-block mb-4" Visible="false"></asp:Label>
                        <asp:Label ID="lblError" runat="server" CssClass="alert alert-danger d-block mb-4" Visible="false"></asp:Label>

                        <div class="mb-3">
                            <label class="form-label fw-bold text-muted">Username (Cannot be changed)</label>
                            <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control form-control-lg bg-light" ReadOnly="true"></asp:TextBox>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-bold">Full Name</label>
                            <asp:TextBox ID="txtFullName" runat="server" CssClass="form-control form-control-lg" required="required"></asp:TextBox>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-bold">Email Address</label>
                            <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control form-control-lg" TextMode="Email" required="required"></asp:TextBox>
                        </div>

                        <hr class="my-4" />
                        <h5 class="fw-bold mb-3">Change Password</h5>
                        <p class="text-muted small mb-4">Leave fields blank if you do not wish to change your password.</p>

                        <div class="mb-3">
                            <label class="form-label fw-bold">New Password</label>
                            <asp:TextBox ID="txtNewPassword" runat="server" CssClass="form-control form-control-lg" TextMode="Password"></asp:TextBox>
                        </div>

                        <div class="mb-4">
                            <label class="form-label fw-bold">Confirm New Password</label>
                            <asp:TextBox ID="txtConfirmPassword" runat="server" CssClass="form-control form-control-lg" TextMode="Password"></asp:TextBox>
                        </div>

                        <div class="d-grid gap-2">
                            <asp:Button ID="btnSave" runat="server" Text="Save Changes" CssClass="btn btn-primary btn-lg rounded-pill fw-bold" OnClick="btnSave_Click" />
                            <a href='<%= (Session["UserRole"] != null && Session["UserRole"].ToString() == "Admin") ? ResolveUrl("~/Admin/AdminDashboard.aspx") : ResolveUrl("~/UserDashboard.aspx") %>' class="btn btn-outline-secondary btn-lg rounded-pill fw-bold">Cancel</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
