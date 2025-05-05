package models;

import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class inventoryTblDAO {

    // SQL queries
    private static final String INSERT_INVENTORY = "INSERT INTO inventory (item_name, description, quantity, status) VALUES (?, ?, ?, ?)";
    private static final String SELECT_INVENTORY_BY_ID = "SELECT id, item_name, description, quantity, status FROM inventory WHERE id = ?";
    private static final String SELECT_ALL_INVENTORY = "SELECT * FROM inventory";
    private static final String DELETE_INVENTORY = "DELETE FROM inventory WHERE id = ?";
    private static final String UPDATE_INVENTORY = "UPDATE inventory SET item_name = ?, description = ?, quantity = ?, status = ? WHERE id = ?";

    // Method to add a new inventory item
    public boolean addInventory(inventoryTbl inventory) throws SQLException, ClassNotFoundException, IOException {
        try (Connection connection = DBConnection.dbConn();
             PreparedStatement preparedStatement = connection.prepareStatement(INSERT_INVENTORY)) {
            preparedStatement.setString(1, inventory.getItemName());
            preparedStatement.setString(2, inventory.getDescription());
            preparedStatement.setInt(3, inventory.getQuantity());
            preparedStatement.setString(4, inventory.getStatus());
            return preparedStatement.executeUpdate() > 0;
        }
    }

    // Method to fetch inventory by ID
    public inventoryTbl getInventoryById(int id) throws SQLException, ClassNotFoundException, IOException {
        inventoryTbl inventory = null;
        try (Connection connection = DBConnection.dbConn();
             PreparedStatement preparedStatement = connection.prepareStatement(SELECT_INVENTORY_BY_ID)) {
            preparedStatement.setInt(1, id);
            ResultSet rs = preparedStatement.executeQuery();
            if (rs.next()) {
                String itemName = rs.getString("item_name");
                String description = rs.getString("description");
                int quantity = rs.getInt("quantity");
                String status = rs.getString("status");
                inventory = new inventoryTbl(id, itemName, description, quantity, status);
            }
        }
        return inventory;
    }

    // Method to fetch all inventory items
    public List<inventoryTbl> getAllInventory() throws SQLException, ClassNotFoundException, IOException {
        List<inventoryTbl> inventoryList = new ArrayList<>();
        try (Connection connection = DBConnection.dbConn();
             PreparedStatement preparedStatement = connection.prepareStatement(SELECT_ALL_INVENTORY)) {
            ResultSet rs = preparedStatement.executeQuery();
            while (rs.next()) {
                int id = rs.getInt("id");
                String itemName = rs.getString("item_name");
                String description = rs.getString("description");
                int quantity = rs.getInt("quantity");
                String status = rs.getString("status");
                inventoryList.add(new inventoryTbl(id, itemName, description, quantity, status));
            }
        }
        return inventoryList;
    }

    // Method to delete an inventory item by ID
    public boolean deleteInventory(int id) throws SQLException, ClassNotFoundException, IOException {
        try (Connection connection = DBConnection.dbConn();
             PreparedStatement preparedStatement = connection.prepareStatement(DELETE_INVENTORY)) {
            preparedStatement.setInt(1, id);
            return preparedStatement.executeUpdate() > 0;
        }
    }

    // Method to update an inventory item
    public boolean updateInventory(inventoryTbl inventory) throws SQLException, ClassNotFoundException, IOException {
        try (Connection connection = DBConnection.dbConn();
             PreparedStatement preparedStatement = connection.prepareStatement(UPDATE_INVENTORY)) {
            preparedStatement.setString(1, inventory.getItemName());
            preparedStatement.setString(2, inventory.getDescription());
            preparedStatement.setInt(3, inventory.getQuantity());
            preparedStatement.setString(4, inventory.getStatus());
            preparedStatement.setInt(5, inventory.getId());
            return preparedStatement.executeUpdate() > 0;
        }
    }
}
