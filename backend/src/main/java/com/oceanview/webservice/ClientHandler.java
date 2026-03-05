package com.oceanview.webservice;

import java.io.*;
import java.net.Socket;

public class ClientHandler extends Thread {
    private Socket socket;
    private HttpServer server;

    public ClientHandler(Socket socket, HttpServer server) {
        this.socket = socket;
        this.server = server;
    }

    @Override
    public void run() {
        try {
            BufferedReader in = new BufferedReader(
                    new InputStreamReader(socket.getInputStream(), java.nio.charset.StandardCharsets.UTF_8));
            PrintWriter out = new PrintWriter(new BufferedWriter(
                    new OutputStreamWriter(socket.getOutputStream(), java.nio.charset.StandardCharsets.UTF_8)));

            String requestLine = in.readLine();
            if (requestLine == null)
                return;

            String[] parts = requestLine.split(" ");
            String method = parts[0];
            String path = parts[1];

            String header;
            int contentLength = 0;
            while ((header = in.readLine()) != null && !header.isEmpty()) {
                if (header.startsWith("Content-Length:")) {
                    contentLength = Integer.parseInt(header.substring("Content-Length:".length()).trim());
                }
            }

            String body = "";
            if (contentLength > 0) {
                char[] buffer = new char[contentLength];
                in.read(buffer);
                body = new String(buffer);
            }

            String response = server.handleRequest(method, path, body);
            out.print(response);
            out.flush();

            socket.close();
        } catch (IOException e) {
            System.err.println("Client handler error: " + e.getMessage());
        }
    }
}
