package controllers;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import models.DBConnection;

@WebServlet("/GetItemServlet")
public class GetItemServlet extends HttpServlet {

    // Process the POST request to handle item request submission
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Retrieve parameters from the request
        String itemId = request.getParameter("itemId");
        String itemQuantity = request.getParameter("desiredQuantity");
        String userId = request.getParameter("userId");

        // Print the parameters (for debugging purposes)
        System.out.println("Item ID: " + itemId);
        System.out.println("Desired Quantity: " + itemQuantity);
        System.out.println("User ID: " + userId);

        // Check if all required parameters are provided
        if (itemId == null ||  itemQuantity == null || userId == null) {
            response.sendRedirect("home.jsp?error=missing_data");
            return;
        }

        // Establish a database connection
        Connection conn = null;
        PreparedStatement pstmt = null;
        PreparedStatement pstmtHistory = null;
        PreparedStatement pstmtIssuedItem = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.dbConn(); // Get the DB connection

            // Fetch the current quantity of the item before updating
            String getQuantitySQL = "SELECT quantity FROM inventory WHERE id = ?";
            pstmt = conn.prepareStatement(getQuantitySQL);
            pstmt.setInt(1, Integer.parseInt(itemId)); // Set the item ID
            rs = pstmt.executeQuery();

            int currentQuantity = 0;
            if (rs.next()) {
                currentQuantity = rs.getInt("quantity");
            }

            // SQL query to update the inventory quantity
            String updateSQL = "UPDATE inventory SET quantity = quantity - ? WHERE id = ?";
            pstmt = conn.prepareStatement(updateSQL);
            pstmt.setInt(1, Integer.parseInt(itemQuantity)); // Subtract the quantity
            pstmt.setInt(2, Integer.parseInt(itemId)); // Set the item ID
            int rowsAffected = pstmt.executeUpdate();

            if (rowsAffected > 0) {
                // Insert record into InventoryHistory manually
                String insertHistorySQL = "INSERT INTO InventoryHistory (item_id, change_type, old_quantity, new_quantity, changed_by) "
                                         + "VALUES (?, 'REMOVED', ?, ?, ?)";
                pstmtHistory = conn.prepareStatement(insertHistorySQL);
                pstmtHistory.setInt(1, Integer.parseInt(itemId)); // item_id
                pstmtHistory.setInt(2, currentQuantity); // old_quantity
                pstmtHistory.setInt(3, currentQuantity - Integer.parseInt(itemQuantity)); // new_quantity
                pstmtHistory.setInt(4, Integer.parseInt(userId)); // changed_by (user_id)

                int historyRowsAffected = pstmtHistory.executeUpdate();

                if (historyRowsAffected > 0) {
                    // Insert record into issued_items table
                    String insertIssuedItemSQL = "INSERT INTO issued_items (item_id, user_id, quantity, status) "
                                               + "VALUES (?, ?, ?, 'Brought')";
                    pstmtIssuedItem = conn.prepareStatement(insertIssuedItemSQL);
                    pstmtIssuedItem.setInt(1, Integer.parseInt(itemId)); // item_id
                    pstmtIssuedItem.setInt(2, Integer.parseInt(userId)); // user_id
                    pstmtIssuedItem.setInt(3, Integer.parseInt(itemQuantity)); // quantity

                    int issuedItemRowsAffected = pstmtIssuedItem.executeUpdate();

                    if (issuedItemRowsAffected > 0) {
                        // If everything is successful, redirect to the home page with a success message
                        response.sendRedirect("USER/items.jsp?success=Item requested successfully");
                    } else {
                        // If inserting into issued_items fails, redirect with an error message
                        response.sendRedirect("USER/items.jsp?error=failed_to_log_issued_item");
                    }
                    
                } else {
                    // If inserting history fails, redirect with an error message
                    response.sendRedirect("USER/items.jsp?error=failed_to_log_inventory_history");
                }
            } else {
                // If updating the inventory fails, redirect with an error message
                response.sendRedirect("USER/items.jsp?error=failed_to_update_inventory");
            }

        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            // If there is an exception, redirect to the home page with an error message
            response.sendRedirect("USER/items.jsp?error=database_error");
        } finally {
            // Clean up resources
            if (rs != null) {
                try {
                    rs.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
            if (pstmt != null) {
                try {
                    pstmt.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
            if (pstmtHistory != null) {
                try {
                    pstmtHistory.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
            if (pstmtIssuedItem != null) {
                try {
                    pstmtIssuedItem.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }
}
