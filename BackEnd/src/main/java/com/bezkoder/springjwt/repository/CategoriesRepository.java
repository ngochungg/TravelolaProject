package com.bezkoder.springjwt.repository;

import com.bezkoder.springjwt.models.Categories;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface CategoriesRepository extends JpaRepository<Categories, Integer> {
    Boolean existsByName(String name);
    //get all categories by parent_id
    Iterable<Categories> findAllByParentId(Integer parentId);

}
