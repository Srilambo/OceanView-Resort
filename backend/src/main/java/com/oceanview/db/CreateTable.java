package com.oceanview.db;

import java.sql.Connection;
import java.sql.Statement;

public class CreateTable {
    public static void main(String[] args) {
        try (Connection conn = DatabaseHelper.getConnection();
                Statement stmt = conn.createStatement()) {

            System.out.println("Executing DDL...");
            String ddl = "CREATE TABLE IF NOT EXISTS reservation_services (" +
                    "id VARCHAR(50) PRIMARY KEY, " +
                    "reservation_id VARCHAR(50) NOT NULL, " +
                    "service_id VARCHAR(50) NOT NULL, " +
                    "service_name VARCHAR(100) NOT NULL, " +
                    "service_price DECIMAL(10,2) NOT NULL, " +
                    "quantity INT DEFAULT 1, " +
                    "added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)";
            stmt.execute(ddl);
            System.out.println("DDL Executed without foreign keys!");

            // Try adding foreign keys
            System.out.println("Adding FK to reservations...");
            stmt.execute(
                    "ALTER TABLE reservation_services ADD CONSTRAINT fk_res FOREIGN KEY (reservation_id) REFERENCES reservations(reservation_id) ON DELETE CASCADE");
            System.out.println("Added FK to reservations!");

            System.out.println("Adding FK to resort_services...");
            stmt.execute(
                    "ALTER TABLE reservation_services ADD CONSTRAINT fk_svc FOREIGN KEY (service_id) REFERENCES resort_services(service_id)");
            System.out.println("Added FK to resort_services!");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
