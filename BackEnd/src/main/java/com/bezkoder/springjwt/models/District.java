package com.bezkoder.springjwt.models;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.Getter;
import lombok.Setter;

import javax.persistence.*;
import java.util.List;
@Entity
@Table(name = "district")
//@Setter
//@Getter
public class District {
    @Id
    @Column(name = "id")
//    @GeneratedValue(strategy= GenerationType.IDENTITY)
    private Long id;

    @Column(name = "name", columnDefinition = "nvarchar(100)",length = 100)
    private String name;

    @Column(name = "prefix", columnDefinition = "nvarchar(20)", length = 20)
    private String prefix;

    @ManyToOne
    @JoinColumn(name = "province_id", referencedColumnName = "id")
    @JsonIgnoreProperties("districts")
    private Province province;

    @OneToMany
    @JoinColumn(name = "district_id", referencedColumnName = "id")
    @JsonIgnoreProperties({"province", "district"})
    private List<Ward> wards;

    @Column(name = "retired")
    private Boolean retired;

    public District(Long id, String name, String prefix, Province province, List<Ward> wards, Boolean retired) {
        this.id = id;
        this.name = name;
        this.prefix = prefix;
        this.province = province;
        this.wards = wards;
        this.retired = retired;
    }

    public District() {

    }
}
