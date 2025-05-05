<%@page import="java.text.SimpleDateFormat"%>
<%@ page import="models.DBConnection" %>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ page import="java.util.*, java.sql.*, java.util.Map" %>

<%
    // Check if the user is logged in
    if (session.getAttribute("username") == null) {
        response.sendRedirect("../login.jsp");
    }

    // Get the logged-in user's ID from the session
    int userId = (Integer) session.getAttribute("id");

    // List to store issued items
    List<Map<String, Object>> issuedItems = new ArrayList<>();
    Connection connection = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    try {
        // Establish the database connection
        connection = DBConnection.dbConn();

        // Updated SQL query to fetch only 'Brought' items and include created_at as Brought date
        String sql = "SELECT ii.id, ii.item_id, ii.quantity, ii.created_at, i.item_name " +
                     "FROM issued_items ii " +
                     "JOIN inventory i ON ii.item_id = i.id " +
                     "WHERE ii.user_id = ? AND ii.status = 'Brought'";

        stmt = connection.prepareStatement(sql);
        stmt.setInt(1, userId);  // Set the user_id in the query

        // Execute the query
        rs = stmt.executeQuery();

        // Populate the issuedItems list
        while (rs.next()) {
            Map<String, Object> item = new HashMap<>();
            item.put("id", rs.getInt("id"));
            item.put("quantity", rs.getInt("quantity"));
            item.put("brought_date", rs.getTimestamp("created_at")); // Store the Brought date
            item.put("item_name", rs.getString("item_name"));
            
            item.put("item_id", rs.getInt("item_id"));

            issuedItems.add(item);
        }
    } catch (SQLException | ClassNotFoundException e) {
        e.printStackTrace();
    } finally {
        try {
            if (rs != null) {
                rs.close();
            }
            if (stmt != null) {
                stmt.close();
            }
            if (connection != null) {
                connection.close();
            }
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
        <title>My Issued Items</title>
        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
        <!-- SweetAlert2 -->
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        
        <style>
            :root {
                --primary: #4e73df;
                --secondary: #1cc88a;
                --warning: #f6c23e;
                --danger: #e74a3b;
                --info: #36b9cc;
                --dark: #5a5c69;
                --light: #f8f9fc;
                --gray: #dddfeb;
            }
            
            body {
                background-color: #f8fafc;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            }
            
            .dashboard-header {
                background: linear-gradient(135deg, var(--primary) 0%, #224abe 100%);
                color: white;
                border-radius: 0 0 20px 20px;
                box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
                margin-bottom: 2rem;
            }
            
            .card {
                border: none;
                border-radius: 10px;
                box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
                transition: all 0.3s ease;
            }
            
            .card-header {
                background-color: white;
                border-bottom: 1px solid rgba(0, 0, 0, 0.05);
                font-weight: 600;
            }
            
            .table-responsive {
                max-height: 500px;
                overflow-y: auto;
            }
            
            .table thead th {
                background-color: var(--primary);
                color: white;
                position: sticky;
                top: 0;
                z-index: 10;
            }
            
            .badge {
                padding: 6px 10px;
                font-weight: 500;
                border-radius: 50px;
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
                color: var(--gray);
                margin-bottom: 1rem;
            }
            
            .date-cell {
                white-space: nowrap;
            }
        </style>
    </head>
    <body>
        <!-- Include Navbar -->
        <jsp:include page="/components/navbar.jsp"/>

        <!-- Main Content -->
        <div class="container py-4">
            <div class="card">
                <div class="card-header d-flex justify-content-between align-items-center">
                    <h4 class="mb-0">
                        <i class="fas fa-box-open me-2"></i>
                        My Issued Items
                    </h4>
                    <span class="badge bg-primary">
                        Total Items: <%= issuedItems.size() %>
                    </span>
                </div>
                
                <div class="card-body">
                    <% if (issuedItems.isEmpty()) { %>
                    <div class="empty-state">
                        <i class="fas fa-box-open"></i>
                        <h4>No Items Issued</h4>
                        <p class="text-muted">You haven't issued any items yet.</p>
                    </div>
                    <% } else { %>
                    <div class="table-responsive">
                        <table class="table table-hover align-middle">
                            <thead>
                                <tr>
                                    <th>Item Name</th>
                                    <th>Quantity</th>
                                    <th>Brought Date</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% 
                                SimpleDateFormat dateFormat = new SimpleDateFormat("MMM dd, yyyy hh:mm a");
                                for (Map<String, Object> item : issuedItems) { 
                                %>
                                <tr>
                                    <td class="fw-bold"><%= item.get("item_name") %></td>
                                    <td><span class="badge bg-secondary"><%= item.get("quantity") %></span></td>
                                    <td class="date-cell"><%= dateFormat.format(item.get("brought_date")) %></td>
                                    <td>
                                        <button class="btn btn-warning btn-action" 
                                           onclick="confirmReturn(<%= item.get("item_id") %>, <%= item.get("id") %>, <%= item.get("quantity") %>, <%= session.getAttribute("id") %>)">
                                            <i class="fas fa-reply me-1"></i> Return
                                        </button>
                                    </td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                    <% } %>
                </div>
            </div>
        </div>

        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

        <script>
            function confirmReturn(itemId, invItemId, itemQuantity, userId) {
                Swal.fire({
                    title: 'Confirm Return',
                    html: `You are about to return <b>${itemQuantity}</b> item(s).<br>Are you sure you want to proceed?`,
                    icon: 'question',
                    showCancelButton: true,
                    confirmButtonColor: '#3085d6',
                    cancelButtonColor: '#d33',
                    confirmButtonText: 'Yes, return it!',
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
                        // Show loading indicator
                        Swal.fire({
                            title: 'Processing...',
                            html: 'Please wait while we process your return',
                            allowOutsideClick: false,
                            didOpen: () => {
                                Swal.showLoading();
                            }
                        });
                        
                        // Send request to ReturnController
                        window.location.href = "../ReturnController?itemId=" + itemId + "&invItemId=" + invItemId + "&quantity=" + itemQuantity + "&userid=" + userId;
                    }
                });
            }
            
            // Show welcome notification
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
                    title: 'Viewing your issued items'
                });
            });
        </script>
    </body>
</html>