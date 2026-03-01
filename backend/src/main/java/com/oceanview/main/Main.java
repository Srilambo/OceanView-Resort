package com.oceanview.main;

import com.oceanview.webservice.HttpServer;

public class Main {
    public static void main(String[] args) {
        // Start HTTP Server
        HttpServer server = new HttpServer(8080);
        server.start();
    }
}
