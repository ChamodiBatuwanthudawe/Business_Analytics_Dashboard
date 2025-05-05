package controllers;

import models.inventoryTblDAO;
import models.inventoryTbl;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/InventoryController")
public class inventoryTblController extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        inventoryTblDAO inventoryDAO = new inventoryTblDAO();
        String action = request.getParameter("action");

        try {
            if ("edit".equals(action)) {
                // Fetch inventory item details for editing
                int id = Integer.parseInt(request.getParameter("id"));
                inventoryTbl inventory = inventoryDAO.getInventoryById(id);
                request.setAttribute("inventory", inventory);
                request.getRequestDispatcher("USER/editInventory.jsp").forward(request, response);
            } else if ("add".equals(action)) {
                // Navigate to add inventory page
                request.getRequestDispatcher("USER/addInventory.jsp").forward(request, response);
            } else {
                // Default: Display all inventory items
                List<inventoryTbl> inventoryList = inventoryDAO.getAllInventory();
                request.setAttribute("inventoryList", inventoryList);
                request.getRequestDispatcher("USER/manageInventory.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        inventoryTblDAO inventoryDAO = new inventoryTblDAO();
        String action = request.getParameter("action");

        try {
            if ("add".equals(action)) {
                // Add new inventory item
                inventoryTbl inventory = new inventoryTbl();
                inventory.setItemName(request.getParameter("item_name"));
                inventory.setDescription(request.getParameter("description"));
                inventory.setQuantity(Integer.parseInt(request.getParameter("quantity")));
                inventory.setStatus(request.getParameter("status"));
                inventoryDAO.addInventory(inventory);
            } else if ("update".equals(action)) {
                // Update inventory item details
                inventoryTbl inventory = new inventoryTbl();
                inventory.setId(Integer.parseInt(request.getParameter("id")));
                inventory.setItemName(request.getParameter("item_name"));
                inventory.setDescription(request.getParameter("description"));
                inventory.setQuantity(Integer.parseInt(request.getParameter("quantity")));
                inventory.setStatus(request.getParameter("status"));
                inventoryDAO.updateInventory(inventory);
            } else if ("delete".equals(action)) {
                // Delete inventory item
                int id = Integer.parseInt(request.getParameter("id"));
                inventoryDAO.deleteInventory(id);
            }
            response.sendRedirect("InventoryController");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
