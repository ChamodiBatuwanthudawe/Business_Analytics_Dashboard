package controllers;

import models.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.*;
import java.io.*;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import javax.servlet.annotation.WebServlet;

@WebServlet("/ProfileController")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10,      // 10MB
        maxRequestSize = 1024 * 1024 * 50   // 50MB
)
public class ProfileController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get session attributes
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("id") == null) {
            response.sendRedirect("../login.jsp");
            return;
        }

        int userId = (Integer) session.getAttribute("id");
        
        // Get form data
        String fullName = request.getParameter("fullName");
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        Part filePart = request.getPart("profilePicture");

        // Define variables
        String imgPath = null;
        String uploadPath = getServletContext().getRealPath("") + File.separator + "img";
        File uploadDir = new File(uploadPath);

        // Create directory if it doesn't exist
        if (!uploadDir.exists()) {
            boolean dirCreated = uploadDir.mkdirs(); // Create directory and subdirectories if necessary
            if (dirCreated) {
                System.out.println("Directory created: " + uploadPath);
            } else {
                System.out.println("Directory already exists or failed to create: " + uploadPath);
            }
        }

        // Process uploaded file
        if (filePart != null && filePart.getSize() > 0) {
            String fileName = userId + "_" + System.currentTimeMillis() + "_" + filePart.getSubmittedFileName();
            imgPath = "img/" + fileName; // Path to store in the database
            String fullSavePath = uploadPath + File.separator + fileName;

            try (InputStream fileContent = filePart.getInputStream();
                 FileOutputStream fos = new FileOutputStream(fullSavePath)) {
                byte[] buffer = new byte[1024];
                int bytesRead;
                while ((bytesRead = fileContent.read(buffer)) != -1) {
                    fos.write(buffer, 0, bytesRead);
                }
                System.out.println("File saved: " + fullSavePath); // Log the saved file path for debugging
            } catch (IOException e) {
                e.printStackTrace();
                session.setAttribute("message", "Error while uploading the image. Please try again.");
                response.sendRedirect("USER/profile.jsp");
                return;
            }
        }

        // Update database
        try (Connection connection = DBConnection.dbConn()) {
            StringBuilder query = new StringBuilder("UPDATE users SET full_name = ?, username = ?, email = ?");
            if (password != null && !password.trim().isEmpty()) {
                query.append(", password = ?");
            }
            if (imgPath != null) {
                query.append(", img_path = ?");
            }
            query.append(" WHERE id = ?");

            try (PreparedStatement stmt = connection.prepareStatement(query.toString())) {
                int index = 1;
                stmt.setString(index++, fullName);
                stmt.setString(index++, username);
                stmt.setString(index++, email);
                if (password != null && !password.trim().isEmpty()) {
                    stmt.setString(index++, password);
                }
                if (imgPath != null) {
                    stmt.setString(index++, imgPath);
                }
                stmt.setInt(index, userId);

                int rowsUpdated = stmt.executeUpdate();
                if (rowsUpdated > 0) {
                    session.setAttribute("message", "Profile updated Successfully.");
                } else {
                    session.setAttribute("message", "Failed to update profile. Please try again.");
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            session.setAttribute("message", "An error occurred. Please try again later.");
        }

        response.sendRedirect("USER/profile.jsp");
    }
}
