package com.bezkoder.springjwt.models;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import java.time.Instant;
import java.util.Date;
import java.util.List;
import java.util.Set;
import javax.persistence.*;

@Entity
@EntityListeners(AuditingEntityListener.class)
@Table(name = "hotel_booking")
@Setter
@Getter
public class HotelBooking {
    @Id
    @Column
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    @Column(name = "booking_code")
    private String bookingCode;
    @Column(name = "num_of_guest")
    private int numOfGuest;
    @Column(name = "Qr_code")
    private String qrCode;
    @Column(name = "status")
    private boolean status;
    @Column(name = "check_in_date")
    @JsonFormat(pattern="yyyy-MM-dd")
    private Date checkInDate;
    @Column(name = "check_out_date")
    @JsonFormat(pattern="yyyy-MM-dd")
    private Date checkOutDate;
    @Column(name = "total_price")
    private Float totalPrice;
    @Column(name="created_at")
//    @JsonFormat(pattern="yyyy-MM-dd")
//    @CreatedDate
    @CreationTimestamp
    private Instant createdAt;
//    @LastModifiedDate
    @UpdateTimestamp
    @Column(name = "update_at")
//    @JsonFormat(pattern="yyyy-MM-dd")
    private Instant updateAt;
    @Column(name = "payment_method", columnDefinition = "nvarchar(100)")
    private String paymentMethod;


    @Column(name = "retired")
    private boolean retired;

    @ManyToOne
    @JoinColumn(name = "room_id")
    private Room room;


    @OneToOne
    @JoinColumn(name = "user_id",referencedColumnName = "id")
    @JsonIgnoreProperties("hotelBooking")
    private User user;

    public HotelBooking() {
    }

    public HotelBooking(Long id, String bookingCode, int numOfGuest, boolean status, Date checkInDate, Date checkOutDate, Float totalPrice, Instant createdAt, Instant updateAt, String paymentMethod, boolean retired, Room room, User user) {
        this.id = id;
        this.bookingCode = bookingCode;
        this.numOfGuest = numOfGuest;
        this.status = status;
        this.checkInDate = checkInDate;
        this.checkOutDate = checkOutDate;
        this.totalPrice = totalPrice;
        this.createdAt = createdAt;
        this.updateAt = updateAt;
        this.paymentMethod = paymentMethod;
        this.retired = retired;
        this.room = room;
        this.user = user;
    }
}
