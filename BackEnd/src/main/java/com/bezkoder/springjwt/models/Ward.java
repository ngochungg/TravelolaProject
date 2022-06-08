package com.bezkoder.springjwt.models;

import lombok.Getter;
import lombok.Setter;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import org.hibernate.annotations.Type;

import javax.persistence.*;

@Entity
@Table(name = "ward")
@Setter
@Getter
public class Ward {
    @Id
    @Column(name = "id")
    private Long id;

    @Column(name = "name", length = 50, columnDefinition = "nvarchar(50)")
    private String name;

    @Column(name = "prefix", length = 20, columnDefinition = "nvarchar(20)")
    private String prefix;

    @ManyToOne
    @JoinColumn(name = "province_id", referencedColumnName = "id")
    @JsonIgnoreProperties("districts")
    private Province province;

    @ManyToOne
    @JoinColumn(name = "district_id", referencedColumnName = "id")
    @JsonIgnoreProperties({"wards", "province"})
    private District district;

    @Column(name = "retired")
    private Boolean retired;

    public Ward(Long id, String name, String prefix, Province province, District district, Boolean retired) {
        this.id = id;
        this.name = name;
        this.prefix = prefix;
        this.province = province;
        this.district = district;
        this.retired = retired;
    }

    public Ward() {

    }
}
