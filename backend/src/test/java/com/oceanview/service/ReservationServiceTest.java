package com.oceanview.service;

import com.oceanview.model.*;
import com.oceanview.repository.GuestRepository;
import com.oceanview.repository.RoomRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import java.math.BigDecimal;
import java.time.LocalDateTime;

import static org.junit.jupiter.api.Assertions.*;

public class ReservationServiceTest {
    private ReservationService service;
    private Guest testGuest;
    private Room testRoom;

    @BeforeEach
    public void setUp() throws Exception {
        String randomId = java.util.UUID.randomUUID().toString().substring(0, 8);
        testGuest = new Guest("G-" + randomId, "user-" + randomId, "John Doe", "john" + randomId + "@test.com",
                "1234567890", "123 Street",
                "Passport", "ABC123", "USA");
        testRoom = new Room("R-" + randomId, "RM-" + randomId, "Double", 2, BigDecimal.valueOf(150), "Ocean view",
                null, true, "AVAILABLE");

        GuestRepository guestRepo = new GuestRepository();
        guestRepo.save(testGuest);

        RoomRepository roomRepo = new RoomRepository();
        roomRepo.save(testRoom);

        service = new ReservationService();
    }

    @Test
    public void testCreateReservationSuccess() throws Exception {
        Reservation res = new Reservation();
        res.setGuest(testGuest);
        res.setRoom(testRoom);
        res.setCheckInDate(LocalDateTime.now().plusDays(1).withHour(14).withMinute(0));
        res.setCheckOutDate(LocalDateTime.now().plusDays(3).withHour(11).withMinute(0));

        Reservation result = service.createReservation(res);
        assertNotNull(result);
        assertEquals(2, result.getNumberOfNights());
    }

    @Test
    public void testCreateReservationWithPastDate() {
        Reservation res = new Reservation();
        res.setGuest(testGuest);
        res.setRoom(testRoom);
        res.setCheckInDate(LocalDateTime.now().minusDays(1));
        res.setCheckOutDate(LocalDateTime.now().plusDays(1));

        assertThrows(Exception.class, () -> {
            service.createReservation(res);
        });
    }

    @Test
    public void testCreateReservationWithInvalidDateRange() {
        Reservation res = new Reservation();
        res.setGuest(testGuest);
        res.setRoom(testRoom);
        res.setCheckInDate(LocalDateTime.now().plusDays(5));
        res.setCheckOutDate(LocalDateTime.now().plusDays(2));

        assertThrows(Exception.class, () -> {
            service.createReservation(res);
        });
    }
}
