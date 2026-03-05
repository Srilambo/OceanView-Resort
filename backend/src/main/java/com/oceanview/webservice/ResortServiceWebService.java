package com.oceanview.webservice;

import com.oceanview.service.ResortServiceService;
import com.oceanview.model.ResortService;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import java.util.List;

public class ResortServiceWebService {
    private ResortServiceService serviceService;
    private Gson gson;

    public ResortServiceWebService() {
        this.serviceService = new ResortServiceService();
        this.gson = new GsonBuilder().create();
    }

    public String getAllServices() {
        try {
            List<ResortService> services = serviceService.getAllServices();
            return buildJsonResponse(200, gson.toJson(services));
        } catch (Exception e) {
            return buildJsonResponse(500, "{\"error\": \"" + e.getMessage().replace("\"", "\\\"") + "\"}");
        }
    }

    public String getServicesByCategory(String category) {
        try {
            List<ResortService> services = serviceService.getServicesByCategory(category);
            return buildJsonResponse(200, gson.toJson(services));
        } catch (Exception e) {
            return buildJsonResponse(500, "{\"error\": \"" + e.getMessage().replace("\"", "\\\"") + "\"}");
        }
    }

    public String getServiceById(String id) {
        try {
            ResortService service = serviceService.getServiceById(id);
            return buildJsonResponse(200, gson.toJson(service));
        } catch (Exception e) {
            return buildJsonResponse(404, "{\"error\": \"" + e.getMessage().replace("\"", "\\\"") + "\"}");
        }
    }

    private String buildJsonResponse(int statusCode, String body) {
        String statusText = (statusCode == 200) ? "OK"
                : (statusCode == 404 ? "Not Found" : "Internal Server Error");
        return "HTTP/1.1 " + statusCode + " " + statusText + "\r\n" +
                "Content-Type: application/json\r\n" +
                "Access-Control-Allow-Origin: *\r\n" +
                "Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS\r\n" +
                "Access-Control-Allow-Headers: Content-Type\r\n" +
                "Content-Length: " + body.length() + "\r\n" +
                "\r\n" + body;
    }
}
