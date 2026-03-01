package com.oceanview.main;

import com.oceanview.webservice.HttpServer;
import com.oceanview.db.DatabaseHelper;

public class Main {
    public static void main(String[] args) {
        System.out.println("🏨 Starting Ocean View Resort Backend...");

        // Test Database Connection
        DatabaseHelper.testConnection();

        // Start HTTP Server
        HttpServer server = new HttpServer(8080);
        server.start();
    }
}
