<%@ page import="models.inventoryTbl"%>
<%@ page import="models.User" %>
<%
    // Ensure user is logged in and has "Admin" role
    if (session.getAttribute("username") == null || session.getAttribute("role") == null || !session.getAttribute("role").equals("Admin")) {
        response.sendRedirect("../login.jsp"); // Redirect if not logged in or not an admin
    }
    
    inventoryTbl inventory = (inventoryTbl) request.getAttribute("inventory");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Edit Inventory Item</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</head>
<body>
    <jsp:include page="/components/navbar.jsp"/>

    <div class="container mt-5">
        <h1 class="mb-4">Edit Inventory Item</h1>
        <form action="InventoryController" method="POST" class="needs-validation" novalidate>
            <!-- Hidden Fields -->
            <input type="hidden" name="action" value="update">
            <input type="hidden" name="id" value="<%= inventory.getId() %>">
            
            <!-- Item Name -->
            <div class="mb-3">
                <label for="item_name" class="form-label">Item Name</label>
                <input type="text" class="form-control" id="item_name" name="item_name" value="<%= inventory.getItemName() %>" required>
                <div class="invalid-feedback">Item name is required.</div>
            </div>
            
            <!-- Description -->
            <div class="mb-3">
                <label for="description" class="form-label">Description</label>
                <input type="text" class="form-control" id="description" name="description" value="<%= inventory.getDescription() %>" required>
                <div class="invalid-feedback">Description is required.</div>
            </div>
            
            <!-- Quantity -->
            <div class="mb-3">
                <label for="quantity" class="form-label">Quantity</label>
                <input type="number" class="form-control" id="quantity" name="quantity" value="<%= inventory.getQuantity() %>" required>
                <div class="invalid-feedback">Quantity is required.</div>
            </div>
            
            <!-- Status -->
            <div class="form-group">
                    <label for="status">Status</label>
                    <select name="status" id="status" class="form-control" required>
                        <option value="IN STOCK" <%= inventory.getStatus().equals("IN STOCK") ? "selected" : ""%>>IN STOCK</option>
                        <option value="OUT OF STOCK" <%= inventory.getStatus().equals("OUT OF STOCK") ? "selected" : ""%>>Out of Stock</option>
                    </select>
                </div>
            
            <!-- Submit Button -->
            <button type="submit" class="btn btn-primary">Update Inventory Item</button>
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
