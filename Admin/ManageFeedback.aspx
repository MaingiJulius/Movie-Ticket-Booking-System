<%@ Page Title="Manage Feedback" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ManageFeedback.aspx.cs" Inherits="MovieTicketBooking.Admin.ManageFeedback" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container mt-4">
        <asp:UpdatePanel ID="upFeedback" runat="server">
            <ContentTemplate>
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <div>
                        <h2 class="text-primary fw-bold mb-0">Manage Feedback</h2>
                        <p class="text-muted">Monitor user ratings and manage movie reviews</p>
                    </div>
                    <div class="dropdown">
                        <button class="btn btn-outline-secondary rounded-pill dropdown-toggle" type="button" data-bs-toggle="dropdown">
                            <i class="fas fa-filter me-2"></i>Sort By
                        </button>
                        <ul class="dropdown-menu border-0 shadow-sm rounded-4">
                            <li><asp:LinkButton ID="btnSortNewest" runat="server" CssClass="dropdown-item" CommandArgument="Newest" OnClick="SortFeedback_Click">Newest First</asp:LinkButton></li>
                            <li><asp:LinkButton ID="btnSortOldest" runat="server" CssClass="dropdown-item" CommandArgument="Oldest" OnClick="SortFeedback_Click">Oldest First</asp:LinkButton></li>
                            <li><asp:LinkButton ID="btnSortHighest" runat="server" CssClass="dropdown-item" CommandArgument="Highest" OnClick="SortFeedback_Click">Highest Rated</asp:LinkButton></li>
                            <li><asp:LinkButton ID="btnSortLowest" runat="server" CssClass="dropdown-item" CommandArgument="Lowest" OnClick="SortFeedback_Click">Lowest Rated</asp:LinkButton></li>
                        </ul>
                    </div>
                </div>

                <div class="card glass-card border-0 shadow-sm overflow-hidden rounded-4">
                    <div class="card-body p-0">
                        <asp:GridView ID="gvFeedback" runat="server" AutoGenerateColumns="False" 
                            CssClass="table table-hover mb-0 align-middle" GridLines="None"
                            DataKeyNames="RatingId" OnRowCommand="gvFeedback_RowCommand">
                            <HeaderStyle CssClass="bg-light text-secondary border-bottom py-3" />
                            <Columns>
                                <asp:BoundField DataField="RatingId" HeaderText="Rating ID" ItemStyle-CssClass="fw-bold px-4" />
                                <asp:BoundField DataField="MovieTitle" HeaderText="Movie" ItemStyle-CssClass="fw-semibold" />
                                <asp:TemplateField HeaderText="User">
                                    <ItemTemplate>
                                        <div class="d-flex align-items-center">
                                            <div class="avatar-sm me-2 bg-primary-subtle text-primary text-center rounded-circle" style="width: 32px; height: 32px; line-height:32px; font-size: 0.8rem;">
                                                <%# GetInitials(Eval("Username")) %>
                                            </div>
                                            <span class="small fw-bold"><%# Eval("Username") %></span>
                                        </div>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Rating">
                                    <ItemTemplate>
                                        <div class="text-warning">
                                            <%# GetStarRating(Eval("Score")) %>
                                            <span class="text-muted small ms-1">(<%# Eval("Score") %>)</span>
                                        </div>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="Comment" HeaderText="Comment" ItemStyle-CssClass="small text-muted" />
                                <asp:BoundField DataField="CreatedAt" HeaderText="Date" DataFormatString="{0:MMM dd, yyyy}" ItemStyle-CssClass="small text-muted" />
                                <asp:TemplateField HeaderText="Actions" ItemStyle-CssClass="text-end px-4">
                                    <ItemTemplate>
                                        <asp:LinkButton ID="btnDelete" runat="server" CommandName="DeleteFeedback" 
                                            CommandArgument='<%# Eval("RatingId") %>' CssClass="btn btn-sm btn-outline-danger rounded-pill px-3 hover-lift shadow-sm"
                                            OnClientClick="return confirm('Are you sure you want to delete this feedback? This action is permanent.');">
                                            <i class="fas fa-trash-alt me-1"></i>Delete
                                        </asp:LinkButton>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                            <EmptyDataTemplate>
                                <div class="text-center py-5">
                                    <i class="fas fa-comment-slash fa-3x text-muted opacity-25 mb-3"></i>
                                    <p class="text-muted">No feedback found in the system.</p>
                                </div>
                            </EmptyDataTemplate>
                        </asp:GridView>
                    </div>
                </div>
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>
</asp:Content>
