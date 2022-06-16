package com.bezkoder.springjwt.models;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.Getter;
import lombok.Setter;

import javax.persistence.*;
import java.util.List;

@Entity
@Table(name = "province")
//@Getter
//@Setter
public class Province {
    @Id
    @Column(name = "id")
    private Long id;
    @Column(name = "name", length = 50, columnDefinition = "nvarchar(50)")
    private String name;

    @Column(name = "code", length = 20, columnDefinition = "nvarchar(20)")
    private String code;

    @OneToMany
    @JoinColumn(name = "province_id", referencedColumnName = "id")
    @JsonIgnoreProperties("province")
    private List<District> districts;

    @Column(name = "retired")
    private Boolean retired;

    public Province(Long id, String name, String code, List<District> districts, Boolean retired) {
        this.id = id;
        this.name = name;
        this.code = code;
        this.districts = districts;
        this.retired = retired;
    }

    public Province() {
        
    }
}
