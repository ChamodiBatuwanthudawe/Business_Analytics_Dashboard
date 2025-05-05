package models;

import com.itextpdf.text.*;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfWriter;

import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.Map;

public class stockPDFGenerator {

    public static void generatePDF(List<Map<String, Object>> inventoryItems, HttpServletResponse response) throws DocumentException, IOException {
        // Create a Document object
        Document document = new Document();
        // Set the response type for PDF
        PdfWriter.getInstance(document, response.getOutputStream());
        document.open();

        // Add the header for the table
        Paragraph title = new Paragraph("Inventory Items", FontFactory.getFont(FontFactory.HELVETICA_BOLD, 16));
        title.setAlignment(Element.ALIGN_CENTER);
        document.add(title);

        // Add some space before the table
        document.add(new Phrase("\n"));

        // Create table with 5 columns
        PdfPTable table = new PdfPTable(5);
        table.addCell("Item Name");
        table.addCell("Description");
        table.addCell("Quantity");
        
        table.addCell("Status");

        // Add data rows
        for (Map<String, Object> item : inventoryItems) {
            table.addCell(String.valueOf(item.get("item_name")));
            table.addCell(String.valueOf(item.get("description")));
            table.addCell(String.valueOf(item.get("quantity")));
            
            table.addCell(String.valueOf(item.get("status")));
        }

        // Add the table to the document
        document.add(table);
        // Close the document
        document.close();
    }
}
