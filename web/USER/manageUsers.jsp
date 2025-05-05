<%@page import="models.User"%>
<%@page import="java.util.List"%>
<%
    // Ensure user is logged in and has "Admin" role
    if (session.getAttribute("username") == null || session.getAttribute("role") == null || !session.getAttribute("role").equals("Admin")) {
        response.sendRedirect("../login.jsp");
    }
%>
<%
    List<User> users = (List<User>) request.getAttribute("users");
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>User Management</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        
        <style>
            :root {
                --primary: #4e73df;
                --success: #1cc88a;
                --warning: #f6c23e;
                --danger: #e74a3b;
                --info: #36b9cc;
                --light: #f8f9fc;
            }
            
            body {
                background-color: #f5f7fb;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            }
            
            .management-header {
                background: linear-gradient(135deg, var(--primary) 0%, #224abe 100%);
                color: white;
                border-radius: 10px;
                box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
                margin-bottom: 2rem;
            }
            
            .card {
                border: none;
                border-radius: 10px;
                box-shadow: 0 0.15rem 1.75rem 0 rgba(58, 59, 69, 0.1);
                transition: transform 0.3s ease;
            }
            
            .card:hover {
                transform: translateY(-5px);
            }
            
            .table-responsive {
                max-height: 500px;
                overflow-y: auto;
            }
            
            .table thead th {
                position: sticky;
                top: 0;
                background-color: var(--primary);
                color: white;
                z-index: 10;
            }
            
            .role-badge {
                padding: 6px 12px;
                border-radius: 20px;
                font-weight: 600;
                font-size: 0.8rem;
                text-transform: uppercase;
            }
            
            .role-admin {
                background-color: rgba(78, 115, 223, 0.1);
                color: var(--primary);
            }
            
            .role-user {
                background-color: rgba(28, 200, 138, 0.1);
                color: var(--success);
            }
            
            .status-badge {
                padding: 6px 12px;
                border-radius: 20px;
                font-weight: 600;
                font-size: 0.8rem;
            }
            
            .status-active {
                background-color: rgba(28, 200, 138, 0.1);
                color: var(--success);
            }
            
            .status-inactive {
                background-color: rgba(231, 74, 59, 0.1);
                color: var(--danger);
            }
            
            .btn-action {
                border-radius: 50px;
                padding: 8px 20px;
                font-weight: 600;
                transition: all 0.3s;
            }
            
            .btn-action:hover {
                transform: translateY(-2px);
                box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
            }
            
            .empty-state {
                text-align: center;
                padding: 40px;
                background-color: white;
                border-radius: 10px;
                box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
            }
            
            .empty-state i {
                font-size: 3rem;
                color: #dddfeb;
                margin-bottom: 1rem;
            }
            
            .username {
                font-weight: 600;
                color: var(--primary);
            }
        </style>
    </head>
    <body>
        <%
            int userId = (int) session.getAttribute("id");
            String fullName = (String) session.getAttribute("full_name");
        %>
        <jsp:include page="/components/navbar.jsp"/>

        <div class="container py-4">
            <div class="card">
                <div class="card-header d-flex justify-content-between align-items-center">
                    <h4 class="mb-0">
                        <i class="fas fa-users-cog me-2"></i>
                        User Management
                    </h4>
                    <form action="UserController" method="GET" class="d-inline">
                        <input type="hidden" name="action" value="add">
                        <button type="submit" class="btn btn-success btn-action">
                            <i class="fas fa-user-plus me-1"></i> Add Admin
                        </button>
                    </form>
                </div>
                
                <div class="card-body">
                    <% if (users != null && !users.isEmpty()) { %>
                    <div class="table-responsive">
                        <table class="table table-hover align-middle">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Username</th>
                                    <th>Role</th>
                                    <th>Email</th>
                                    <th>Full Name</th>
                                    <th>Status</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (User user : users) { 
                                    String roleClass = "Admin".equals(user.getRole()) ? "role-admin" : "role-user";
                                    String statusClass = "Active".equals(user.getStatus()) ? "status-active" : "status-inactive";
                                %>
                                <tr>
                                    <td><%= user.getId() %></td>
                                    <td class="username"><%= user.getUsername() %></td>
                                    <td>
                                        <span class="role-badge <%= roleClass %>">
                                            <%= user.getRole() %>
                                        </span>
                                    </td>
                                    <td><%= user.getEmail() %></td>
                                    <td><%= user.getFullName() %></td>
                                    <td>
                                        <span class="status-badge <%= statusClass %>">
                                            <%= user.getStatus() %>
                                        </span>
                                    </td>
                                    <td>
                                        <!-- Edit Button -->
                                        <form action="UserController" method="GET" class="d-inline">
                                            <input type="hidden" name="id" value="<%= user.getId() %>">
                                            <input type="hidden" name="action" value="edit">
                                            <button type="submit" class="btn btn-warning btn-action me-2">
                                                <i class="fas fa-edit me-1"></i> Edit
                                            </button>
                                        </form>

                                        <!-- Delete Button -->
                                        <button type="button" class="btn btn-danger btn-action" 
                                            onclick="confirmDelete(<%= user.getId() %>)">
                                            <i class="fas fa-trash-alt me-1"></i> Delete
                                        </button>
                                    </td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                    <% } else { %>
                    <div class="empty-state">
                        <i class="fas fa-user-slash"></i>
                        <h4>No Users Found</h4>
                        <p class="text-muted">There are no users to display.</p>
                    </div>
                    <% } %>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            function confirmDelete(userId) {
                Swal.fire({
                    title: 'Confirm Deletion',
                    html: 'Are you sure you want to delete this user?<br>This action cannot be undone.',
                    icon: 'warning',
                    showCancelButton: true,
                    confirmButtonColor: '#d33',
                    cancelButtonColor: '#6c757d',
                    confirmButtonText: 'Delete',
                    cancelButtonText: 'Cancel',
                    reverseButtons: true,
                    showClass: {
                        popup: 'animate__animated animate__fadeInDown'
                    },
                    hideClass: {
                        popup: 'animate__animated animate__fadeOutUp'
                    }
                }).then((result) => {
                    if (result.isConfirmed) {
                        // Create a form dynamically and submit it
                        const form = document.createElement('form');
                        form.method = 'POST';
                        form.action = 'UserController';

                        // Hidden fields
                        const idField = document.createElement('input');
                        idField.type = 'hidden';
                        idField.name = 'id';
                        idField.value = userId;
                        form.appendChild(idField);

                        const actionField = document.createElement('input');
                        actionField.type = 'hidden';
                        actionField.name = 'action';
                        actionField.value = 'delete';
                        form.appendChild(actionField);

                        document.body.appendChild(form);
                        form.submit();
                    }
                });
            }
            
            // Show notification when page loads
            document.addEventListener('DOMContentLoaded', function() {
                const Toast = Swal.mixin({
                    toast: true,
                    position: 'top-end',
                    showConfirmButton: false,
                    timer: 3000,
                    timerProgressBar: true,
                    didOpen: (toast) => {
                        toast.addEventListener('mouseenter', Swal.stopTimer)
                        toast.addEventListener('mouseleave', Swal.resumeTimer)
                    }
                });
                
                Toast.fire({
                    icon: 'info',
                    title: 'Managing system users'
                });
            });
        </script>
    </body>
</html>