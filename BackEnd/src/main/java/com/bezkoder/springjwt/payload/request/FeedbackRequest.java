package com.bezkoder.springjwt.payload.request;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class FeedbackRequest {
    private String feedback;
    //rating
    private int rating;
    //hotel_booking id
    private long hotel_booking_id;
}
