package com.bezkoder.springjwt.controllers;

import com.bezkoder.springjwt.models.Categories;
import com.bezkoder.springjwt.payload.request.CategoryRequest;
import com.bezkoder.springjwt.payload.response.MessageResponse;
import com.bezkoder.springjwt.repository.CategoriesRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;

@CrossOrigin(origins = "*", maxAge = 3600)
@RestController
@RequestMapping("/api/category")
public class CategoryController {
    @Autowired
    CategoriesRepository categoriesRepository;

    // Get all categories
    @RequestMapping("/all")
    public Iterable<Categories> getAllCategories() {
        return categoriesRepository.findAll();
    }
    // add category
    @PostMapping("/add")
    public ResponseEntity<?> addCategory(@Valid @RequestBody CategoryRequest categoryRequest) {
        if(categoriesRepository.existsByName(categoryRequest.getName())) {
            return ResponseEntity
                    .badRequest()
                    .body(new MessageResponse("Error: Name is already in use!"));
        }
        if(categoryRequest.getParentId() == null) {
            categoryRequest.setParentId(0);
        }
        Categories category = new Categories(
                categoryRequest.getParentId(),
                categoryRequest.getName(),
                categoryRequest.getDescription(),
                categoryRequest.getIs_active());
        categoriesRepository.save(category);
        return ResponseEntity.ok(new MessageResponse("Category added successfully!"));
    }
    //lock category
    @GetMapping("/lock/{id}")
    public ResponseEntity<?> lockCategory(@PathVariable int id) {
        Categories category = categoriesRepository.findById(id).orElseThrow(() -> new IllegalArgumentException("Invalid category Id:" + id));
        if(category.getParentId() == 0) {
            category.setIs_active(false);
            categoriesRepository.findAllByParentId(id).forEach(c -> c.setIs_active(false));
            categoriesRepository.save(category);
            return ResponseEntity.ok(new MessageResponse("Category locked successfully!"));
        }
        category.setIs_active(false);
        categoriesRepository.save(category);
        return ResponseEntity.ok(new MessageResponse("Category locked successfully!"));
    }
    //unlock category
    @GetMapping("/unlock/{id}")
    public ResponseEntity<?> unlockCategory(@PathVariable int id) {
        Categories category = categoriesRepository.findById(id).orElseThrow(() -> new IllegalArgumentException("Invalid category Id:" + id));
        if(category.getParentId() == 0) {
            category.setIs_active(true);
            categoriesRepository.findAllByParentId(id).forEach(c -> c.setIs_active(true));
            categoriesRepository.save(category);
            return ResponseEntity.ok(new MessageResponse("Category unlocked successfully!"));
        }
        category.setIs_active(true);
        categoriesRepository.save(category);
        return ResponseEntity.ok(new MessageResponse("Category unlocked successfully!"));
    }
    // update category
    @PutMapping("/update/{id}")
    public ResponseEntity<?> updateCategory(@PathVariable int id, @Valid @RequestBody CategoryRequest categoryRequest) {
        Categories category = categoriesRepository.findById(id).orElseThrow(() -> new IllegalArgumentException("Invalid category Id:" + id));
        category.setName(categoryRequest.getName());
        category.setDescription(categoryRequest.getDescription());
        categoriesRepository.save(category);
        return ResponseEntity.ok(new MessageResponse("Category updated successfully!"));
    }
    // delete category
    @DeleteMapping("/delete/{id}")
    public ResponseEntity<?> deleteCategory(@PathVariable int id) {
        Categories category = categoriesRepository.findById(id).orElseThrow(() -> new IllegalArgumentException("Invalid category Id:" + id));
        if(category.getParentId() == 0) {
            categoriesRepository.findAllByParentId(id).forEach(c -> categoriesRepository.delete(c));
        }
        categoriesRepository.delete(category);
        return ResponseEntity.ok(new MessageResponse("Category deleted successfully!"));
    }


}
