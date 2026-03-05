package com.oceanview.db;

public class UpdateDb {
    public static void main(String[] args) {
        System.out.println("Updating Database Schema...");
        DatabaseHelper.runSqlScript("resources/schema.sql");
        System.out.println("Done.");
    }
}
