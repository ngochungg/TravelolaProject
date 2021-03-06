package com.bezkoder.springjwt.repository;

import com.bezkoder.springjwt.models.Hotel;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface HotelRepository extends JpaRepository<Hotel, Long>, JpaSpecificationExecutor {
    Boolean existsByEmail(String email);
    Hotel getByAccountId(Long id);
    Boolean existsByAccount_Id(Long id);
    Hotel getByEmail(String email);
    //findByLocation_Province_Id
    List<Hotel> findByLocation_Province_Id(Long id);
}

