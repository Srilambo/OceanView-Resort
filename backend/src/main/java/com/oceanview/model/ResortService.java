package com.oceanview.model;

import java.io.Serializable;
import java.math.BigDecimal;

public class ResortService implements Serializable {
    private static final long serialVersionUID = 1L;

    private String serviceId;
    private String serviceName;
    private String category;
    private String description;
    private BigDecimal price;
    private String duration;
    private boolean available;
    private String icon;

    public ResortService() {
    }

    public ResortService(String serviceId, String serviceName, String category,
            String description, BigDecimal price, String duration, boolean available, String icon) {
        this.serviceId = serviceId;
        this.serviceName = serviceName;
        this.category = category;
        this.description = description;
        this.price = price;
        this.duration = duration;
        this.available = available;
        this.icon = icon;
    }

    public String getServiceId() {
        return serviceId;
    }

    public void setServiceId(String serviceId) {
        this.serviceId = serviceId;
    }

    public String getServiceName() {
        return serviceName;
    }

    public void setServiceName(String serviceName) {
        this.serviceName = serviceName;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public String getDuration() {
        return duration;
    }

    public void setDuration(String duration) {
        this.duration = duration;
    }

    public boolean isAvailable() {
        return available;
    }

    public void setAvailable(boolean available) {
        this.available = available;
    }

    public String getIcon() {
        return icon;
    }

    public void setIcon(String icon) {
        this.icon = icon;
    }
}
