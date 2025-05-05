<%@page import="models.DBConnection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>
<%@ page import="java.util.List, java.util.Map" %>
<%@ page import="java.sql.*" %>

<%
    if (session.getAttribute("username") == null) {
        response.sendRedirect("../login.jsp");
    }

    // Fetching items from the database
    List<Map<String, Object>> items = new ArrayList<>();
    Connection connection = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    try {
        connection = DBConnection.dbConn();
        String sql = "SELECT * FROM inventory WHERE status = 'IN STOCK'";
        stmt = connection.prepareStatement(sql);
        rs = stmt.executeQuery();

        while (rs.next()) {
            Map<String, Object> item = new HashMap<>();
            item.put("id", rs.getInt("id"));
            item.put("quantity", rs.getInt("quantity"));
            item.put("item_name", rs.getString("item_name"));
            item.put("description", rs.getString("description"));
            items.add(item);
        }

    } catch (SQLException | ClassNotFoundException e) {
        e.printStackTrace();
    } finally {
        try {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (connection != null) connection.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Available Items</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        
        <style>
            :root {
                --primary: #4e73df;
                --success: #1cc88a;
                --warning: #f6c23e;
                --danger: #e74a3b;
                --light: #f8f9fc;
            }
            
            body {
                background-color: #f5f7fb;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            }
            
            .inventory-header {
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
            
            .btn-get-item {
                border-radius: 50px;
                padding: 8px 20px;
                font-weight: 600;
                transition: all 0.3s;
            }
            
            .btn-get-item:hover {
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
        <jsp:include page="/components/navbar.jsp"/>

        <!-- Check for success or error messages -->
        <%
            String successMessage = request.getParameter("success");
            String errorMessage = request.getParameter("error");

            if (successMessage != null) {
        %>
            <script>
                document.addEventListener('DOMContentLoaded', function() {
                    Swal.fire({
                        icon: 'success',
                        title: 'Success!',
                        text: '<%= successMessage %>',
                        toast: true,
                        position: 'top-end',
                        showConfirmButton: false,
                        timer: 3000
                    });
                });
            </script>
        <%
            } else if (errorMessage != null) {
        %>
            <script>
                document.addEventListener('DOMContentLoaded', function() {
                    Swal.fire({
                        icon: 'error',
                        title: 'Error!',
                        text: '<%= errorMessage %>',
                        toast: true,
                        position: 'top-end',
                        showConfirmButton: false,
                        timer: 3000
                    });
                });
            </script>
        <%
            }
        %>

        <div class="container py-4">
            <div class="card">
                <div class="card-header d-flex justify-content-between align-items-center">
                    <h4 class="mb-0">
                        <i class="fas fa-box-open me-2"></i>
                        Available Items
                    </h4>
                    <span class="badge bg-primary">
                        <%= items.size() %> Items Available
                    </span>
                </div>
                
                <div class="card-body">
                    <% if (items != null && !items.isEmpty()) { %>
                    <div class="table-responsive">
                        <table class="table table-hover align-middle">
                            <thead>
                                <tr>
                                    <th>Item</th>
                                    <th>Description</th>
                                    <th>Quantity</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (Map<String, Object> item : items) { %>
                                <tr>
                                    <td class="item-name"><%= item.get("item_name") %></td>
                                    <td><%= item.get("description") %></td>
                                    <td>
                                        <span class="quantity-badge">
                                            <%= item.get("quantity") %> in stock
                                        </span>
                                    </td>
                                    <td>
                                        <button class="btn btn-primary btn-get-item" 
                                            data-item-id="<%= item.get("id") %>" 
                                            data-item-user_id="<%= session.getAttribute("id") %>" 
                                            data-item-name="<%= item.get("item_name") %>" 
                                            data-item-quantity="<%= item.get("quantity") %>">
                                            <i class="fas fa-cart-plus me-1"></i> Get Item
                                        </button>
                                    </td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                    <% } else { %>
                    <div class="empty-state">
                        <i class="fas fa-box-open"></i>
                        <h4>No Items Available</h4>
                        <p class="text-muted">All items are currently out of stock.</p>
                    </div>
                    <% } %>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            document.addEventListener('DOMContentLoaded', function() {
                const getItemButtons = document.querySelectorAll('.btn-get-item');
                
                getItemButtons.forEach(button => {
                    button.addEventListener('click', function() {
                        // Get data attributes
                        const itemId = button.getAttribute('data-item-id');
                        const userId = button.getAttribute('data-item-user_id');
                        const itemName = button.getAttribute('data-item-name');
                        const itemQuantity = button.getAttribute('data-item-quantity');
                        
                        // Show confirmation dialog
                        Swal.fire({
                            title: 'Confirm Selection',
                            html: `You are about to request <b>${itemName}</b><br>Available quantity: <b>${itemQuantity}</b>`,
                            icon: 'question',
                            showCancelButton: true,
                            confirmButtonColor: '#4e73df',
                            cancelButtonColor: '#6c757d',
                            confirmButtonText: 'Continue',
                            cancelButtonText: 'Cancel'
                        }).then((result) => {
                            if (result.isConfirmed) {
                                // Redirect to select_item.jsp with parameters
                                window.location.href = 'select_item.jsp?itemId=' + itemId + 
                                    '&itemName=' + encodeURIComponent(itemName) + 
                                    '&itemQuantity=' + itemQuantity + 
                                    '&userId=' + userId;
                            }
                        });
                    });
                });
            });
        </script>
    </body>
</html>