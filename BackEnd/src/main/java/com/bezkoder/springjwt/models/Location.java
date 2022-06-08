package com.bezkoder.springjwt.models;
import javax.persistence.*;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.Type;

@Entity
@Table(name = "location")
@Setter
@Getter
public class Location {
    @Id
    @Column(name = "id")
    @GeneratedValue(strategy= GenerationType.IDENTITY)
    private Long id;

    @Column(name = "street", length = 500)
    @Type(type="org.hibernate.type.StringNVarcharType")
    private String street;

    @Column(name = "postal_code", length = 10)
    private String postalCode;

    @ManyToOne
    @JoinColumn(name = "province_id", referencedColumnName = "id")
    private Province province;


    @ManyToOne
    @JoinColumn(name = "district_id", referencedColumnName = "id")
    @JsonIgnoreProperties({"province"})
    private District district;


    @ManyToOne
    @JoinColumn(name = "ward_id", referencedColumnName = "id")
    @JsonIgnoreProperties({"district","province"})
    private Ward ward;

    @Column(name = "retired", nullable = true)
    private Boolean retired;
    public Location(Long id, String street, String postalCode, Province province, District district, Ward ward, Boolean retired) {
        this.id = id;
        this.street = street;
        this.postalCode = postalCode;
        this.province = province;
        this.district = district;
        this.ward = ward;
        this.retired = retired;
    }
    public Location(Location location) {
        this.id = location.getId();
        this.street = location.getStreet();
        this.postalCode = location.getPostalCode();
        this.province = location.getProvince();
        this.district = location.getDistrict();
        this.ward = location.getWard();
        this.retired = location.getRetired();
    }

    public Location() {
    }

}
