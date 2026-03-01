package com.oceanview.util;

import com.oceanview.model.Guest;
import com.oceanview.model.Room;
import com.oceanview.model.Reservation;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.reflect.TypeToken;
import java.io.*;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class FileHandler {
    private static final Gson gson = new GsonBuilder()
            .registerTypeAdapter(LocalDate.class, new LocalDateAdapter())
            .registerTypeAdapter(LocalDateTime.class, new LocalDateTimeAdapter())
            .setPrettyPrinting()
            .create();

    public static List<Guest> loadGuests(String filename) {
        try {
            File file = new File(filename);
            if (!file.exists()) {
                return new ArrayList<>();
            }
            String content = readFile(filename);
            return gson.fromJson(content, new TypeToken<List<Guest>>(){}.getType());
        } catch (Exception e) {
            System.err.println("Error loading guests: " + e.getMessage());
            return new ArrayList<>();
        }
    }

    public static void saveGuests(String filename, List<Guest> guests) {
        try {
            createFileIfNotExists(filename);
            String json = gson.toJson(guests);
            writeFile(filename, json);
        } catch (IOException e) {
            System.err.println("Error saving guests: " + e.getMessage());
        }
    }

    public static List<Room> loadRooms(String filename) {
        try {
            File file = new File(filename);
            if (!file.exists()) {
                return new ArrayList<>();
            }
            String content = readFile(filename);
            return gson.fromJson(content, new TypeToken<List<Room>>(){}.getType());
        } catch (Exception e) {
            System.err.println("Error loading rooms: " + e.getMessage());
            return new ArrayList<>();
        }
    }

    public static void saveRooms(String filename, List<Room> rooms) {
        try {
            createFileIfNotExists(filename);
            String json = gson.toJson(rooms);
            writeFile(filename, json);
        } catch (IOException e) {
            System.err.println("Error saving rooms: " + e.getMessage());
        }
    }

    public static List<Reservation> loadReservations(String filename) {
        try {
            File file = new File(filename);
            if (!file.exists()) {
                return new ArrayList<>();
            }
            String content = readFile(filename);
            return gson.fromJson(content, new TypeToken<List<Reservation>>(){}.getType());
        } catch (Exception e) {
            System.err.println("Error loading reservations: " + e.getMessage());
            return new ArrayList<>();
        }
    }

    public static void saveReservations(String filename, List<Reservation> reservations) {
        try {
            createFileIfNotExists(filename);
            String json = gson.toJson(reservations);
            writeFile(filename, json);
        } catch (IOException e) {
            System.err.println("Error saving reservations: " + e.getMessage());
        }
    }

    private static String readFile(String filename) throws IOException {
        StringBuilder content = new StringBuilder();
        try (BufferedReader reader = new BufferedReader(new FileReader(filename))) {
            String line;
            while ((line = reader.readLine()) != null) {
                content.append(line);
            }
        }
        return content.toString();
    }

    private static void writeFile(String filename, String content) throws IOException {
        try (FileWriter writer = new FileWriter(filename)) {
            writer.write(content);
        }
    }

    private static void createFileIfNotExists(String filename) throws IOException {
        File file = new File(filename);
        File parentDir = file.getParentFile();
        if (parentDir != null && !parentDir.exists()) {
            parentDir.mkdirs();
        }
        if (!file.exists()) {
            file.createNewFile();
        }
    }
}
