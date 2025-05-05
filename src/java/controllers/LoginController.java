// Modified LoginController.java
package controllers;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import models.DBConnection;

@WebServlet("/Login")
public class LoginController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    public LoginController() {
        super();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        Connection connection = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            connection = DBConnection.dbConn(); // Get DB connection

            // Query to check if the user exists and fetch required fields
            String sql = "SELECT id, full_name, role, img_path, status FROM users WHERE username = ? AND password = ?";
            stmt = connection.prepareStatement(sql);
            stmt.setString(1, username);
            stmt.setString(2, password);
            rs = stmt.executeQuery();

            if (rs.next()) {
                int id = rs.getInt("id");
                String fullName = rs.getString("full_name");
                String role = rs.getString("role");
                String status = rs.getString("status");
                

                if ("ACTIVE".equals(status)) {
                    HttpSession session = request.getSession();
                    session.setAttribute("id", id);           // Store user ID in session
                    session.setAttribute("full_name", fullName); // Store full name in session
                    session.setAttribute("username", username); // Store username in session
                    session.setAttribute("role", role);

                    if ("Admin".equals(role)) {
                        response.sendRedirect("USER/dashboard.jsp");
                    } else if ("User".equals(role)) {
                        response.sendRedirect("USER/items.jsp");
                    }
                } else {
                    showAlert(response, "User access is restricted. Contact admin for more information.");
                }
            } else {
                showAlert(response, "Invalid username or password.");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            showAlert(response, "Error: " + e.getMessage());
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(LoginController.class.getName()).log(Level.SEVERE, null, ex);
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

    private void showAlert(HttpServletResponse response, String message) throws IOException {
        PrintWriter out = response.getWriter();
        out.println("<html><body>");
        out.println("<script src='https://cdn.jsdelivr.net/npm/sweetalert2@11'></script>");
        out.println("<script>");
        out.println("Swal.fire({");
        out.println("icon: 'error',");
        out.println("title: 'Oops...',");
        out.println("text: '" + message + "',");
        out.println("}).then(function() {");
        out.println("window.location.href = 'login.jsp';");
        out.println("});");
        out.println("</script>");
        out.println("</body></html>");
    }
}
