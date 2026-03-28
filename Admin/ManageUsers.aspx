<%@ Page Title="Manage Users" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ManageUsers.aspx.cs" Inherits="MovieTicketBooking.Admin.ManageUsers" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container mt-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h2 class="text-primary fw-bold mb-0">Manage Users</h2>
                <p class="text-muted">View and manage system access for all roles</p>
            </div>
            <button type="button" class="btn btn-primary rounded-pill shadow-sm" data-bs-toggle="modal" data-bs-target="#addUserModal">
                <i class="fas fa-user-plus me-2"></i>Add New User
            </button>
        </div>

        <asp:UpdatePanel ID="upUsers" runat="server">
            <ContentTemplate>
                <div class="card glass-card border-0 shadow-sm overflow-hidden">
                    <div class="card-body p-0">
                        <asp:GridView ID="gvUsers" runat="server" AutoGenerateColumns="False" 
                            CssClass="table table-hover mb-0 align-middle" GridLines="None"
                            DataKeyNames="UserId" OnRowCommand="gvUsers_RowCommand">
                            <HeaderStyle CssClass="bg-light text-secondary border-bottom py-3" />
                            <Columns>
                            <asp:TemplateField HeaderText="ID" ItemStyle-CssClass="fw-bold px-4">
                                <ItemTemplate>
                                    <%# (int)Eval("UserId") >= 1001 ? (int)Eval("UserId") - 997 : Eval("UserId") %>
                                </ItemTemplate>
                            </asp:TemplateField>
                                <asp:TemplateField HeaderText="User Info">
                                    <ItemTemplate>
                                        <div class="d-flex align-items-center">
                                            <div class="avatar-circle me-3">
                                                <%# GetInitials(Eval("Username")) %>
                                            </div>
                                            <div>
                                                <div class="fw-bold"><%# Eval("FullName") %></div>
                                                <div class="small text-muted"><%# Eval("Username") %></div>
                                            </div>
                                        </div>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="Email" HeaderText="Email Address" />
                                <asp:TemplateField HeaderText="Role">
                                    <ItemTemplate>
                                        <span class='<%# Eval("Role").ToString() == "Admin" ? "badge bg-info-subtle text-info border border-info" : "badge bg-secondary-subtle text-secondary border border-secondary" %> px-3 rounded-pill'>
                                            <%# Eval("Role") %>
                                        </span>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Actions" ItemStyle-CssClass="text-end px-4">
                                    <ItemTemplate>
                                        <asp:LinkButton ID="btnReset" runat="server" CommandName="ResetPassword" 
                                            CommandArgument='<%# Eval("UserId") + "|" + Eval("Username") %>' CssClass="btn btn-sm btn-warning rounded-pill px-3 shadow-sm border-0 me-2"
                                            OnClientClick="return confirm('Reset this user\'s password to their username + 123?');">
                                            <i class="fas fa-key me-1"></i>Reset
                                        </asp:LinkButton>
                                        <asp:LinkButton ID="btnDelete" runat="server" CommandName="DeleteUser" 
                                            CommandArgument='<%# Eval("UserId") %>' CssClass="btn btn-sm btn-danger rounded-pill px-3 shadow-sm border-0"
                                            Visible='<%# Eval("Role").ToString() != "Admin" %>'
                                            OnClientClick="return confirm('Are you sure you want to delete this user? This action cannot be undone.');">
                                            <i class="fas fa-trash-alt me-1"></i>Delete
                                        </asp:LinkButton>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                            <EmptyDataTemplate>
                                <div class="text-center py-5">
                                    <i class="fas fa-users-slash fa-3x text-muted opacity-25 mb-3"></i>
                                    <p class="text-muted">No users found in the system.</p>
                                </div>
                            </EmptyDataTemplate>
                        </asp:GridView>
                    </div>
                </div>
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>

    <!-- Add User Modal -->
    <div class="modal fade" id="addUserModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow-lg" style="border-radius: 20px;">
                <div class="modal-header border-0 pb-0">
                    <h5 class="modal-title fw-bold">Create New User</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label small fw-bold text-muted">Full Name</label>
                        <asp:TextBox ID="txtFullName" runat="server" CssClass="form-control rounded-3" placeholder="John Doe"></asp:TextBox>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-bold text-muted">Email Address</label>
                        <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control rounded-3" placeholder="john@example.com"></asp:TextBox>
                    </div>
                    <div class="row mb-3">
                        <div class="col">
                            <label class="form-label small fw-bold text-muted">Username</label>
                            <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control rounded-3" placeholder="johndoe"></asp:TextBox>
                        </div>
                        <div class="col">
                            <label class="form-label small fw-bold text-muted">Role</label>
                            <asp:DropDownList ID="ddlRole" runat="server" CssClass="form-select rounded-3">
                                <asp:ListItem Text="User" Value="User" />
                                <asp:ListItem Text="Admin" Value="Admin" />
                            </asp:DropDownList>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-bold text-muted">Password</label>
                        <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control rounded-3" TextMode="Password"></asp:TextBox>
                    </div>
                </div>
                <div class="modal-footer border-0">
                    <button type="button" class="btn btn-light rounded-pill px-4" data-bs-dismiss="modal">Cancel</button>
                    <asp:Button ID="btnSaveUser" runat="server" Text="Create Account" CssClass="btn btn-primary rounded-pill px-4 shadow-sm" OnClick="btnSaveUser_Click" />
                </div>
            </div>
        </div>
    </div>

    <style>
        .avatar-circle {
            width: 40px;
            height: 40px;
            background: linear-gradient(135deg, #4f46e5, #6366f1);
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 50%;
            font-weight: bold;
            font-size: 1.2rem;
        }
        .bg-info-subtle { background-color: #e0f2fe; }
        .text-info { color: #0284c7 !important; }
        .border-info { border-color: #bae6fd !important; }
    </style>
</asp:Content>
