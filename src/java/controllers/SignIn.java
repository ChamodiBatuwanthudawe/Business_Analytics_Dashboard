package controllers;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.CallableStatement;
import java.sql.ResultSet;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import models.DBConnection;

@WebServlet("/SignIn")
public class SignIn extends HttpServlet {

    private static final long serialVersionUID = 1L;

    // Default constructor
    public SignIn() {
        super();
    }

    // Handle POST requests (form submission)
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Set content type for response
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        // Retrieve form parameters
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String username = request.getParameter("username");
        String repeatPassword = request.getParameter("repeatPassword");
        String departmentId = request.getParameter("department");

        // Log the values to check if any parameter is null
        System.out.println("fullName: " + fullName);
        System.out.println("email: " + email);
        System.out.println("password: " + password);
        System.out.println("username: " + username);
        System.out.println("repeatPassword: " + repeatPassword);
        System.out.println("departmentId: " + departmentId);

        // Validate password match
        if (password == null || !password.equals(repeatPassword)) {
            showErrorAlert(response, "Passwords do not match");
            return;
        }

        // Establish database connection
        Connection connection = null;
        CallableStatement stmt = null;

        try {
            connection = DBConnection.dbConn(); // Get DB connection
            connection.setAutoCommit(false);  // Disable auto-commit for transaction handling

            // Check if the username already exists
            String checkSql = "SELECT COUNT(*) FROM users WHERE username = ?";
            PreparedStatement checkStmt = connection.prepareStatement(checkSql);
            checkStmt.setString(1, username);
            ResultSet rs = checkStmt.executeQuery();
            if (rs.next() && rs.getInt(1) > 0) {
                showErrorAlert(response, "Username already exists");
                return;
            }

            // Proceed with the stored procedure call
            String sql = "{CALL AddUser(?, ?, ?, ?, ?, ?, ?)}";
            stmt = connection.prepareCall(sql);
            stmt.setString(1, username);   // username
            stmt.setString(2, password);   // password
            stmt.setString(3, "User");     // role (set to "User")
            stmt.setString(4, email);      // email
            stmt.setString(5, fullName);   // full name
            stmt.setInt(6, Integer.parseInt(departmentId));  // department id
            stmt.setString(7, "ACTIVE");   // status (set to "ACTIVE")

            stmt.executeUpdate();
            connection.commit();  // Commit the transaction

            // Success message: Redirect to login page with SweetAlert
            response.setContentType("text/html");
            out.println("<html><body>");
            out.println("<script src='https://cdn.jsdelivr.net/npm/sweetalert2@11'></script>");
            out.println("<script>");
            out.println("Swal.fire({");
            out.println("title: 'Good job!',");
            out.println("text: 'User registered successfully!',");
            out.println("icon: 'success',");
            out.println("}).then(function() {");
            out.println("window.location.href = 'USER/items.jsp';");  // Redirect to the registration page
            out.println("});");
            out.println("</script>");
            out.println("</body></html>");

        } catch (SQLException e) {
            if (connection != null) {
                try {
                    connection.rollback();  // Rollback if any exception occurs
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            showErrorAlert(response, "Error: " + e.getMessage());
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(SignIn.class.getName()).log(Level.SEVERE, null, ex);
            showErrorAlert(response, "Error: " + ex.getMessage());
        } finally {
            try {
                if (stmt != null) {
                    stmt.close();
                }
                if (connection != null) {
                    connection.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    // Method to show error message using SweetAlert
    private void showErrorAlert(HttpServletResponse response, String errorMessage) throws IOException {
        PrintWriter out = response.getWriter();
        out.println("<html><body>");
        out.println("<script src='https://cdn.jsdelivr.net/npm/sweetalert2@11'></script>");
        out.println("<script>");
        out.println("Swal.fire({");
        out.println("icon: 'error',");
        out.println("title: 'Oops...',");
        out.println("text: '" + errorMessage + "',");
        out.println("}).then(function() {");
        out.println("window.location.href = 'USER/signIn.jsp';");  // Redirect to the registration page
        out.println("});");
        out.println("</script>");
        out.println("</body></html>");
    }
}
