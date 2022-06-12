package com.bezkoder.springjwt.repository;

import com.bezkoder.springjwt.models.District;
import com.bezkoder.springjwt.models.Image;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ImageRepository extends JpaRepository<Image, Long> {
}
