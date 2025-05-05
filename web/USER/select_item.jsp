<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*" %>

<%
    // Retrieve the data from the request parameters
    String itemId = request.getParameter("itemId");
    String itemName = request.getParameter("itemName");
    String itemQuantity = request.getParameter("itemQuantity");
    String userId = request.getParameter("userId");

    // Check if all necessary data is available
    if (itemId == null || itemName == null || itemQuantity == null || userId == null) {
        response.sendRedirect("home.jsp");
    }
%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Select Item</title>
        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    </head>
    <body>
<jsp:include page="/components/navbar.jsp"/>
        <div class="container mt-5">
            <h2>Select Quantity for <%= itemName %></h2>
            <form action="../GetItemServlet" method="POST">
                <input type="hidden" name="itemId" value="<%= itemId %>">
                <input type="hidden" name="userId" value="<%= userId %>">
                <div class="mb-3">
                    <label for="itemName" class="form-label">Item Name</label>
                    <input type="text" class="form-control" id="itemName" name="itemName" value="<%= itemName %>" readonly>
                </div>
                <div class="mb-3">
                    <label for="availableQuantity" class="form-label">Available Quantity</label>
                    <input type="number" class="form-control" id="availableQuantity" name="availableQuantity" value="<%= itemQuantity %>" readonly>
                </div>
                <div class="mb-3">
                    <label for="desiredQuantity" class="form-label">Desired Quantity</label>
                    <input type="number" class="form-control" id="desiredQuantity" name="desiredQuantity" min="1" max="<%= itemQuantity %>" required>
                </div>
                <button type="submit" class="btn btn-primary">Submit</button>
            </form>
        </div>

        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
