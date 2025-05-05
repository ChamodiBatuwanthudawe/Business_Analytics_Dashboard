<%@page import="models.User"%>
<%
    // Ensure user is logged in and has "Admin" role
    if (session.getAttribute("username") == null || session.getAttribute("role") == null || !session.getAttribute("role").equals("Admin")) {
        response.sendRedirect("../login.jsp"); // Redirect if not logged in or not an admin
    }
    
    User user = (User) request.getAttribute("user");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Edit User</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</head>
<body>
<jsp:include page="/components/navbar.jsp"/>

    <div class="container mt-5">
        <h1 class="mb-4">Edit User</h1>
        <form action="UserController" method="POST" class="needs-validation" novalidate>
            <!-- Hidden Fields -->
            <input type="hidden" name="action" value="update">
            <input type="hidden" name="id" value="<%= user.getId() %>">
            
            <!-- Username -->
            <div class="mb-3">
                <label for="username" class="form-label">Username</label>
                <input type="text" class="form-control" id="username" name="username" value="<%= user.getUsername() %>" required>
                <div class="invalid-feedback">Username is required.</div>
            </div>
            
            <!-- Password -->
            <div class="mb-3">
                <label for="password" class="form-label">Password</label>
                <input type="password" class="form-control" id="password" name="password" value="<%= user.getPassword() %>" required>
                <div class="invalid-feedback">Password is required.</div>
            </div>
            
            <!-- Email -->
            <div class="mb-3">
                <label for="email" class="form-label">Email</label>
                <input type="email" class="form-control" id="email" name="email" value="<%= user.getEmail() %>" required>
                <div class="invalid-feedback">Please enter a valid email.</div>
            </div>
            
            <!-- Full Name -->
            <div class="mb-3">
                <label for="full_name" class="form-label">Full Name</label>
                <input type="text" class="form-control" id="full_name" name="full_name" value="<%= user.getFullName() %>" required>
                <div class="invalid-feedback">Full name is required.</div>
            </div>
            
            <!-- Role -->
            <div class="mb-3">
                <label for="role" class="form-label">Role</label>
                <select class="form-select" id="role" name="role" required>
                    <option value="Admin" <%= user.getRole().equals("Admin") ? "selected" : "" %>>Admin</option>
                    <option value="User" <%= user.getRole().equals("User") ? "selected" : "" %>>User</option>
                </select>
                <div class="invalid-feedback">Please select a role.</div>
            </div>
            
            <!-- Department -->
            <div class="d-flex flex-row align-items-center mb-4">
                <i class="fas fa-briefcase fa-lg me-3 fa-fw"></i>
                <div data-mdb-input-init class="form-outline flex-fill mb-0">
                    <select class="form-select" id="department" name="department_id" required>
                        <option value="1" <%= user.getDepartmentId() == 1 ? "selected" : "" %>>HR</option>
                        <option value="2" <%= user.getDepartmentId() == 2 ? "selected" : "" %>>Finance</option>
                        <option value="3" <%= user.getDepartmentId() == 3 ? "selected" : "" %>>Sales</option>
                        <option value="4" <%= user.getDepartmentId() == 4 ? "selected" : "" %>>Marketing</option>
                        <option value="5" <%= user.getDepartmentId() == 5 ? "selected" : "" %>>IT Support</option>
                    </select>
                    <label class="form-label" for="department">Department</label>
                </div>
            </div>
            
            <!-- Status -->
            <div class="mb-3">
                <label for="status" class="form-label">Status</label>
                <select class="form-select" id="status" name="status" required>
                    <option value="ACTIVE" <%= user.getStatus().equals("ACTIVE") ? "selected" : "" %>>Active</option>
                    <option value="INACTIVE" <%= user.getStatus().equals("INACTIVE") ? "selected" : "" %>>Inactive</option>
                </select>
                <div class="invalid-feedback">Please select a status.</div>
            </div>
            
            <!-- Submit Button -->
            <button type="submit" class="btn btn-primary">Update User</button>
        </form>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Bootstrap form validation
        (function () {
            'use strict'
            const forms = document.querySelectorAll('.needs-validation')
            Array.from(forms).forEach(form => {
                form.addEventListener('submit', event => {
                    if (!form.checkValidity()) {
                        event.preventDefault()
                        event.stopPropagation()
                    }
                    form.classList.add('was-validated')
                }, false)
            })
        })()
    </script>
</body>
</html>
