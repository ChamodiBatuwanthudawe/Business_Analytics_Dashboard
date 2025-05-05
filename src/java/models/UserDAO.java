package models;

import java.io.IOException;
import models.User;
import models.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {

    public List<User> getAllUsers() throws SQLException, ClassNotFoundException, IOException {
        List<User> users = new ArrayList<>();
        Connection conn = DBConnection.dbConn();
        String query = "SELECT * FROM users WHERE id != 1";

        try (PreparedStatement pstmt = conn.prepareStatement(query);
             ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                User user = new User();
                user.setId(rs.getInt("id"));
                user.setUsername(rs.getString("username"));
                user.setPassword(rs.getString("password"));
                user.setRole(rs.getString("role"));
                user.setEmail(rs.getString("email"));
                user.setFullName(rs.getString("full_name"));
                user.setImgPath(rs.getString("img_path"));
                user.setDepartmentId(rs.getInt("department_id"));
                user.setStatus(rs.getString("status"));
                user.setCreatedAt(rs.getTimestamp("created_at"));
                user.setUpdatedAt(rs.getTimestamp("updated_at"));
                users.add(user);
            }
        }
        conn.close();
        return users;
    }

    public boolean addUser(User user) throws SQLException, ClassNotFoundException, IOException {
        Connection conn = DBConnection.dbConn();
        String query = "INSERT INTO users (username, password, role, email, full_name, img_path, department_id, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setString(1, user.getUsername());
            pstmt.setString(2, user.getPassword());
            pstmt.setString(3, user.getRole());
            pstmt.setString(4, user.getEmail());
            pstmt.setString(5, user.getFullName());
            pstmt.setString(6, user.getImgPath());
            pstmt.setInt(7, user.getDepartmentId());
            pstmt.setString(8, user.getStatus());
            return pstmt.executeUpdate() > 0;
        } finally {
            conn.close();
        }
    }

    public boolean updateUser(User user) throws SQLException, ClassNotFoundException, IOException {
        Connection conn = DBConnection.dbConn();
        String query = "UPDATE users SET username = ?, password = ?, role = ?, email = ?, full_name = ?, img_path = ?, department_id = ?, status = ? WHERE id = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setString(1, user.getUsername());
            pstmt.setString(2, user.getPassword());
            pstmt.setString(3, user.getRole());
            pstmt.setString(4, user.getEmail());
            pstmt.setString(5, user.getFullName());
            pstmt.setString(6, user.getImgPath());
            pstmt.setInt(7, user.getDepartmentId());
            pstmt.setString(8, user.getStatus());
            pstmt.setInt(9, user.getId());
            return pstmt.executeUpdate() > 0;
        } finally {
            conn.close();
        }
    }

    public boolean deleteUser(int id) throws SQLException, ClassNotFoundException, IOException {
        Connection conn = DBConnection.dbConn();
        String query = "DELETE FROM users WHERE id = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setInt(1, id);
            return pstmt.executeUpdate() > 0;
        } finally {
            conn.close();
        }
    }

    public User getUserById(int id) throws SQLException, ClassNotFoundException, IOException {
    Connection conn = DBConnection.dbConn();
    String query = "SELECT * FROM users WHERE id = ?";
    User user = null;

    try (PreparedStatement pstmt = conn.prepareStatement(query)) {
        pstmt.setInt(1, id);
        try (ResultSet rs = pstmt.executeQuery()) {
            if (rs.next()) {
                user = new User();
                user.setId(rs.getInt("id"));
                user.setUsername(rs.getString("username"));
                user.setPassword(rs.getString("password"));
                user.setRole(rs.getString("role"));
                user.setEmail(rs.getString("email"));
                user.setFullName(rs.getString("full_name"));
                user.setImgPath(rs.getString("img_path"));
                user.setDepartmentId(rs.getInt("department_id"));
                user.setStatus(rs.getString("status"));
                user.setCreatedAt(rs.getTimestamp("created_at"));
                user.setUpdatedAt(rs.getTimestamp("updated_at"));
            }
        }
    } finally {
        conn.close();
    }

    return user;
}

}
