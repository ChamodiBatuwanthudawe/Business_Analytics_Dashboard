package controllers;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/Logout")
public class LogoutController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    public LogoutController() {
        super();
    }

    // Handle GET requests for logout
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Invalidate the current session
        HttpSession session = request.getSession(false); // Get current session, don't create a new one
        if (session != null) {
            session.invalidate(); // Destroy the session
        }

        // Redirect the user to the login page
        response.sendRedirect("login.jsp");
    }

    // Handle POST requests (optional, for form-based logout)
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response); // Forward to the GET handler
    }
}
