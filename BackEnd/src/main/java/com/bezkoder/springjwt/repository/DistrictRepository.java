package com.bezkoder.springjwt.repository;

import com.bezkoder.springjwt.models.District;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface DistrictRepository extends JpaRepository<District, Long> {

}
