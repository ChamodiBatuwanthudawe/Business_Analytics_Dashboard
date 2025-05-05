/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package models;


import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

public class ExcelGenerator {

    public static void generateExcel(List<IssuedItem> issuedItems, HttpServletResponse response) throws IOException {
        try ( // Create a new workbook and sheet
                Workbook workbook = new XSSFWorkbook()) {
            Sheet sheet = workbook.createSheet("Issued Items");
            
            // Create header row
            Row headerRow = sheet.createRow(0);
            headerRow.createCell(0).setCellValue("Item Status");
            headerRow.createCell(1).setCellValue("Quantity");
            headerRow.createCell(2).setCellValue("Issued At");
            headerRow.createCell(3).setCellValue("Item Name");
            headerRow.createCell(4).setCellValue("Issued By");
            
            // Add data rows
            int rowNum = 1;
            for (IssuedItem item : issuedItems) {
                Row row = sheet.createRow(rowNum++);
                row.createCell(0).setCellValue(item.getStatus());
                row.createCell(1).setCellValue(item.getQuantity());
                row.createCell(2).setCellValue(item.getCreatedAt().toString());
                row.createCell(3).setCellValue(item.getItemName());
                row.createCell(4).setCellValue(item.getFullName());
            }
            
            // Set the response content type and headers for Excel
            response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
            response.setHeader("Content-Disposition", "attachment; filename=issued_items.xlsx");
            
            // Write the workbook to the response output stream
            workbook.write(response.getOutputStream());
        }
    }
}
