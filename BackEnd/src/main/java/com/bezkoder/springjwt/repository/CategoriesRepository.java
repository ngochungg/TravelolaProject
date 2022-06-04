package com.bezkoder.springjwt.repository;

import com.bezkoder.springjwt.models.Categories;
import org.springframework.data.jpa.repository.JpaRepository;

public interface CategoriesRepository extends JpaRepository<Categories, Long> {
    
}
