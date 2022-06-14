package com.bezkoder.springjwt.models;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.Getter;
import lombok.Setter;

import javax.persistence.*;
import java.util.Date;
import java.util.List;

@Entity
@Getter
@Setter
@Table(name = "room")
public class Room {
    @Id
    @Column
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "room_number")
    private int roomNumber;

    @Column(name = "room_name", length = 150)
    private String roomName;


    @Column(name = "available_time",nullable = true)
    private Date availableTime;

    @Column(name = "room_type")
    private String roomType;

    @Column(name = "price")
    private double price;

    @Column(name = "max_adult")
    private int maxAdult;

    @Column(name = "max_children")
    private int maxChildren;

    @Column(name = "room_status")
    private Boolean roomStatus;



    @ManyToOne
    @JoinColumn(name = "hotel_id", referencedColumnName = "id")
    @JsonIgnoreProperties("rooms")
    private Hotel hotel;

    @OneToOne
    @JoinColumn(name = "booking_room_id", referencedColumnName = "id")
    @JsonIgnoreProperties("room")
    private HotelBookingRoom hotelBookingRoom;

    @OneToMany
    @JoinColumn(name = "room_id", referencedColumnName = "id")
    @JsonIgnoreProperties("room")
    private List<Image> images;

    public Room() {
    }

    public Room(Long id, int roomNumber, String roomName, Date availableTime, String roomType, double price, int maxAdult, int maxChildren, Boolean roomStatus, Hotel hotel, HotelBookingRoom hotelBookingRoom, List<Image> images) {
        this.id = id;
        this.roomNumber = roomNumber;
        this.roomName = roomName;
        this.availableTime = availableTime;
        this.roomType = roomType;
        this.price = price;
        this.maxAdult = maxAdult;
        this.maxChildren = maxChildren;
        this.roomStatus = roomStatus;
        this.hotel = hotel;
        this.hotelBookingRoom = hotelBookingRoom;
        this.images = images;
    }
}
