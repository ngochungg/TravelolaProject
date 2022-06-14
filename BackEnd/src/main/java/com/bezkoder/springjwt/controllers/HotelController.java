package com.bezkoder.springjwt.controllers;

import com.bezkoder.springjwt.models.*;
import com.bezkoder.springjwt.payload.request.HotelRequest;
import com.bezkoder.springjwt.payload.request.RoomRequest;
import com.bezkoder.springjwt.payload.request.ServicesRequest;
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
        user.setIsActive(Boolean.FALSE);
        User resultUser = userRepository.save(user);

        //Hotel create
        Hotel hotel = new Hotel();
        hotel.setHotelName(hotelRequest.getHotelName());
        hotel.setDescription(hotelRequest.getDescription());
        hotel.setEmail(hotelRequest.getEmail());
        hotel.setPhone(hotelRequest.getPhone());
        hotel.setContactName(hotelRequest.getContactName());
        hotel.setLocation(resultLocation);
        hotel.setAccount(resultUser);
        hotel.setStatus(Boolean.FALSE);
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
    //hotel confirmation
    @GetMapping(value = "/confirmHotel/{id}")
    public ResponseEntity<?> confirmHotel(@PathVariable("id") Long id){
        Hotel hotel = hotelRepository.findById(id).get();
        hotel.setStatus(Boolean.TRUE);
        hotelRepository.save(hotel);
        //active user
        String UserId = hotel.getAccount().getId().toString();
        User user = userRepository.findById(Long.parseLong(UserId)).get();
        //System.out.println(UserId);
        user.setIsActive(Boolean.TRUE);
        userRepository.save(user);
        //mail Confirmation
        Map<String, Object> emailMap = new HashMap<>();
        String email = hotel.getEmail();
        emailMap.put("ContactName", hotel.getContactName());
        emailMap.put("HotelName", hotel.getHotelName());
        String templateHtml = emailSenderService.templateResolve("ConfirmHotel", emailMap);
        emailSenderService.sendTemplateMessage(email, null, "Confirm Hotel", templateHtml);
        return ResponseEntity.ok().body("Hotel confirmation successfully");
    }

    //refuse hotel registration
    @GetMapping(value = "/refuseHotel/{id}")
    public ResponseEntity<?> refuseHotel(@PathVariable("id") Long id){
        //mail refuse
        Map<String, Object> emailMap = new HashMap<>();
        String email = hotelRepository.findById(id).get().getEmail();
        emailMap.put("ContactName", hotelRepository.findById(id).get().getContactName());
        emailMap.put("HotelName", hotelRepository.findById(id).get().getHotelName());
        String templateHtml = emailSenderService.templateResolve("RefuseHotel", emailMap);
        emailSenderService.sendTemplateMessage(email, null, "Refuse Hotel", templateHtml);

        //delete images by hotel id
        List<Image> images = imageRepository.findByHotelId(id);
        for (Image image : images) {
            storageService.deleteFileByName(image.getImagePath());
            imageRepository.delete(image);
        }
        //find Hotel by id
        Hotel hotel = hotelRepository.findById(id).get();
        //delete Hotel
        String HotelId = hotel.getLocation().getId().toString();
        String UserId = hotel.getAccount().getId().toString();
        hotelRepository.deleteById(id);
        //delete Location
        locationRepository.deleteById(Long.parseLong(HotelId));
        //delete User of Hotel
        userRepository.deleteById(Long.parseLong(UserId));
        return ResponseEntity.ok().body("Hotel refusal successfully");
    }

    //add services to hotel
    @PostMapping(value = "/addServices/{id}")
    public ResponseEntity<?> addServices(@PathVariable("id") Long id, @RequestBody ServicesRequest servicesRequest){
        //find Hotel by id
        Hotel hotel = hotelRepository.findById(id).get();
        //add services
        hotel.setPaymentAtTheHotel(servicesRequest.getPaymentAtTheHotel());
        hotel.setWifi(servicesRequest.getWifi());
        hotel.setFreeParking(servicesRequest.getFreeParking());
        hotel.setFreeBreakfast(servicesRequest.getFreeBreakfast());
        hotel.setPetsAllowed(servicesRequest.getPetsAllowed());
        hotel.setHotTub(servicesRequest.getHotTub());
        hotel.setSwimmingPool(servicesRequest.getSwimmingPool());
        hotel.setGym(servicesRequest.getGym());

        hotelRepository.save(hotel);
        return ResponseEntity.ok().body("Services registration successfully");
    }

    //add room
    @PostMapping(value = "/addRoom/{id}")
    public ResponseEntity<?> addRoom(@PathVariable("id") Long id, RoomRequest roomRequest){
        //find Hotel by id
        Hotel hotel = hotelRepository.findById(id).get();
        Room roomNumber = roomRepository.findByRoomNumber(roomRequest.getRoomNumber());
        if(roomNumber != null){
            return ResponseEntity.badRequest().body("Room already exists");
        }
        //add room
        Room room = new Room();
        room.setRoomName(roomRequest.getRoomName());
        room.setRoomType(roomRequest.getRoomType());
        room.setRoomNumber(roomRequest.getRoomNumber());
        room.setPrice(roomRequest.getPrice());
        room.setMaxAdult(roomRequest.getMaxAdult());
        room.setMaxChildren(roomRequest.getMaxChildren());
        room.setHotel(hotel);
        Room resultRoom = roomRepository.save(room);

        //upload images
        for (MultipartFile file : roomRequest.getImages()) {
            Image image = new Image();
            String fileName = storageService.storeFile(file);
            image.setImagePath(fileName);
            image.setHotel(hotel);
            image.setRoom(resultRoom);
            image.imageAlt = "image of "+roomRequest.getRoomName();
            //save image
            imageRepository.save(image);
        }
        return ResponseEntity.ok().body("Room registration successfully");
    }


    //get all hotel
    @GetMapping(value = "/getAllHotel")
    public List<Hotel> getAllHotel(){
        return hotelRepository.findAll();
    }


}
