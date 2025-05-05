package models;

import java.sql.Timestamp;
import java.util.Objects;

public class IssuedItem {
    private String status;
    private int quantity;
    private Timestamp createdAt;
    private String itemName;
    private String fullName;

    // Default Constructor
    public IssuedItem() {}

    // Constructor to initialize all fields
    public IssuedItem(String status, int quantity, Timestamp createdAt, String itemName, String fullName) {
        this.status = status;
        this.quantity = quantity;
        this.createdAt = createdAt;
        this.itemName = itemName;
        this.fullName = fullName;
    }

    // Getters and Setters
    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public String getItemName() {
        return itemName;
    }

    public void setItemName(String itemName) {
        this.itemName = itemName;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    // Override toString() for better logging/debugging
    @Override
    public String toString() {
        return "IssuedItem{" +
                "status='" + status + '\'' +
                ", quantity=" + quantity +
                ", createdAt=" + createdAt +
                ", itemName='" + itemName + '\'' +
                ", fullName='" + fullName + '\'' +
                '}';
    }

    // Override equals() and hashCode() for comparison and hashing in collections
    @Override
    public boolean equals(Object obj) {
        if (this == obj) return true;
        if (obj == null || getClass() != obj.getClass()) return false;
        IssuedItem that = (IssuedItem) obj;
        return quantity == that.quantity &&
                status.equals(that.status) &&
                createdAt.equals(that.createdAt) &&
                itemName.equals(that.itemName) &&
                fullName.equals(that.fullName);
    }

    @Override
    public int hashCode() {
        return Objects.hash(status, quantity, createdAt, itemName, fullName);
    }
}
