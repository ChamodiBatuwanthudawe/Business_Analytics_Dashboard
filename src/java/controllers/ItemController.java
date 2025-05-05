package controllers;

import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession; // Import for session
import models.DBConnection;

@WebServlet("/Items")
public class ItemController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Constructor
    public ItemController() {
        super();
    }

    // Handle GET requests to fetch all items from the inventory
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Set content type for response
        response.setContentType("text/html");

        // Prepare to fetch items from the database
        List<Map<String, Object>> items = new ArrayList<>();
        Connection connection = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            connection = DBConnection.dbConn();  // Get DB connection

            String sql = "SELECT * FROM inventory WHERE status = 'IN STOCK'";
            stmt = connection.prepareStatement(sql);
            rs = stmt.executeQuery();

            // Loop through the result set and create a map for each item
            while (rs.next()) {
                Map<String, Object> item = new HashMap<>();
                item.put("id", rs.getInt("id"));
                item.put("quantity", rs.getInt("quantity"));
                item.put("item_name", rs.getString("item_name"));
                item.put("description", rs.getString("description"));
                
                item.put("img_path", rs.getString("img_path"));

                // Add the map (item) to the list
                items.add(item);
            }

            // Store the items list in the session
            HttpSession session = request.getSession(); // Get the session object
            session.setAttribute("items", items); // Store items in session

            // Redirect to the items.jsp page (to avoid resubmitting form on refresh)
            response.sendRedirect("USER/items.jsp");
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
    }
}
