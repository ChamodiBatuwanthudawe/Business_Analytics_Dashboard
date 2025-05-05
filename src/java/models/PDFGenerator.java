package models;

import com.itextpdf.text.*;
import com.itextpdf.text.pdf.*;
import com.itextpdf.text.pdf.draw.LineSeparator;

import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class PDFGenerator {

    public static void generatePDF(List<IssuedItem> issuedItems, HttpServletResponse response) throws DocumentException, IOException {
        // Create a Document object with A4 page size
        Document document = new Document(PageSize.A4);
        PdfWriter.getInstance(document, response.getOutputStream());
        document.open();

        // Add date to the top right corner
        String currentDate = new SimpleDateFormat("yyyy-MM-dd").format(new Date());
        Paragraph date = new Paragraph("Date: " + currentDate, FontFactory.getFont(FontFactory.HELVETICA, 10));
        date.setAlignment(Element.ALIGN_RIGHT);
        document.add(date);

        // Add space
        document.add(Chunk.NEWLINE);

        // Add report title
        Paragraph title = new Paragraph("Issued Items Report", FontFactory.getFont(FontFactory.HELVETICA_BOLD, 18));
        title.setAlignment(Element.ALIGN_CENTER);
        document.add(title);

        // Add horizontal line
        LineSeparator lineSeparator = new LineSeparator();
        document.add(lineSeparator);

        // Add space before dynamic paragraph
        document.add(Chunk.NEWLINE);

        // Calculate the Most Used Item
        String mostUsedItem = getMostUsedItem(issuedItems);

        // Calculate the Most Active User
        String mostActiveUser = getMostActiveUser(issuedItems);

        // Calculate Returned and Brought counts
        int[] statusCounts = getItemStatusCounts(issuedItems);
        int returnedCount = statusCounts[0];
        int broughtCount = statusCounts[1];

        
        // Concatenate the results into a single paragraph
        String reportText = String.format(
                "A total of %d items have been returned back successfully without any issues. "
                + "There are %d items to be returned. "
                + "The most used item is %s. "
                + "The most active user is %s, who has issued the most items in the system.",
                returnedCount, broughtCount, mostUsedItem, mostActiveUser
        );

        // Create a paragraph with the combined text
        Paragraph reportParagraph = new Paragraph(reportText, FontFactory.getFont(FontFactory.HELVETICA, 12));
        reportParagraph.setAlignment(Element.ALIGN_LEFT);

        // Add the paragraph to the document
        document.add(reportParagraph);

        // Add space before results
        document.add(Chunk.NEWLINE);

        // Display Returned and Brought counts on separate lines
        Paragraph returnedCountParagraph = new Paragraph(
                "Returned Count: " + returnedCount,
                FontFactory.getFont(FontFactory.HELVETICA_BOLD, 12, BaseColor.DARK_GRAY)
        );
        returnedCountParagraph.setAlignment(Element.ALIGN_LEFT);
        document.add(returnedCountParagraph);

        Paragraph broughtCountParagraph = new Paragraph(
                "Brought Count: " + broughtCount,
                FontFactory.getFont(FontFactory.HELVETICA_BOLD, 12, BaseColor.DARK_GRAY)
        );
        broughtCountParagraph.setAlignment(Element.ALIGN_LEFT);
        document.add(broughtCountParagraph);

        // Add space before table
        document.add(Chunk.NEWLINE);

        // Create table with 5 columns
        PdfPTable table = new PdfPTable(5);
        table.setWidthPercentage(100);
        table.setSpacingBefore(10f);
        table.setWidths(new float[]{2, 2, 3, 3, 3}); // Set column widths

        // Table header style
        Font headerFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 12, BaseColor.WHITE);
        PdfPCell headerCell;

        // Add table headers with background color
        headerCell = new PdfPCell(new Phrase("Item Status", headerFont));
        headerCell.setBackgroundColor(BaseColor.DARK_GRAY);
        headerCell.setHorizontalAlignment(Element.ALIGN_CENTER);
        table.addCell(headerCell);

        headerCell = new PdfPCell(new Phrase("Quantity", headerFont));
        headerCell.setBackgroundColor(BaseColor.DARK_GRAY);
        headerCell.setHorizontalAlignment(Element.ALIGN_CENTER);
        table.addCell(headerCell);

        headerCell = new PdfPCell(new Phrase("Issued/Returned At", headerFont));
        headerCell.setBackgroundColor(BaseColor.DARK_GRAY);
        headerCell.setHorizontalAlignment(Element.ALIGN_CENTER);
        table.addCell(headerCell);

        headerCell = new PdfPCell(new Phrase("Item Name", headerFont));
        headerCell.setBackgroundColor(BaseColor.DARK_GRAY);
        headerCell.setHorizontalAlignment(Element.ALIGN_CENTER);
        table.addCell(headerCell);

        headerCell = new PdfPCell(new Phrase("Issued By", headerFont));
        headerCell.setBackgroundColor(BaseColor.DARK_GRAY);
        headerCell.setHorizontalAlignment(Element.ALIGN_CENTER);
        table.addCell(headerCell);

        // Add data rows with alternating row colors
        boolean isRowAlternate = false;
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd"); // Formatter for date

        for (IssuedItem item : issuedItems) {
            BaseColor rowColor = isRowAlternate ? new BaseColor(230, 240, 250) : BaseColor.WHITE; // Light blue for alternate rows
            isRowAlternate = !isRowAlternate;

            PdfPCell cell;

            cell = new PdfPCell(new Phrase(item.getStatus()));
            cell.setBackgroundColor(rowColor);
            table.addCell(cell);

            cell = new PdfPCell(new Phrase(String.valueOf(item.getQuantity())));
            cell.setBackgroundColor(rowColor);
            table.addCell(cell);

            // Format the Issued At column to show only the date
            String formattedDate = dateFormat.format(item.getCreatedAt());
            cell = new PdfPCell(new Phrase(formattedDate));
            cell.setBackgroundColor(rowColor);
            table.addCell(cell);

            cell = new PdfPCell(new Phrase(item.getItemName()));
            cell.setBackgroundColor(rowColor);
            table.addCell(cell);

            cell = new PdfPCell(new Phrase(item.getFullName()));
            cell.setBackgroundColor(rowColor);
            table.addCell(cell);
        }

        // Add the table to the document
        document.add(table);

        // Add space for signature at the bottom
        document.add(Chunk.NEWLINE);
        document.add(Chunk.NEWLINE);

        Paragraph signaturePlaceholder = new Paragraph("__________________________", FontFactory.getFont(FontFactory.HELVETICA_BOLD));
        signaturePlaceholder.setAlignment(Element.ALIGN_LEFT);
        document.add(signaturePlaceholder);

        Paragraph signatureText = new Paragraph("Authorized Signature", FontFactory.getFont(FontFactory.HELVETICA, 10));
        signatureText.setAlignment(Element.ALIGN_LEFT);
        document.add(signatureText);

        // Close the document
        document.close();
    }

    private static String getMostUsedItem(List<IssuedItem> issuedItems) {
        Map<String, Integer> itemCountMap = new HashMap<>();

        for (IssuedItem item : issuedItems) {
            String itemName = item.getItemName();
            itemCountMap.put(itemName, itemCountMap.getOrDefault(itemName, 0) + 1);
        }

        // Find the item with the maximum frequency
        return Collections.max(itemCountMap.entrySet(), Map.Entry.comparingByValue()).getKey();
    }

    private static String getMostActiveUser(List<IssuedItem> issuedItems) {
        Map<String, Integer> userCountMap = new HashMap<>();

        for (IssuedItem item : issuedItems) {
            String issuedBy = item.getFullName();
            userCountMap.put(issuedBy, userCountMap.getOrDefault(issuedBy, 0) + 1);
        }

        return Collections.max(userCountMap.entrySet(), Map.Entry.comparingByValue()).getKey();
    }

    private static int[] getItemStatusCounts(List<IssuedItem> issuedItems) {
        int returnedCount = 0;
        int broughtCount = 0;

        for (IssuedItem item : issuedItems) {
            String status = item.getStatus();
            if ("Returned".equalsIgnoreCase(status)) {
                returnedCount++;
            } else if ("Brought".equalsIgnoreCase(status)) {
                broughtCount++;
            }
        }
        return new int[]{returnedCount, broughtCount};
    }
}
