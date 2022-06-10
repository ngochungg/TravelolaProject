package com.bezkoder.springjwt.models;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.Getter;
import lombok.Setter;
import org.springframework.data.annotation.CreatedDate;


import javax.persistence.*;
import java.time.Instant;
import java.util.List;

@Entity
@Table(name = "hotel")
@Getter
@Setter
public class Hotel {
    @Id
    @Column
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    @Column(name = "hotel_name", length = 150)
    private String hotelName;
    @Column(name = "email")
    private String email;
    @Column(name = "phone")
    private String phone;
    @Column(name = "hotel_rating",nullable = true)
    private Float hotelRating;
    @Column(name = "contact_name", length = 150)
    private String contactName;
    //description type  is text
@Column(name = "description", columnDefinition = "text")
    private String description;
    //Service hotel
    @Column(name = "payment_at_the_hotel")
    private Boolean paymentAtTheHotel;
    @Column(name = "number_of_room",nullable = false)
    private int  numberOfRoom;
    @Column(name = "wifi")
    private boolean  wifi;
    @Column(name = "restaurant")
    private boolean  restaurant;
    @Column(name = "freeParking")
    private boolean  freeParking;
    @Column(name = "pets_allowed")
    private boolean  petsAllowed;
    @Column(name = "hot_tub")
    private boolean  hotTub;
    @Column(name = "swimming_pool")
    private boolean  swimmingPool;
    @Column(name = "gym")
    private boolean  gym;
    @Column(name = "created_at")

    @CreatedDate
    private Instant createdAt;
    @Column(name = "retired", nullable = true)
    private Boolean retired;

    @ManyToOne
    @JoinColumn(name = "location_id", referencedColumnName = "id")
    private Location location;

    @OneToOne
    @JoinColumn(name = "account_id", referencedColumnName = "id")
    private User account;

    @OneToMany
    @JoinColumn(name = "hotel_id",referencedColumnName = "id")
    @JsonIgnoreProperties(value = "hotel", allowSetters=true)
    private List<HotelFeedBack> hotelFeedBacks;

    @OneToMany
    @JoinColumn(name = "hotel_id", referencedColumnName = "id")
    @JsonIgnoreProperties("hotel")
    private List<Room> rooms;

    @OneToMany
    @JoinColumn(name = "hotel_id", referencedColumnName = "id")
    @JsonIgnoreProperties("hotel")
    private List<Image> images;

    public Hotel(Long id, String hotelName, String email, String phone, Float hotelRating, String contactName, String description, Boolean paymentAtTheHotel, int numberOfRoom, boolean wifi, boolean restaurant, boolean freeParking, boolean petsAllowed, boolean hotTub, boolean swimmingPool, boolean gym, Instant createdAt, Boolean retired, Location location, User account, List<HotelFeedBack> hotelFeedBacks, List<Room> rooms, List<Image> images) {
        this.id = id;
        this.hotelName = hotelName;
        this.email = email;
        this.phone = phone;
        this.hotelRating = hotelRating;
        this.contactName = contactName;
        this.description = description;
        this.paymentAtTheHotel = paymentAtTheHotel;
        this.numberOfRoom = numberOfRoom;
        this.wifi = wifi;
        this.restaurant = restaurant;
        this.freeParking = freeParking;
        this.petsAllowed = petsAllowed;
        this.hotTub = hotTub;
        this.swimmingPool = swimmingPool;
        this.gym = gym;
        this.createdAt = createdAt;
        this.retired = retired;
        this.location = location;
        this.account = account;
        this.hotelFeedBacks = hotelFeedBacks;
        this.rooms = rooms;
        this.images = images;
    }

    public Hotel() {
    }
}
