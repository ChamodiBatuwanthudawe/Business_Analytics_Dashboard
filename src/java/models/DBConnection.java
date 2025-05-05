package models;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;
import java.io.InputStream;
import java.io.IOException;

public class DBConnection {
    // Static method to get a database connection
    public static Connection dbConn() throws ClassNotFoundException, SQLException, IOException { 
        // Load the MySQL JDBC driver
        Class.forName("com.mysql.jdbc.Driver");
        
        // Load properties file
        Properties properties = new Properties();
        
        // Using try-with-resources to automatically close the InputStream
        try (InputStream input = DBConnection.class.getClassLoader().getResourceAsStream("dbconfig.properties")) {
            if (input == null) {
                System.out.println("Sorry, unable to find dbconfig.properties");
                return null;
            }

            // Load properties from the file
            properties.load(input);
        }
        
        // Get the database connection details from the properties file
        String url = properties.getProperty("db.url");
        String username = properties.getProperty("db.username");
        String password = properties.getProperty("db.password");

        // Establish the connection
        Connection connection = DriverManager.getConnection(url, username, password);
        
        return connection;
    }
}
