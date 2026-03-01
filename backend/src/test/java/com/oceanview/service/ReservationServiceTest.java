package com.oceanview.service;

import com.oceanview.model.*;
import com.oceanview.repository.GuestRepository;
import com.oceanview.repository.RoomRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import java.math.BigDecimal;
import java.time.LocalDate;

import static org.junit.jupiter.api.Assertions.*;

public class ReservationServiceTest {
    private ReservationService service;
    private Guest testGuest;
    private Room testRoom;

    @BeforeEach
    public void setUp() throws Exception {
        String randomId = java.util.UUID.randomUUID().toString().substring(0, 8);
        testGuest = new Guest("G-" + randomId, "John Doe", "john" + randomId + "@test.com", "1234567890", "123 Street",
                "ABC123");
        testRoom = new Room("R-" + randomId, "RM-" + randomId, "Double", 2, BigDecimal.valueOf(150), "Ocean view",
                true);

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
        res.setCheckInDate(LocalDate.now().plusDays(1));
        res.setCheckOutDate(LocalDate.now().plusDays(3));

        Reservation result = service.createReservation(res);
        assertNotNull(result);
        assertEquals(2, result.getNumberOfNights());
    }

    @Test
    public void testCreateReservationWithPastDate() {
        Reservation res = new Reservation();
        res.setGuest(testGuest);
        res.setRoom(testRoom);
        res.setCheckInDate(LocalDate.now().minusDays(1));
        res.setCheckOutDate(LocalDate.now().plusDays(1));

        assertThrows(Exception.class, () -> {
            service.createReservation(res);
        });
    }

    @Test
    public void testCreateReservationWithInvalidDateRange() {
        Reservation res = new Reservation();
        res.setGuest(testGuest);
        res.setRoom(testRoom);
        res.setCheckInDate(LocalDate.now().plusDays(5));
        res.setCheckOutDate(LocalDate.now().plusDays(2));

        assertThrows(Exception.class, () -> {
            service.createReservation(res);
        });
    }
}
