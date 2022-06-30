package com.bezkoder.springjwt.repository;

import com.bezkoder.springjwt.models.Province;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ProvinceRepository extends JpaRepository<Province, Long> {
//    //find 4 province have most hotels
//    List<Province> findTop4ByOrderByHotelCountDesc();
}
