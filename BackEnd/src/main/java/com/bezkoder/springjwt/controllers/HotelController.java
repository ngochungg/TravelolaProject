package com.bezkoder.springjwt.controllers;

import com.bezkoder.springjwt.models.*;
import com.bezkoder.springjwt.payload.request.HotelRequest;
import com.bezkoder.springjwt.repository.*;
import com.bezkoder.springjwt.security.services.IStorageService;
import com.bezkoder.springjwt.services.EmailSenderService;
import org.jetbrains.annotations.NotNull;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.*;

@CrossOrigin
@RestController
@RequestMapping("/api/hotel")
public class HotelController {
    @Autowired
    private HotelRepository hotelRepository;
    @Autowired
    private RoomRepository roomRepository;
    @Autowired
    private LocationRepository locationRepository;
    @Autowired
    private ProvinceRepository provinceRepository;
    @Autowired
    private DistrictRepository districtRepository;
    @Autowired
    private  WardRepository wardRepository;
    @Autowired
    private UserRepository userRepository;
    @Autowired
    private IStorageService storageService;
    @Autowired
    private RoleRepository roleRepository;
    @Autowired
    private ImageRepository imageRepository;
    @Autowired
    PasswordEncoder encoder;
    @Autowired
    EmailSenderService emailSenderService;


    //add hotel and MultipartFile image
    @PostMapping(value = "/addHotel")
    public ResponseEntity<?> addHotel(HotelRequest hotelRequest){
        if(userRepository.existsByUsername(hotelRequest.getUsername())){
            return ResponseEntity.badRequest().body("Username is already exist");
        }
        if (userRepository.existsByEmail(hotelRequest.getEmail())){
            return ResponseEntity.badRequest().body("Email is already exist");
        }
        if(userRepository.existsByPhone(hotelRequest.getPhone())){
            return ResponseEntity.badRequest().body("Phone is already exist");
        }
        //Location create
        Location location = new Location();
        location.setStreet(hotelRequest.getStreet());
        location.setPostalCode("7000");
        location.setRetired(Boolean.FALSE);
        location.setProvince(provinceRepository.findById(Long.parseLong(hotelRequest.getProvince())).get());
        location.setDistrict(districtRepository.findById(Long.parseLong(hotelRequest.getDistrict())).get());
        location.setWard(wardRepository.findById(Long.parseLong(hotelRequest.getWard())).get());

        Location resultLocation = locationRepository.save(location);

        //User create
        User user = new User();
        user.setUsername(hotelRequest.getUsername());
        user.setPassword(encoder.encode(hotelRequest.getPassword()));
        user.setEmail(hotelRequest.getEmail());
        user.setPhone(hotelRequest.getPhone());
        Role userRole = roleRepository.findByName(ERole.ROLE_MODERATOR)
                .orElseThrow(() -> new RuntimeException("Error: Role is not found."));
        user.setRoles(Collections.singleton(userRole));
        user.setIsActive(Boolean.TRUE);

        User resultUser = userRepository.save(user);

        //Hotel create
        Hotel hotel = new Hotel();
        hotel.setHotelName(hotelRequest.getHotelName());
        hotel.setDescription(hotelRequest.getDescription());
        hotel.setEmail(hotelRequest.getEmail());
        hotel.setPhone(hotelRequest.getPhone());
        hotel.setContactName(hotelRequest.getContactName());
        hotel.setNumberOfRoom(hotelRequest.getNumberOfRoom());
        hotel.setLocation(resultLocation);
        hotel.setAccount(resultUser);
        hotel.setRetired(Boolean.FALSE);
        Hotel resultHotel = hotelRepository.save(hotel);

        //upload images

        for (MultipartFile file : hotelRequest.getImages()) {
            Image image = new Image();
            String fileName = storageService.storeFile(file);
            image.setImagePath(fileName);
            image.setHotel(resultHotel);
            image.imageAlt = "image of "+hotelRequest.getHotelName();
            //save image
            imageRepository.save(image);
        }
        //mail to user
        Map<String, Object> emailMap = new HashMap<>();
        String email = hotelRequest.getEmail();
        emailMap.put("ContactName", hotelRequest.getContactName());
        emailMap.put("HotelName", hotelRequest.getHotelName());
        String templateHtml = emailSenderService.templateResolve("HelloHotel", emailMap);
        emailSenderService.sendTemplateMessage(email, null, "Hello Hotel", templateHtml);
        return ResponseEntity.ok().body("Hotel registration successfully, please wait for confirmation...!");
    }
}