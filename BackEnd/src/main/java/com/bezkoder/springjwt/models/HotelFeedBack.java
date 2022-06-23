package com.bezkoder.springjwt.models;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.Getter;
import lombok.Setter;

import javax.persistence.*;

@Entity
@Table(name = "hotel_feedback")
@Getter
@Setter
public class HotelFeedBack {
    @Id
    @Column
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "rating")
    private double rating;

    @Column(name = "feedback" , columnDefinition = "text")
    private String feedback;

    @Column(name = "retired", nullable = true)
    private Boolean retired;

    @ManyToOne
    @JoinColumn(name = "user_id", referencedColumnName = "id")
    @JsonIgnoreProperties("hotelFeedBacks")
    private User user;

    @ManyToOne
    @JoinColumn(name = "hotel_id", referencedColumnName = "id")
    @JsonIgnoreProperties("hotelFeedBacks")
    private Hotel hotel;

    public HotelFeedBack(Long id, double rating, String feedback, Boolean retired, User user, Hotel hotel) {
        this.id = id;
        this.rating = rating;
        this.feedback = feedback;
        this.retired = retired;
        this.user = user;
        this.hotel = hotel;
    }

    public HotelFeedBack() {
    }
}
