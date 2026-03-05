package com.oceanview.main;

import com.oceanview.webservice.HttpServer;
import com.oceanview.db.DatabaseHelper;

public class Main {
    public static void main(String[] args) {
        System.out.println("🏨 Starting Ocean View Resort Backend...");

        // Test Database Connection
        DatabaseHelper.testConnection();
        DatabaseHelper.runSqlScript("resources/update_db.sql");

        System.out.println("🔧 Verifying DB Tables...");
        try (java.sql.Connection conn = DatabaseHelper.getConnection();
                java.sql.Statement stmt = conn.createStatement()) {

            String ddl = "CREATE TABLE IF NOT EXISTS reservation_services (" +
                    "id VARCHAR(50) PRIMARY KEY, " +
                    "reservation_id VARCHAR(50) NOT NULL, " +
                    "service_id VARCHAR(50) NOT NULL, " +
                    "service_name VARCHAR(100) NOT NULL, " +
                    "service_price DECIMAL(10,2) NOT NULL, " +
                    "quantity INT DEFAULT 1, " +
                    "added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, " +
                    "FOREIGN KEY (reservation_id) REFERENCES reservations(reservation_id) ON DELETE CASCADE, " +
                    "FOREIGN KEY (service_id) REFERENCES resort_services(service_id))";
            stmt.execute(ddl);
            System.out.println("✅ reservation_services table ready!");
        } catch (Exception e) {
            e.printStackTrace();
        }

        // Start HTTP Server
        HttpServer server = new HttpServer(8080);
        server.start();
    }
}
