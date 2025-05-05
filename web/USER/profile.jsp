<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="models.DBConnection" %>
<%@ page import="java.sql.*" %>
<%
    if (session.getAttribute("username") == null) {
        response.sendRedirect("../login.jsp");
    }
    String message = (String) session.getAttribute("message");
    session.removeAttribute("message"); // Clear the message after it has been displayed
    int userId = (Integer) session.getAttribute("id");
    Connection connection = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;
    PreparedStatement deptStmt = null;
    ResultSet deptRs = null;

    String username = "", email = "", fullName = "", imgPath = "", departmentName = "";
    int departmentId = 0;

    try {
        connection = DBConnection.dbConn();
        String query = "SELECT username, email, full_name, img_path, department_id FROM users WHERE id = ?";
        stmt = connection.prepareStatement(query);
        stmt.setInt(1, userId);
        rs = stmt.executeQuery();

        if (rs.next()) {
            username = rs.getString("username");
            email = rs.getString("email");
            fullName = rs.getString("full_name");
            imgPath = rs.getString("img_path");
            departmentId = rs.getInt("department_id");

            // Query to get department name based on departmentId
            String deptQuery = "SELECT name FROM departments WHERE id = ?";
            deptStmt = connection.prepareStatement(deptQuery);
            deptStmt.setInt(1, departmentId);
            deptRs = deptStmt.executeQuery();

            if (deptRs.next()) {
                departmentName = deptRs.getString("name");
            }
        }
    } catch (SQLException | ClassNotFoundException e) {
        e.printStackTrace();
    } finally {
        try {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (deptRs != null) deptRs.close();
            if (deptStmt != null) deptStmt.close();
            if (connection != null) connection.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>My Profile | IMS</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Font Awesome -->
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
        <!-- SweetAlert2 -->
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        <style>
            body {
                background-color: #f8f9fa;
                color: #495057;
            }
            .profile-header {
                background: linear-gradient(135deg, #6a11cb 0%, #2575fc 100%);
                color: white;
                border-radius: 15px;
                padding: 30px;
                margin-bottom: 30px;
                box-shadow: 0 5px 20px rgba(0, 0, 0, 0.1);
            }
            .profile-card {
                background-color: white;
                border-radius: 15px;
                box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
                padding: 30px;
                margin-bottom: 30px;
            }
            .profile-image-container {
                position: relative;
                width: 180px;
                height: 180px;
                margin: 0 auto 20px;
            }
            .profile-image {
                width: 180px;
                height: 180px;
                border-radius: 50%;
                object-fit: cover;
                border: 5px solid white;
                box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
            }
            .camera-icon {
                position: absolute;
                bottom: 10px;
                right: 10px;
                background-color: #3b71ca;
                color: white;
                width: 40px;
                height: 40px;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                cursor: pointer;
                box-shadow: 0 2px 5px rgba(0, 0, 0, 0.2);
            }
            .form-control {
                border-radius: 10px;
                padding: 12px 15px;
                margin-bottom: 15px;
                border: 1px solid #e0e0e0;
                transition: all 0.3s;
            }
            .form-control:focus {
                box-shadow: 0 0 0 3px rgba(59, 113, 202, 0.2);
                border-color: #3b71ca;
            }
            .btn {
                border-radius: 10px;
                padding: 10px 20px;
                font-weight: 500;
                transition: all 0.3s;
            }
            .btn-primary {
                background-color: #3b71ca;
                border-color: #3b71ca;
            }
            .btn-primary:hover {
                background-color: #305aa8;
                border-color: #305aa8;
            }
            .btn-secondary {
                background-color: #f8f9fa;
                border-color: #ced4da;
                color: #495057;
            }
            .btn-secondary:hover {
                background-color: #e9ecef;
                border-color: #ced4da;
                color: #212529;
            }
            label {
                font-weight: 600;
                margin-bottom: 8px;
                color: #495057;
            }
            .file-upload {
                display: none;
            }
            .department-badge {
                background-color: #e9ecef;
                color: #495057;
                padding: 8px 15px;
                border-radius: 50px;
                font-weight: 500;
                font-size: 14px;
                display: inline-flex;
                align-items: center;
                margin-top: 8px;
            }
            .department-badge i {
                margin-right: 5px;
            }
            .card-title {
                font-weight: 700;
                color: #3b71ca;
                margin-bottom: 25px;
                border-bottom: 2px solid #f8f9fa;
                padding-bottom: 15px;
            }
            .form-text {
                color: #6c757d;
            }
        </style>
    </head>
    <body>
        <jsp:include page="/components/navbar.jsp"/>

        <div class="container py-5">
            <!-- Profile Header -->
            <div class="profile-header text-center">
                <h1 class="fw-bold mb-3">My Profile</h1>
                <p class="lead mb-0">Manage your personal information and account settings</p>
            </div>

            <div class="row">
                <div class="col-lg-4 mb-4">
                    <!-- Profile Image Card -->
                    <div class="profile-card text-center">
                        <h4 class="card-title">Profile Photo</h4>
                        <form action="../ProfileController" method="post" enctype="multipart/form-data" id="imageForm">
                            <div class="profile-image-container">
                                <img src="<%= imgPath != null ? "../" + imgPath : "//placehold.it/180"%>" class="profile-image" alt="<%= fullName %>'s profile photo">
                                <label for="profilePicture" class="camera-icon">
                                    <i class="fas fa-camera"></i>
                                </label>
                                <input type="file" name="profilePicture" id="profilePicture" class="file-upload" onchange="submitImageForm()">
                                <input type="hidden" name="imageUploadOnly" value="true">
                            </div>
                            <p class="text-muted">Click on the camera icon to upload a new photo</p>
                        </form>
                        
                        <div class="mt-4">
                            <div class="department-badge w-100">
                                <i class="fas fa-building"></i>
                                <%= departmentName %>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-lg-8">
                    <!-- Personal Info Card -->
                    <div class="profile-card">
                        <h4 class="card-title">Personal Information</h4>
                        <form action="../ProfileController" method="post" enctype="multipart/form-data">
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="mb-4">
                                        <label for="fullName"><i class="fas fa-user me-2"></i>Full Name</label>
                                        <input class="form-control" type="text" name="fullName" id="fullName" value="<%= fullName %>" required>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-4">
                                        <label for="username"><i class="fas fa-at me-2"></i>Username</label>
                                        <input class="form-control" type="text" name="username" id="username" value="<%= username %>" required>
                                    </div>
                                </div>
                            </div>

                            <div class="mb-4">
                                <label for="email"><i class="fas fa-envelope me-2"></i>Email Address</label>
                                <input class="form-control" type="email" name="email" id="email" value="<%= email %>" required>
                            </div>

                            <div class="mb-4">
                                <label for="password"><i class="fas fa-lock me-2"></i>Password</label>
                                <input class="form-control" type="password" name="password" id="password">
                                <small class="form-text">Leave blank to keep your current password</small>
                            </div>

                            <div class="mb-4">
                                <label for="department"><i class="fas fa-building me-2"></i>Department</label>
                                <input class="form-control bg-light" type="text" id="department" value="<%= departmentName %>" readonly>
                                <small class="form-text">Contact an administrator to change your department</small>
                            </div>

                            <div class="d-flex gap-2 mt-4">
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-save me-2"></i>Save Changes
                                </button>
                                <a href="dashboard.jsp" class="btn btn-secondary">
                                    <i class="fas fa-times me-2"></i>Cancel
                                </a>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            function submitImageForm() {
                document.getElementById('imageForm').submit();
            }

            <%-- SweetAlert to show the success or error message --%>
            <% if (message != null) { %>
                Swal.fire({
                    title: '<%= message.contains("Successfully") ? "Success!" : "Error" %>',
                    text: '<%= message %>',
                    icon: '<%= message.contains("Successfully") ? "success" : "error" %>',
                    confirmButtonText: 'OK',
                    confirmButtonColor: '#3b71ca',
                    heightAuto: false,
                    customClass: {
                        popup: 'rounded-4'
                    }
                });
            <% } %>
        </script>
    </body>
</html>