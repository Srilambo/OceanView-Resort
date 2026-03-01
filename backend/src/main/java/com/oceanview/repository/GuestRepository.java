package com.oceanview.repository;

import com.oceanview.model.Guest;
import com.oceanview.util.FileHandler;
import java.util.*;

public class GuestRepository {
    private static final String GUESTS_FILE = "resources/data/guests.dat";
    private List<Guest> guests;

    public GuestRepository() {
        this.guests = FileHandler.loadGuests(GUESTS_FILE);
    }

    public Guest save(Guest guest) {
        if (guest.getGuestId() == null) {
            guest.setGuestId(UUID.randomUUID().toString());
        }
        guests.add(guest);
        FileHandler.saveGuests(GUESTS_FILE, guests);
        return guest;
    }

    public Guest findById(String guestId) {
        return guests.stream()
            .filter(g -> g.getGuestId().equals(guestId))
            .findFirst()
            .orElse(null);
    }

    public Guest findByEmail(String email) {
        return guests.stream()
            .filter(g -> g.getEmail().equals(email))
            .findFirst()
            .orElse(null);
    }

    public List<Guest> findAll() {
        return new ArrayList<>(guests);
    }

    public Guest update(Guest guest) {
        Guest existing = findById(guest.getGuestId());
        if (existing != null) {
            guests.remove(existing);
            guests.add(guest);
            FileHandler.saveGuests(GUESTS_FILE, guests);
        }
        return guest;
    }

    public boolean delete(String guestId) {
        boolean removed = guests.removeIf(g -> g.getGuestId().equals(guestId));
        if (removed) {
            FileHandler.saveGuests(GUESTS_FILE, guests);
        }
        return removed;
    }
}
