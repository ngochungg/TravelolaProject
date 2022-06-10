package com.bezkoder.springjwt.models;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

import javax.persistence.*;
import java.util.Date;
import java.util.List;

@Entity
@Table(name = "room")
public class Room {
    @Id
    @Column
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "room_number")
    private int roomNumber;

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

    @Column(name = "retired", nullable = true)
    private Boolean retired;

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



}
