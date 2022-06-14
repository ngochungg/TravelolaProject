package com.bezkoder.springjwt.payload.request;

import lombok.Getter;
import lombok.Setter;
import org.springframework.web.multipart.MultipartFile;

import java.util.Date;
@Setter
@Getter
public class RoomRequest {
    private int roomNumber;
    private String roomName;
//    private Date availableTime;
    private String roomType;
    private double price;
    private int maxAdult;
    private int maxChildren;
    private MultipartFile[] images;
}
