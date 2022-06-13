package com.bezkoder.springjwt.payload.request;

import lombok.Getter;
import lombok.Setter;
import org.springframework.web.multipart.MultipartFile;

@Getter
@Setter
public class HotelRequest {
    private String hotelName;
    private String email;
    private String phone;
    private String username;
    private String password;
    private String contactName;
    private String description;
    private int  numberOfRoom;
    private String street;
    private String ward;
    private String district;
    private String province;
    private MultipartFile[] images;
}
