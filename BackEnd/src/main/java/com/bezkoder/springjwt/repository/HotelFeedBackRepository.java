package com.bezkoder.springjwt.repository;


import com.bezkoder.springjwt.models.HotelFeedBack;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface HotelFeedBackRepository extends JpaRepository<HotelFeedBack, Long> {
    //list hotelFeedback by hotel
    List<HotelFeedBack> findByHotelId(Long hotelId);
}
