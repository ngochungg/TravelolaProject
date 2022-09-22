package com.bezkoder.springjwt.repository;

import com.bezkoder.springjwt.models.Ward;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface WardRepository extends JpaRepository<Ward, Long> {
    //get list of wards by district id
    List<Ward> findByDistrictId(Long districtId);
}
