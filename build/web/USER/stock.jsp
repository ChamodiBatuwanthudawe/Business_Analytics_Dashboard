<%@page import="models.DBConnection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>
<%@ page import="java.util.List, java.util.Map" %>
<%@ page import="java.sql.*" %>
<%@page import="models.stockPDFGenerator" %>

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
        String sql = "SELECT * FROM inventory";
        stmt = connection.prepareStatement(sql);
        rs = stmt.executeQuery();

        while (rs.next()) {
            Map<String, Object> item = new HashMap<>();
            item.put("id", rs.getInt("id"));
            item.put("quantity", rs.getInt("quantity"));
            item.put("item_name", rs.getString("item_name"));
            item.put("description", rs.getString("description"));
            item.put("img_path", rs.getString("img_path"));
            item.put("status", rs.getString("status"));
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

    String type = request.getParameter("type");
    if (type != null && type.equals("pdf")) {
        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "attachment; filename=inventory.pdf");
        stockPDFGenerator.generatePDF(items, response);
    }
%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Inventory Management</title>
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
            
            .inventory-header {
                background: linear-gradient(135deg, var(--primary) 0%, #224abe 100%);
                color: white;
                border-radius: 10px;
                box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
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
            
            .export-btn {
                border-radius: 50px;
                padding: 8px 20px;
                font-weight: 600;
                transition: all 0.3s;
            }
            
            .export-btn:hover {
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
        </style>
    </head>
    <body>
        <jsp:include page="/components/navbar.jsp"/>

        <div class="container py-4">
            <div class="card">
                <div class="card-header d-flex justify-content-between align-items-center">
                    <h4 class="mb-0">
                        <i class="fas fa-boxes me-2"></i>
                        Inventory Management
                    </h4>
                    <%
                        if ("Admin".equals(session.getAttribute("role"))) {
                    %>
                    <a href="stock.jsp?type=pdf" class="btn btn-danger export-btn">
                        <i class="fas fa-file-pdf me-1"></i> Export PDF
                    </a>
                    <%
                        }
                    %>
                </div>
                
                <div class="card-body">
                    <% if (items != null && !items.isEmpty()) { %>
                    <div class="table-responsive">
                        <table class="table table-hover align-middle">
                            <thead>
                                <tr>
                                    <th>Item Name</th>
                                    <th>Description</th>
                                    <th>Quantity</th>
                                    <th>Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (Map<String, Object> item : items) { 
                                    String statusClass = "IN STOCK".equals(item.get("status")) ? "status-in-stock" : "status-out-of-stock";
                                %>
                                <tr>
                                    <td class="fw-bold"><%= item.get("item_name") %></td>
                                    <td><%= item.get("description") %></td>
                                    <td><%= item.get("quantity") %></td>
                                    <td>
                                        <span class="status-badge <%= statusClass %>">
                                            <%= item.get("status") %>
                                        </span>
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
                        <p class="text-muted">The inventory is currently empty.</p>
                    </div>
                    <% } %>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script>
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
                    title: 'Viewing inventory items'
                });
            });
        </script>
    </body>
</html>