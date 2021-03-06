package com.bezkoder.springjwt.repository;

import com.bezkoder.springjwt.models.HotelBooking;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface BookingRepository extends JpaRepository<HotelBooking, Long> {
    //check user booking
    Boolean existsByUserId(Long userId);
    //get list booking by user id
    List<HotelBooking> findByUserId(Long userId);
    //get list booking by room id
    List<HotelBooking> findByRoomId(Long roomId);
    //get list booking retired
    List<HotelBooking> findByRetired(Boolean retired);
    //get list status booking
    List<HotelBooking> findByStatus(Boolean status);

}

