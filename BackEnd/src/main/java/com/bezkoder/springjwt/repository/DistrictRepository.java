package com.bezkoder.springjwt.repository;

import com.bezkoder.springjwt.models.District;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface DistrictRepository extends JpaRepository<District, Long> {
    //get list of districts by province id
    List<District> findByProvinceId(Long provinceId);

}
