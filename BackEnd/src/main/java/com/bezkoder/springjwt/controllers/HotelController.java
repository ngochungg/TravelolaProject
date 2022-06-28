package com.bezkoder.springjwt.controllers;

import com.bezkoder.springjwt.models.*;
import com.bezkoder.springjwt.payload.request.*;
import com.bezkoder.springjwt.repository.*;
import com.bezkoder.springjwt.security.services.IStorageService;
import com.bezkoder.springjwt.services.EmailSenderService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.*;
import java.util.concurrent.TimeUnit;
import java.util.stream.Collectors;

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
    @Autowired
    private BookingRepository hotelBookingRepository;
    @Autowired
    private HotelFeedBackRepository hotelFeedBackRepository;



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
        user.setStatus(Boolean.FALSE);
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
        user.setStatus(Boolean.TRUE);
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
//        if(roomRepository.existsByRoomNumber(roomRequest.getRoomNumber())){
//            return ResponseEntity.badRequest().body("Room number already exists");
//        }
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
        int roomToHotel = hotel.getNumberOfRoom()+1;
        hotel.setNumberOfRoom(roomToHotel);
        hotelRepository.save(hotel);

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
    //get location by hotel id
    @GetMapping(value = "/getLocation/{id}")
    public Location getLocation(@PathVariable("id") Long id){
        //find by hotel id
        Hotel hotel = hotelRepository.findById(id).get();
        Long locationId = hotel.getLocation().getId();
        //find location by hotel id
        Location location = locationRepository.findById(locationId).get();;
        return location;
    }
    //get ward by id
    @GetMapping(value = "/getWard/{id}")
    public Ward getWard(@PathVariable("id") Long id) {
        return wardRepository.findById(id).get();
    }
    //get all room
    @GetMapping(value = "/getAllRoom")
    public List<Room> getAllRoom(){
        return roomRepository.findAll();
    }
    //get room by hotel id
    @GetMapping(value = "/getRoom/{id}")
    public List<Room> getRoom(@PathVariable("id") Long id){
        return roomRepository.findByHotelId(id);
    }

    //HotelBooking
    @PostMapping(value = "/hotelBooking")
    public ResponseEntity<?> hotelBooking(@RequestBody HotelBookingRequest hotelBookingRequest) {
        //find room by id
        Room room = roomRepository.findById(hotelBookingRequest.getRoomId()).get();
        //find hotel by id
        Hotel hotel = hotelRepository.findById(room.getHotel().getId()).get();
        //find user by id
        User user = userRepository.findById(hotelBookingRequest.getUserId()).get();
        System.out.println(hotelBookingRequest.getCheckInDate());
        System.out.println(hotelBookingRequest.getCheckOutDate());
        //get roles of user
        //check if user is ROLE_MODERATOR
        //get all hotels
        List<Hotel> hotels = hotelRepository.findAll();
        for (Hotel hotel1 : hotels) {
            if (hotel1.getAccount().getId().equals(user.getId())) {
                return ResponseEntity.badRequest().body("You are Hotel. You can't book a room");
            }
        }
        //check check in date before check out date
        if(hotelBookingRequest.getCheckInDate().after(hotelBookingRequest.getCheckOutDate())){
            return ResponseEntity.badRequest().body("Check in date must be before check out date");
        }
        //check check in date after today
        if(hotelBookingRequest.getCheckInDate().before(new Date())){
            return ResponseEntity.badRequest().body("Check in date must be after today");
        }
        //add hotel booking
        HotelBooking hotelBooking = new HotelBooking();
        hotelBooking.setBookingCode(emailSenderService.randomString());
        //time
        hotelBooking.setCheckInDate(hotelBookingRequest.getCheckInDate());
        hotelBooking.setCheckOutDate(hotelBookingRequest.getCheckOutDate());
        hotelBooking.setNumOfGuest(hotelBookingRequest.getNumOfGuest());
        hotelBooking.setPaymentMethod(hotelBookingRequest.getPaymentMethod());
        hotelBooking.setTotalPrice(hotelBookingRequest.getTotalPrice());
        hotelBooking.setRoom(room);
        hotelBooking.setUser(user);
        HotelBooking resultHotelBooking = hotelBookingRepository.save(hotelBooking);
        //return hotel booking
        return ResponseEntity.ok().body(resultHotelBooking);


}

    //count day
    public static long getDifferenceDays(Date d1, Date d2) {
            long diff = d2.getTime() - d1.getTime();
            return TimeUnit.DAYS.convert(diff, TimeUnit.MILLISECONDS);
    }

//    search hotel
    @PostMapping(value = "/searchHotel")
    public List<Hotel> searchHotel(@RequestBody SearchHotelRequest searchHotelRequest){
        //List hotel before search
        List<Hotel> hotels = hotelRepository.findAll();
        //list hotel booking
        List<HotelBooking> hotelBookings = hotelBookingRepository.findAll();
        //sreach hotel by hotelname
        if(searchHotelRequest.getHotelName()!=null){
            hotels = hotels.stream().filter(hotel -> hotel.getHotelName().toLowerCase().contains(searchHotelRequest.getHotelName().toLowerCase())).collect(Collectors.toList());
        }
        //search hotel by street
        if(searchHotelRequest.getStreet()!=null){
            hotels = hotels.stream().filter(hotel -> hotel.getLocation().getStreet().toLowerCase().contains(searchHotelRequest.getStreet().toLowerCase())).collect(Collectors.toList());
        }
        //search hotel by ProvinceId
        if(searchHotelRequest.getProvinceId()!=null){
            hotels = hotels.stream().filter(hotel -> hotel.getLocation().getProvince().getId().equals(searchHotelRequest.getProvinceId())).collect(Collectors.toList());
        }
        //search hotel by DistrictId
        if(searchHotelRequest.getDistrictId()!=null){
            hotels = hotels.stream().filter(hotel -> hotel.getLocation().getDistrict().getId().equals(searchHotelRequest.getDistrictId())).collect(Collectors.toList());
        }
        //search hotel by WardId
        if(searchHotelRequest.getWardId()!=null){
            hotels = hotels.stream().filter(hotel -> hotel.getLocation().getWard().getId().equals(searchHotelRequest.getWardId())).collect(Collectors.toList());
        }
        //search in room by priceFrom and priceTo
        //search in booking hotel by check in date
//        if(searchHotelRequest.getCheckIn()!=null){
//        }
        //if hotels null return request not found
        if(hotels.isEmpty()){
            //return body request not found
            return null;
        }
        //return list hotel after search
        return hotels;
    }

//show feedback of hotel
    @GetMapping(value = "/showFeedback/{id}")
    public List<HotelFeedBack> showFeedback(@PathVariable("id") Long id){
        return hotelFeedBackRepository.findByHotelId(id);
    }



}