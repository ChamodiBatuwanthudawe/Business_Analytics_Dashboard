<%@page import="models.inventoryTbl"%>
<%@page import="java.util.List"%>
<%
    // Ensure user is logged in and has "Admin" role
    if (session.getAttribute("username") == null || session.getAttribute("role") == null || !session.getAttribute("role").equals("Admin")) {
        response.sendRedirect("../login.jsp");
    }
%>
<%
    List<inventoryTbl> inventoryList = (List<inventoryTbl>) request.getAttribute("inventoryList");
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Manage Inventory</title>
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
            
            .status-badge {
                padding: 6px 12px;
                border-radius: 20px;
                font-weight: 600;
                font-size: 0.8rem;
                text-transform: uppercase;
            }
            
            .status-in-stock {
                background-color: rgba(28, 200, 138, 0.1);
                color: var(--success);
            }
            
            .status-out-of-stock {
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
            
            .item-name {
                font-weight: 600;
                color: var(--primary);
            }
            
            .quantity-badge {
                background-color: rgba(78, 115, 223, 0.1);
                color: var(--primary);
                padding: 5px 10px;
                border-radius: 20px;
                font-weight: 600;
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
                        <i class="fas fa-boxes me-2"></i>
                        Inventory Management
                    </h4>
                    <form action="InventoryController" method="GET" class="d-inline">
                        <input type="hidden" name="action" value="add">
                        <button type="submit" class="btn btn-success btn-action">
                            <i class="fas fa-plus me-1"></i> Add New Item
                        </button>
                    </form>
                </div>
                
                <div class="card-body">
                    <% if (inventoryList != null && !inventoryList.isEmpty()) { %>
                    <div class="table-responsive">
                        <table class="table table-hover align-middle">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Item</th>
                                    <th>Description</th>
                                    <th>Quantity</th>
                                    <th>Status</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (inventoryTbl item : inventoryList) { 
                                    String statusClass = "IN STOCK".equals(item.getStatus()) ? "status-in-stock" : "status-out-of-stock";
                                %>
                                <tr>
                                    <td><%= item.getId() %></td>
                                    <td class="item-name"><%= item.getItemName() %></td>
                                    <td><%= item.getDescription() %></td>
                                    <td>
                                        <span class="quantity-badge">
                                            <%= item.getQuantity() %>
                                        </span>
                                    </td>
                                    <td>
                                        <span class="status-badge <%= statusClass %>">
                                            <%= item.getStatus() %>
                                        </span>
                                    </td>
                                    <td>
                                        <!-- Edit Button -->
                                        <form action="InventoryController" method="GET" class="d-inline">
                                            <input type="hidden" name="id" value="<%= item.getId() %>">
                                            <input type="hidden" name="action" value="edit">
                                            <button type="submit" class="btn btn-warning btn-action me-2">
                                                <i class="fas fa-edit me-1"></i> Edit
                                            </button>
                                        </form>

                                        <!-- Delete Button -->
                                        <form id="deleteForm<%= item.getId() %>" action="InventoryController" method="POST" class="d-inline">
                                            <input type="hidden" name="id" value="<%= item.getId() %>">
                                            <input type="hidden" name="action" value="delete">
                                            <button type="button" class="btn btn-danger btn-action" 
                                                onclick="confirmDelete(<%= item.getId() %>)">
                                                <i class="fas fa-trash-alt me-1"></i> Delete
                                            </button>
                                        </form>
                                    </td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                    <% } else { %>
                    <div class="empty-state">
                        <i class="fas fa-box-open"></i>
                        <h4>No Inventory Items</h4>
                        <p class="text-muted">There are no inventory items to display.</p>
                    </div>
                    <% } %>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            function confirmDelete(itemId) {
                Swal.fire({
                    title: 'Confirm Deletion',
                    html: 'Are you sure you want to delete this item?<br>This action cannot be undone.',
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
                        // Submit the corresponding delete form
                        document.getElementById('deleteForm' + itemId).submit();
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
                    title: 'Managing inventory items'
                });
            });
        </script>
    </body>
</html>