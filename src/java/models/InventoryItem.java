package models;

public class InventoryItem {
    private int id;
    private String itemName;
    private String description;
    private int quantity;
    private String imgPath;
    private String status;

    // Constructor
    public InventoryItem(int id, String itemName, String description, int quantity, String imgPath, String status) {
        this.id = id;
        this.itemName = itemName;
        this.description = description;
        this.quantity = quantity;
        this.imgPath = imgPath;
        this.status = status;
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getItemName() {
        return itemName;
    }

    public void setItemName(String itemName) {
        this.itemName = itemName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public String getImgPath() {
        return imgPath;
    }

    public void setImgPath(String imgPath) {
        this.imgPath = imgPath;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}
