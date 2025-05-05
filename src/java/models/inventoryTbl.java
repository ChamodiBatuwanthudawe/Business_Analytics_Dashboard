/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package models;



public class inventoryTbl {

    private int id;
    private String itemName;
    private String description;
    private int quantity;

    private String status;


    public inventoryTbl() {
    }

    public inventoryTbl(int id, String itemName, String description, int quantity, String status) {
        this.id = id;
        this.itemName = itemName;
        this.description = description;
        this.quantity = quantity;
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

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    
}
