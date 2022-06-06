package com.bezkoder.springjwt.payload.request;

import lombok.Getter;
import lombok.Setter;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.Size;
@Getter
@Setter
public class CategoryRequest {
    private Integer parentId;
    @NotBlank
    @Size(max = 100)
    private String name;
    private String description;
    private Boolean is_active = true;
}
