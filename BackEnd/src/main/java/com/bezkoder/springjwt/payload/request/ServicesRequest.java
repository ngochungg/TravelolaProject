package com.bezkoder.springjwt.payload.request;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ServicesRequest {
    private Boolean paymentAtTheHotel;
    private Boolean  wifi;
    private Boolean  freeBreakfast;
    private Boolean  freeParking;
    private Boolean  petsAllowed;
    private Boolean  hotTub;
    private Boolean  swimmingPool;
    private Boolean  gym;
}
