package com.bezkoder.springjwt.repository;

import com.bezkoder.springjwt.models.HotelBooking;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface BookingRepository extends JpaRepository<HotelBooking, Long> {
    //check user booking
    Boolean existsByUserId(Long userId);

}

