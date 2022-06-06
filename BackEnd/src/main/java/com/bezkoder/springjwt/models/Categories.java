package com.bezkoder.springjwt.models;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import javax.persistence.*;
import javax.validation.constraints.NotBlank;
import javax.validation.constraints.Size;

@Entity
@Getter
@Setter
@Table(name = "categories")
public class Categories {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;
    private Integer parentId;
    @NotBlank
    @Size(max = 100)
    private String name;
    private String description;
    private Boolean is_active;

    public Categories( Integer parentId, String name, String description, Boolean is_active) {
        this.parentId = parentId;
        this.name = name;
        this.description = description;
        this.is_active = is_active;
    }

    public Categories() {
    }
}
