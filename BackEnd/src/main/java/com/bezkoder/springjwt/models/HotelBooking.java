package com.bezkoder.springjwt.models;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import java.time.Instant;
import java.util.Date;
import javax.persistence.*;

@Entity
@EntityListeners(AuditingEntityListener.class)
@Table(name = "hotel_booking")
public class HotelBooking {
    @Id
    @Column
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    @Column(name = "booking_code")
    private String bookingCode;
    @Column(name = "num_of_guest")
    private int numOfGuest;
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
    @CreatedDate
    private Instant createdAt;
    @LastModifiedDate
    @Column(name = "update_at")
//    @JsonFormat(pattern="yyyy-MM-dd")
    private Instant updateAt;
    @Column(name = "payment_method", columnDefinition = "nvarchar(100)")
    private String paymentMethod;


    @Column(name = "retired")
    private boolean retired;

    @OneToOne
    @JoinColumn(name = "hotel_booking_Detail_id",referencedColumnName = "id")
    @JsonIgnoreProperties("hotelBooking")
    private HotelBookingDetail hotelBookingDetail;

    @OneToOne
    @JoinColumn(name = "user_id",referencedColumnName = "id")
    @JsonIgnoreProperties("hotelBooking")
    private User user;
}
