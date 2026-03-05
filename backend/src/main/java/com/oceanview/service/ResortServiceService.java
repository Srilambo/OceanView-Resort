package com.oceanview.service;

import com.oceanview.model.ResortService;
import com.oceanview.repository.ResortServiceRepository;
import java.sql.SQLException;
import java.util.List;

public class ResortServiceService {
    private ResortServiceRepository repository;

    public ResortServiceService() {
        this.repository = new ResortServiceRepository();
    }

    public List<ResortService> getAllServices() throws Exception {
        try {
            return repository.findAll();
        } catch (SQLException e) {
            throw new Exception("Database error: " + e.getMessage());
        }
    }

    public List<ResortService> getServicesByCategory(String category) throws Exception {
        try {
            return repository.findByCategory(category);
        } catch (SQLException e) {
            throw new Exception("Database error: " + e.getMessage());
        }
    }

    public ResortService getServiceById(String id) throws Exception {
        try {
            ResortService service = repository.findById(id);
            if (service == null) {
                throw new Exception("Service not found");
            }
            return service;
        } catch (SQLException e) {
            throw new Exception("Database error: " + e.getMessage());
        }
    }
}
