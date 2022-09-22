package com.bezkoder.springjwt.payload.request;

import lombok.Getter;
import lombok.Setter;

import java.util.Date;
@Getter
@Setter
public class HotelBookingRequest {
//    private String bookingCode;
    private Date checkInDate;
    private Date checkOutDate;
    private int numOfGuest;
    private String paymentMethod;
//    private Boolean retired;
//    private Boolean status;
    private float totalPrice;
    private Long roomId;
    private Long userId;

}
