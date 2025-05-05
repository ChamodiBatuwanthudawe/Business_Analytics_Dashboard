<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.sql.Connection" %>
<%@page import="java.sql.PreparedStatement" %>
<%@page import="java.sql.ResultSet" %>
<%@page import="java.sql.SQLException" %>
<%@page import="java.util.ArrayList" %>
<%@page import="java.util.List" %>
<%@page import="models.DBConnection" %>
<%@page import="models.IssuedItem" %>
<%@page import="models.PDFGenerator" %>
<%@page import="models.ExcelGenerator" %>

<%
    // Ensure user is logged in and has "Admin" role
    if (session.getAttribute("username") == null || session.getAttribute("role") == null || !session.getAttribute("role").equals("Admin")) {
        response.sendRedirect("../login.jsp"); // Redirect if not logged in or not an admin
    }

    // List to hold all issued items
    List<IssuedItem> issuedItems = new ArrayList<>();
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        conn = DBConnection.dbConn(); // Get the DB connection
        String query = "SELECT * FROM issued_items_view";
        pstmt = conn.prepareStatement(query);
        rs = pstmt.executeQuery();

        // Process the result set and store the issued items
        while (rs.next()) {
            IssuedItem item = new IssuedItem();
            item.setStatus(rs.getString("status"));
            item.setQuantity(rs.getInt("quantity"));
            item.setCreatedAt(rs.getTimestamp("created_at"));
            item.setItemName(rs.getString("item_name"));
            item.setFullName(rs.getString("full_name"));
            issuedItems.add(item);
        }
    } catch (SQLException | ClassNotFoundException e) {
        e.printStackTrace();
        response.sendRedirect("USER/dashboard.jsp?error=database_error");
    } finally {
        try {
            if (rs != null) {
                rs.close();
            }
            if (pstmt != null) {
                pstmt.close();
            }
            if (conn != null) {
                conn.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Handle PDF or Excel download based on the request type
    String type = request.getParameter("type");
    
    if (type != null) {
        if (type.equals("pdf")) {
            response.setContentType("application/pdf");
            response.setHeader("Content-Disposition", "attachment; filename=issued_items.pdf");
            PDFGenerator.generatePDF(issuedItems, response);
        } else if (type.equals("excel")) {
            response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
            response.setHeader("Content-Disposition", "attachment; filename=issued_items.xlsx");
            ExcelGenerator.generateExcel(issuedItems, response);
        }
    }
    
%>

<%
    // Declare variables for counting users
    int userCount = 0;

    // Database connection setup
    try {
        conn = DBConnection.dbConn(); // Get the DB connection
        String query = "SELECT COUNT(id) AS user_count FROM users";
        pstmt = conn.prepareStatement(query);
        rs = pstmt.executeQuery();

        if (rs.next()) {
            userCount = rs.getInt("user_count"); // Get the count of users
        }
    } catch (SQLException | ClassNotFoundException e) {
        e.printStackTrace();
        response.sendRedirect("USER/dashboard.jsp?error=database_error");
    } finally {
        try {
            if (rs != null) {
                rs.close();
            }
            if (pstmt != null) {
                pstmt.close();
            }
            if (conn != null) {
                conn.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>
<%
    // Declare variables for counting total inventory items and counts for each status
    int totalInventoryCount = 0;
    int inStockCount = 0;
    int outOfStockCount = 0;

    // Database connection setup
    try {
        conn = DBConnection.dbConn(); // Get the DB connection

        // Query to count total items and count items by status
        String query = "SELECT status, COUNT(id) AS status_count FROM inventory GROUP BY status";
        pstmt = conn.prepareStatement(query);
        rs = pstmt.executeQuery();

        // Process the result set to get the counts for total and each status
        while (rs.next()) {
            String status = rs.getString("status");
            int count = rs.getInt("status_count");

            if ("IN STOCK".equals(status)) {
                inStockCount = count; // Set the count for "IN STOCK"
            } else if ("OUT OF STOCK".equals(status)) {
                outOfStockCount = count; // Set the count for "OUT OF STOCK"
            }
        }

        // Query to get the total inventory items count
        String totalQuery = "SELECT COUNT(id) AS total_count FROM inventory";
        pstmt = conn.prepareStatement(totalQuery);
        rs = pstmt.executeQuery();

        // Get the total count
        if (rs.next()) {
            totalInventoryCount = rs.getInt("total_count");
        }
    } catch (SQLException | ClassNotFoundException e) {
        e.printStackTrace();
        response.sendRedirect("USER/dashboard.jsp?error=database_error");
    } finally {
        try {
            if (rs != null) {
                rs.close();
            }
            if (pstmt != null) {
                pstmt.close();
            }
            if (conn != null) {
                conn.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Admin Dashboard</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
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
            
            .stat-card {
                border: none;
                border-radius: 10px;
                box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
                transition: all 0.3s ease;
                overflow: hidden;
                position: relative;
            }
            
            .stat-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
            }
            
            .stat-card::before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                width: 4px;
                height: 100%;
            }
            
            .stat-card.primary::before { background-color: var(--primary); }
            .stat-card.success::before { background-color: var(--secondary); }
            .stat-card.warning::before { background-color: var(--warning); }
            .stat-card.danger::before { background-color: var(--danger); }
            
            .stat-icon {
                font-size: 2.5rem;
                opacity: 0.2;
                position: absolute;
                right: 20px;
                top: 20px;
            }
            
            .chart-container {
                background: white;
                border-radius: 10px;
                box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
                padding: 20px;
                margin-bottom: 2rem;
            }
            
            .data-table {
                background: white;
                border-radius: 10px;
                box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
                overflow: hidden;
            }
            
            .table-responsive {
                max-height: 500px;
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
            
            .export-btn {
                border-radius: 50px;
                padding: 8px 20px;
                font-weight: 600;
                margin-right: 10px;
                transition: all 0.3s;
            }
            
            .export-btn:hover {
                transform: translateY(-2px);
                box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
            }
            
            .user-greeting {
                font-weight: 600;
                color: rgba(255, 255, 255, 0.9);
            }
        </style>
    </head>
    <body>
        <%
            int userId = (int) session.getAttribute("id");
            String fullName = (String) session.getAttribute("full_name");
        %>
        <jsp:include page="/components/navbar.jsp"/>

        <!-- Dashboard Header -->
        <div class="dashboard-header py-4">
            <div class="container">
                <div class="row align-items-center">
                    <div class="col-md-6">
                        <h1 class="h2 mb-0">
                            <i class="fas fa-tachometer-alt me-2"></i>
                            Admin Dashboard
                        </h1>
                        <p class="user-greeting mb-0 mt-2">Welcome back, <%= fullName %>!</p>
                    </div>
                    <div class="col-md-6 text-md-end">
                        <span class="badge bg-white text-primary px-3 py-2">
                            <i class="fas fa-user-shield me-1"></i> Administrator
                        </span>
                    </div>
                </div>
            </div>
        </div>

        <div class="container py-4">
            <!-- Stats Cards -->
            <div class="row g-4 mb-4">
                <div class="col-md-6 col-lg-3">
                    <div class="stat-card primary h-100">
                        <div class="card-body p-4">
                            <i class="fas fa-users stat-icon text-primary"></i>
                            <h6 class="text-uppercase text-muted mb-2">Total Users</h6>
                            <h3 class="mb-0"><%= userCount %></h3>
                            <p class="text-muted mb-0 small">All registered users</p>
                        </div>
                    </div>
                </div>
                
                <div class="col-md-6 col-lg-3">
                    <div class="stat-card success h-100">
                        <div class="card-body p-4">
                            <i class="fas fa-boxes stat-icon text-success"></i>
                            <h6 class="text-uppercase text-muted mb-2">Total Items</h6>
                            <h3 class="mb-0"><%= totalInventoryCount %></h3>
                            <p class="text-muted mb-0 small">Inventory items</p>
                        </div>
                    </div>
                </div>
                
                <div class="col-md-6 col-lg-3">
                    <div class="stat-card warning h-100">
                        <div class="card-body p-4">
                            <i class="fas fa-check-circle stat-icon text-warning"></i>
                            <h6 class="text-uppercase text-muted mb-2">In Stock</h6>
                            <h3 class="mb-0"><%= inStockCount %></h3>
                            <p class="text-muted mb-0 small">Available items</p>
                        </div>
                    </div>
                </div>
                
                <div class="col-md-6 col-lg-3">
                    <div class="stat-card danger h-100">
                        <div class="card-body p-4">
                            <i class="fas fa-exclamation-circle stat-icon text-danger"></i>
                            <h6 class="text-uppercase text-muted mb-2">Out of Stock</h6>
                            <h3 class="mb-0"><%= outOfStockCount %></h3>
                            <p class="text-muted mb-0 small">Unavailable items</p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Charts Row -->
            <div class="row g-4 mb-4">
                <div class="col-lg-6">
                    <div class="chart-container">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <h5 class="mb-0">
                                <i class="fas fa-chart-pie me-2 text-primary"></i>
                                Inventory Status
                            </h5>
                            <div class="dropdown">
                                <button class="btn btn-sm btn-outline-secondary dropdown-toggle" type="button" 
                                    data-bs-toggle="dropdown" aria-expanded="false">
                                    <i class="fas fa-ellipsis-v"></i>
                                </button>
                                <ul class="dropdown-menu">
                                    <li><a class="dropdown-item" href="#">View Details</a></li>
                                    <li><a class="dropdown-item" href="#">Export</a></li>
                                </ul>
                            </div>
                        </div>
                        <div style="height: 300px;">
                            <canvas id="inventoryChart"></canvas>
                        </div>
                    </div>
                </div>
                
                <div class="col-lg-6">
                    <div class="chart-container">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <h5 class="mb-0">
                                <i class="fas fa-chart-line me-2 text-primary"></i>
                                Recent Activity
                            </h5>
                            <div class="dropdown">
                                <button class="btn btn-sm btn-outline-secondary dropdown-toggle" type="button" 
                                    data-bs-toggle="dropdown" aria-expanded="false">
                                    <i class="fas fa-ellipsis-v"></i>
                                </button>
                                <ul class="dropdown-menu">
                                    <li><a class="dropdown-item" href="#">View Details</a></li>
                                    <li><a class="dropdown-item" href="#">Export</a></li>
                                </ul>
                            </div>
                        </div>
                        <div style="height: 300px;">
                            <canvas id="activityChart"></canvas>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Issued Items Table -->
            <div class="data-table">
                <div class="p-4 border-bottom">
                    <div class="d-flex justify-content-between align-items-center">
                        <h5 class="mb-0">
                            <i class="fas fa-exchange-alt me-2 text-primary"></i>
                            Issued Items
                        </h5>
                        <div>
                            <a href="dashboard.jsp?type=pdf" class="btn btn-danger export-btn">
                                <i class="fas fa-file-pdf me-1"></i> Export PDF
                            </a>
                            
                        </div>
                    </div>
                </div>
                
                <div class="table-responsive p-4">
                    <table class="table table-hover">
                        <thead>
                            <tr>
                                <th>Status</th>
                                <th>Quantity</th>
                                <th>Date/Time</th>
                                <th>Item</th>
                                <th>User</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                SimpleDateFormat dateFormat = new SimpleDateFormat("MMM dd, yyyy hh:mm a");
                                for (IssuedItem item : issuedItems) {
                            %>
                            <tr>
                                <td>
                                    <span class="badge <%= item.getStatus().equals("ISSUED") ? "bg-success" : "bg-warning"%>">
                                        <%= item.getStatus()%>
                                    </span>
                                </td>
                                <td><%= item.getQuantity()%></td>
                                <td><%= dateFormat.format(item.getCreatedAt())%></td>
                                <td><%= item.getItemName()%></td>
                                <td><%= item.getFullName()%></td>
                            </tr>
                            <%
                                }
                            %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            // Inventory Status Pie Chart
            document.addEventListener('DOMContentLoaded', function() {
                const inventoryCtx = document.getElementById('inventoryChart');
                new Chart(inventoryCtx, {
                    type: 'doughnut',
                    data: {
                        labels: ['In Stock', 'Out of Stock'],
                        datasets: [{
                            data: [<%= inStockCount%>, <%= outOfStockCount%>],
                            backgroundColor: ['#1cc88a', '#e74a3b'],
                            borderWidth: 0,
                        }]
                    },
                    options: {
                        maintainAspectRatio: false,
                        cutout: '70%',
                        plugins: {
                            legend: {
                                position: 'bottom',
                                labels: {
                                    padding: 20,
                                    usePointStyle: true,
                                    pointStyle: 'circle'
                                }
                            }
                        }
                    }
                });

                // Activity Line Chart
                const activityCtx = document.getElementById('activityChart');
                new Chart(activityCtx, {
                    type: 'line',
                    data: {
                        labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul'],
                        datasets: [{
                            label: 'Issued Items',
                            data: [12, 19, 15, 27, 22, 18, 24],
                            borderColor: '#4e73df',
                            backgroundColor: 'rgba(78, 115, 223, 0.05)',
                            fill: true,
                            tension: 0.3,
                            pointRadius: 4,
                            pointBackgroundColor: '#4e73df',
                            pointBorderColor: '#fff',
                            pointHoverRadius: 6,
                            pointHoverBorderWidth: 2
                        }]
                    },
                    options: {
                        maintainAspectRatio: false,
                        scales: {
                            y: {
                                beginAtZero: true,
                                grid: {
                                    drawBorder: false
                                },
                                ticks: {
                                    precision: 0
                                }
                            },
                            x: {
                                grid: {
                                    display: false
                                }
                            }
                        },
                        plugins: {
                            legend: {
                                display: false
                            }
                        }
                    }
                });

                // Show welcome notification
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
                    icon: 'success',
                    title: 'Welcome back, Admin!'
                });
            });
        </script>
    </body>
</html>