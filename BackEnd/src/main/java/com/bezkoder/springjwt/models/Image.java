package com.bezkoder.springjwt.models;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.Getter;
import lombok.Setter;

import javax.persistence.*;
@Entity
@Table(name = "image")
@Setter
@Getter
public class Image {
    @Id
    @Column(name = "id")
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "path", nullable = false)
    public String imagePath;

    @Column(name = "alt", nullable = false)
    public String imageAlt;

    @ManyToOne
    @JoinColumn(name = "hotel_id", referencedColumnName = "id")
    @JsonIgnoreProperties("images")
    public Hotel hotel;

    @ManyToOne
    @JoinColumn(name = "room_id", referencedColumnName = "id")
    @JsonIgnoreProperties("images")
    public Room room;

    public Image() {
    }

    public Image(Long id, String imagePath, String imageAlt, Hotel hotel, Room room) {
        this.id = id;
        this.imagePath = imagePath;
        this.imageAlt = imageAlt;
        this.hotel = hotel;
        this.room = room;
    }
}
