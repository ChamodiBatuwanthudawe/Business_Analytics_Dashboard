package controllers;

import models.UserDAO;
import models.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/UserController")
public class UserController extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        UserDAO userDAO = new UserDAO();
        String action = request.getParameter("action");

        try {
            if ("edit".equals(action)) {
                // Fetch user details for editing
                int id = Integer.parseInt(request.getParameter("id"));
                User user = userDAO.getUserById(id);
                request.setAttribute("user", user);
                request.getRequestDispatcher("USER/editUser.jsp").forward(request, response);
            } else if ("add".equals(action)) {
                // Navigate to add user page
                request.getRequestDispatcher("USER/addUser.jsp").forward(request, response);
            } else {
                // Default: Display all users
                List<User> users = userDAO.getAllUsers();
                request.setAttribute("users", users);
                request.getRequestDispatcher("USER/manageUsers.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        UserDAO userDAO = new UserDAO();
        String action = request.getParameter("action");

        try {
            if ("add".equals(action)) {
                // Add new user
                User user = new User();
                user.setUsername(request.getParameter("username"));
                user.setPassword(request.getParameter("password"));
                user.setRole(request.getParameter("role"));
                user.setEmail(request.getParameter("email"));
                user.setFullName(request.getParameter("full_name"));
                user.setImgPath(request.getParameter("img_path"));
                user.setDepartmentId(Integer.parseInt(request.getParameter("department")));
                user.setStatus(request.getParameter("status"));
                userDAO.addUser(user);
            } else if ("update".equals(action)) {
                // Update user details
                User user = new User();
                user.setId(Integer.parseInt(request.getParameter("id")));
                user.setUsername(request.getParameter("username"));
                user.setPassword(request.getParameter("password"));
                user.setRole(request.getParameter("role"));
                user.setEmail(request.getParameter("email"));
                user.setFullName(request.getParameter("full_name"));
                user.setImgPath(request.getParameter("img_path"));
                user.setDepartmentId(Integer.parseInt(request.getParameter("department_id")));
                user.setStatus(request.getParameter("status"));
                userDAO.updateUser(user);
            } else if ("delete".equals(action)) {
                // Delete user
                int id = Integer.parseInt(request.getParameter("id"));
                userDAO.deleteUser(id);
            }
            response.sendRedirect("UserController");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
