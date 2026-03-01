package com.oceanview.webservice;

import com.oceanview.service.UserService;
import com.oceanview.model.User;
import com.google.gson.Gson;
import java.util.Map;

public class UserWebService {
    private UserService userService;
    private Gson gson;

    public UserWebService() {
        this.userService = new UserService();
        this.gson = new Gson();
    }

    public String login(String jsonBody) {
        try {
            Map<String, String> credentials = gson.fromJson(jsonBody, Map.class);
            String username = credentials.get("username");
            String password = credentials.get("password");

            User user = userService.authenticate(username, password);

            Map<String, Object> response = Map.of(
                    "userId", user.getUserId(),
                    "username", user.getUsername(),
                    "email", user.getEmail(),
                    "roles", user.getRoles(),
                    "authenticated", true);

            return "HTTP/1.1 200 OK\r\n" +
                    "Content-Type: application/json\r\n" +
                    "Access-Control-Allow-Origin: *\r\n" +
                    "\r\n" + gson.toJson(response);
        } catch (Exception e) {
            return "HTTP/1.1 401 Unauthorized\r\n" +
                    "Content-Type: application/json\r\n" +
                    "\r\n{\"error\": \"" + e.getMessage().replace("\"", "\\\"") + "\"}";
        }
    }
}
