package com.bezkoder.springjwt.models;
import javax.persistence.*;
import java.util.List;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
@Entity
@Table(name = "hotel_booking_detail")
public class HotelBookingDetail {
    @Id
    @Column
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    @OneToOne
    @JoinColumn(name = "hotel_booking_id",referencedColumnName = "id")
    @JsonIgnoreProperties("hotelBookingDetail")
    private HotelBooking hotelBooking;

    @OneToMany
    @JoinColumn(name = "hotel_booking_detail_id", referencedColumnName = "id")
    @JsonIgnoreProperties("hotelBookingDetail")
    private List<HotelBookingRoom> hotelBookingRooms;

}
