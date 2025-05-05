package controllers;

import models.DBConnection;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import javax.servlet.annotation.WebServlet;

@WebServlet("/ReturnController")
public class ReturnController extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get itemId and quantity from the request
        int itemId = Integer.parseInt(request.getParameter("itemId"));
        int userid = Integer.parseInt(request.getParameter("userid"));
        int inv_item_id = Integer.parseInt(request.getParameter("invItemId"));
        int quantityReturned = Integer.parseInt(request.getParameter("quantity"));

        System.out.println("Item ID: " + itemId);
        System.out.println("Desired Quantity: " + quantityReturned);
        System.out.println("User ID: " + userid);
        System.out.println("User ID: " + inv_item_id);
        
        
        Connection connection = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            // Establish the database connection
            connection = DBConnection.dbConn();

            // Get current stock quantity of the item from inventory
            String sqlGetStock = "SELECT quantity FROM inventory WHERE id = ?";
            stmt = connection.prepareStatement(sqlGetStock);
            stmt.setInt(1, itemId);
            rs = stmt.executeQuery();

            if (rs.next()) {
                int oldQuantity = rs.getInt("quantity");
                int newQuantity = oldQuantity + quantityReturned;  // Add returned quantity to the current stock

                // Start a transaction
                connection.setAutoCommit(false);

                // 1. Update the inventory table with the new quantity
                String sqlUpdateInventory = "UPDATE inventory SET quantity = ? WHERE id = ?";
                stmt = connection.prepareStatement(sqlUpdateInventory);
                stmt.setInt(1, newQuantity);
                stmt.setInt(2, itemId);
                stmt.executeUpdate();

                // 2. Insert a record into the inventoryhistory table
                String sqlInsertHistory = "INSERT INTO inventoryhistory (item_id, change_type, old_quantity, new_quantity, changed_by) VALUES (?, 'ADDED', ?, ?, ?)";
                stmt = connection.prepareStatement(sqlInsertHistory);
                stmt.setInt(1, itemId);
                stmt.setInt(2, oldQuantity);
                stmt.setInt(3, newQuantity);
                stmt.setInt(4, userid);  // Get the user ID of who made the change
                stmt.executeUpdate();

                // 3. Update the status of the issued item to "Returned"
                String sqlUpdateIssuedItem = "UPDATE issued_items SET status = 'Returned' WHERE id = ?";
                stmt = connection.prepareStatement(sqlUpdateIssuedItem);
                stmt.setInt(1, inv_item_id);
                stmt.executeUpdate();

                // Commit the transaction
                connection.commit();

                response.sendRedirect("USER/issued_items.jsp?success=Item returned successfully");
            } else {
                response.sendRedirect("USER/issued_items.jsp?error=Item not found in inventory");
            }
        } catch (SQLException | ClassNotFoundException e) {
            try {
                // Rollback if there's any error
                if (connection != null) {
                    connection.rollback();
                }
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
            response.getWriter().write("Error: " + e.getMessage());
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                }
                if (stmt != null) {
                    stmt.close();
                }
                if (connection != null) {
                    connection.setAutoCommit(true);  // Reset auto-commit to true
                    connection.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
