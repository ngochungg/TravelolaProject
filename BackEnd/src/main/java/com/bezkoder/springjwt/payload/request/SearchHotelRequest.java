package com.bezkoder.springjwt.payload.request;

import com.bezkoder.springjwt.models.District;
import com.bezkoder.springjwt.models.Province;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class SearchHotelRequest {
    private String hotelName;
    private String checkIn;
    private String checkOut;
    private int adults;
    private int children;
    private int priceTo;
    private int rating;
    private int priceFrom;
    //location request
    private String street;
    //province id
    private Long provinceId;
    //district id
    private Long districtId;
    //ward id
    private Long wardId;

}
