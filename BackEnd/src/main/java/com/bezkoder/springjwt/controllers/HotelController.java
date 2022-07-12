package com.bezkoder.springjwt.controllers;

import com.bezkoder.springjwt.services.PdfGenerateService;
import com.google.zxing.BarcodeFormat;
import com.google.zxing.WriterException;
import com.google.zxing.client.j2se.MatrixToImageWriter;
import com.google.zxing.common.BitMatrix;
import com.google.zxing.qrcode.QRCodeWriter;

import com.bezkoder.springjwt.models.*;
import com.bezkoder.springjwt.payload.request.*;
import com.bezkoder.springjwt.repository.*;
import com.bezkoder.springjwt.security.services.IStorageService;
import com.bezkoder.springjwt.services.EmailSenderService;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;


import java.io.File;
import java.io.IOException;
import java.nio.file.FileSystems;
import java.nio.file.Path;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.LocalDateTime;
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

    @Autowired
    private PdfGenerateService  pdfGenerateService;

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
        if(servicesRequest.getPaymentAtTheHotel() != null){
            hotel.setPaymentAtTheHotel(servicesRequest.getPaymentAtTheHotel());
        }
        if(servicesRequest.getWifi() != null){
            hotel.setWifi(servicesRequest.getWifi());
        }
        if(servicesRequest.getFreeParking() != null){
            hotel.setFreeParking(servicesRequest.getFreeParking());
        }
        if(servicesRequest.getFreeBreakfast() != null){
            hotel.setFreeBreakfast(servicesRequest.getFreeBreakfast());
        }
        if(servicesRequest.getPetsAllowed() != null){
            hotel.setPetsAllowed(servicesRequest.getPetsAllowed());
        }
         if(servicesRequest.getHotTub() != null){
                hotel.setHotTub(servicesRequest.getHotTub());
          }
        if(servicesRequest.getSwimmingPool() != null){
            hotel.setSwimmingPool(servicesRequest.getSwimmingPool());
        }
        if(servicesRequest.getGym() != null){
            hotel.setGym(servicesRequest.getGym());
        }
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
        room.setRoomStatus(false);
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
    public ResponseEntity<?> hotelBooking(@RequestBody HotelBookingRequest hotelBookingRequest, Model model) throws IOException, WriterException {
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
        //check in date before check out date
        if(hotelBookingRequest.getCheckInDate().after(hotelBookingRequest.getCheckOutDate())){
            return ResponseEntity.badRequest().body("Check in date must be before check out date");
        }
        //check check in date after today
        // if(hotelBookingRequest.getCheckInDate().before(new Date())){
        //     return ResponseEntity.badRequest().body("Check in date must be after today");
        // }
        //check Number of people in room
        int people = room.getMaxChildren()+room.getMaxAdult();
        System.out.println(people);
        if(people < hotelBookingRequest.getNumOfGuest()){
            return ResponseEntity.badRequest().body("Number of people in room must be less than "+people);
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
        //room status = true
        room.setRoomStatus(true);
        roomRepository.save(room);
        System.out.println(resultHotelBooking.getBookingCode());
        //return hotel booking

        //check booking success if true send mail to user
        if(resultHotelBooking != null){

            //Qr code information resultHotelBooking
            String qrCodeInfo = "Booking code: "+resultHotelBooking.getBookingCode()+
                    "\n"+"Check in date: "+resultHotelBooking.getCheckInDate()+"\n"+
                    "Check out date: "+resultHotelBooking.getCheckOutDate()+"\n"+
                    "Number of guest: "+resultHotelBooking.getNumOfGuest()+"\n"+
                    "Total price: "+resultHotelBooking.getTotalPrice()+"\n"+
                    "Payment method: "+resultHotelBooking.getPaymentMethod();

            //create qr code
            String nameQr = emailSenderService.randomString()+".png";
            System.out.println("name Qr: "+ nameQr);
            generateQRCodeImage(qrCodeInfo,300,300,"uploads/"+nameQr);
            //insert qr code to hotel booking
            resultHotelBooking.setQrCode(nameQr);
            hotelBookingRepository.save(resultHotelBooking);

            Map<String, Object> emailMap = new HashMap<>();
            emailMap.put("hotelBooking", resultHotelBooking);
            emailMap.put("user", user);
            emailMap.put("hotel", hotel);
            emailMap.put("room", room);
            emailMap.put("qrCode", "http://localhost:8080/api/auth/getImage/"+nameQr);
            //address
            String address = hotel.getLocation().getWard().getName()+", "+hotel.getLocation().getDistrict().getName()+", "+hotel.getLocation().getProvince().getName();
            emailMap.put("address", address);
            String templateHtml = emailSenderService.templateResolve("bookingSuccess", emailMap);
            emailSenderService.sendTemplateMessage(user.getEmail(), "Booking Success", "bookingSuccess", templateHtml);
        }
        return ResponseEntity.ok().body(resultHotelBooking);
}
//qr code
public static void generateQRCodeImage(String text, int width, int height, String filePath)
        throws WriterException, IOException {
    QRCodeWriter qrCodeWriter = new QRCodeWriter();
    BitMatrix bitMatrix = qrCodeWriter.encode(text, BarcodeFormat.QR_CODE, width, height);

    Path path = FileSystems.getDefault().getPath(filePath);
    MatrixToImageWriter.writeToPath(bitMatrix, "PNG", path);

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
        //search hotel by check in date
        // if(searchHotelRequest.getCheckIn()!=null || searchHotelRequest.getCheckOut()!=null){
        //    //get hotel have room status = false
        //     hotels = hotels.stream().filter(hotel -> hotel.getRooms().stream().anyMatch(room -> room.getRoomStatus() == false)).collect(Collectors.toList());
        // }
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
    //find 4 province have most hotels
    @GetMapping(value = "/find4ProvinceHaveMostHotel")
    public List<Province> find4ProvinceHaveMostHotel(){
        List<Province> provinces = provinceRepository.findAll();
        List<Province> result = new ArrayList<>();
        for (Province province : provinces) {
            List<Hotel> hotels = hotelRepository.findByLocation_Province_Id(province.getId());
            if(hotels.size()>=2){
                result.add(province);
            }
        }
        return result;
    }

    //confirmed hotel booking
    @PutMapping(value = "/confirmedHotelBooking/{id}")
    public ResponseEntity<HotelBooking> confirmedHotelBooking(@PathVariable("id") Long id){
        HotelBooking hotelBooking = hotelBookingRepository.findById(id).get();
        hotelBooking.setRetired(true);
        HotelBooking result = hotelBookingRepository.save(hotelBooking);
        Room room = roomRepository.findById(result.getRoom().getId()).get();
        //hotel name
        String hotelname = room.getHotel().getHotelName();
        room.setRoomStatus(false);
        //booking code
        String bookingCode = result.getBookingCode();
        //first name
        String firstName = result.getUser().getFirstName();

        roomRepository.save(room);
        Map<String, Object> emailMap = new HashMap<>();
        emailMap.put("hotelname", hotelname);
        emailMap.put("bookingCode", bookingCode);
        emailMap.put("firstName", firstName);
        String templateHtml = emailSenderService.templateResolve("confirmedBooking", emailMap);
        emailSenderService.sendTemplateMessage(result.getUser().getEmail(), "Confirmed Booking", "confirmedBooking", templateHtml);
        return ResponseEntity.ok().body(result);
    }
    //refuse hotel booking
    @PutMapping(value = "/refuseHotelBooking/{id}")
    public ResponseEntity<HotelBooking> refuseHotelBooking(@PathVariable("id") Long id){
        HotelBooking hotelBooking = hotelBookingRepository.findById(id).get();
        hotelBooking.setRetired(false);
        HotelBooking result = hotelBookingRepository.save(hotelBooking);
        Room room = roomRepository.findById(result.getRoom().getId()).get();
        room.setRoomStatus(false);
        roomRepository.save(room);
        //send email
        Map<String, Object> emailMap = new HashMap<>();
        emailMap.put("hotelname", room.getHotel().getHotelName());
        emailMap.put("bookingCode", result.getBookingCode());
        emailMap.put("firstName", result.getUser().getFirstName());
        String templateHtml = emailSenderService.templateResolve("refuseBooking", emailMap);
        emailSenderService.sendTemplateMessage(result.getUser().getEmail(), "Refuse Booking", "refuseBooking", templateHtml);
        User user = userRepository.findById(result.getUser().getId()).get();
        return ResponseEntity.ok().body(result);
    }
    //get all booking retired true
    @GetMapping(value = "/getAllBookingRetiredTrue")
    public List<HotelBooking> getAllBookingRetiredTrue(){
        return hotelBookingRepository.findByRetired(true);
    }
    //get all booking retired false
    @GetMapping(value = "/getAllBookingRetiredFalse")
    public List<HotelBooking> getAllBookingRetiredFalse(){
        return hotelBookingRepository.findByRetired(false);
    }



    //PDF report
    //report file pdf allRoom
    @GetMapping(value = "/reportallRoom/{id}")
    public String reportAllRoom(@PathVariable("id") Long id) throws IOException {
        //list all room by hotel id
        List<Room> rooms = roomRepository.findByHotelId(id);
        //find hotel by id
        Hotel hotel = hotelRepository.findById(id).get();
        String address = rooms.get(0).getPrice()+", "+hotel.getLocation().getDistrict().getName()+", "+hotel.getLocation().getProvince().getName();
        Map<String, Object> pdfMap = new HashMap<>();
        pdfMap.put("rooms", rooms);
        pdfMap.put("hotel", hotel);
        pdfMap.put("address", address);
        String namePdf = hotel.getHotelName()+"_allRoom_"+LocalDate.now()+".pdf";
        System.out.println(namePdf);
        pdfGenerateService.generatePdfFile("rooms", pdfMap, namePdf);
//        File file = new File(namePdf);
        return namePdf;
    }
    //report 10 booking hotel by hotel id
    @GetMapping(value = "/reportBookingHotelInMonth/{id}")
    public String reportBookingHotelInMonth(@PathVariable("id") Long id) throws IOException {
        //list all room by hotel id
        List<Room> rooms = roomRepository.findByHotelId(id);
        //List all booking by list room
        List<HotelBooking> hotelBookings = new ArrayList<>();
        for (Room room : rooms) {
            hotelBookings.addAll(hotelBookingRepository.findByRoomId(room.getId()));
        }
        //get last 10 booking hotel new to old
        List<HotelBooking> result = new ArrayList<>();
        float total = 0;
        for (int i = hotelBookings.size()-1; i >= 0; i--) {
            //in month of year
            //get year of booking
            Date date = new Date();
            //set date is yyyy-MM-dd
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            //get date check out
            Date dateCheckOut = hotelBookings.get(i).getCheckOutDate();
            //get year of check out
            int yearCheckOut = dateCheckOut.getYear() + 1900;
            //get month of check out
            int monthCheckOut = dateCheckOut.getMonth() + 1;

            //if year and month is same with current year and month
            if(yearCheckOut == LocalDate.now().getYear() && monthCheckOut == LocalDate.now().getMonthValue()){
                result.add(hotelBookings.get(i));
                total += hotelBookings.get(i).getTotalPrice();
            }
        }

        //find hotel by id
        Hotel hotel = hotelRepository.findById(id).get();
        String address = rooms.get(0).getPrice()+", "+hotel.getLocation().getDistrict().getName()+", "+hotel.getLocation().getProvince().getName();
        Map<String, Object> pdfMap = new HashMap<>();
        pdfMap.put("result", result);
        pdfMap.put("hotel", hotel);
        pdfMap.put("address", address);
        pdfMap.put("total", total);
        String namePdf = hotel.getHotelName()+"_BookingHotelInMonth_"+LocalDate.now()+".pdf";
        System.out.println(namePdf);
        pdfGenerateService.generatePdfFile("hotelBookings", pdfMap, namePdf);
        File file = new File(namePdf);
        return namePdf;
    }
    //report booking of user by user id
    @GetMapping(value = "/reportBookingUser/{id}")
    public String reportBookingUser(@PathVariable("id") Long id) throws IOException {
        //list Booking by user id
        List<HotelBooking> result = hotelBookingRepository.findByUserId(id);
        //find user by id
        User user = userRepository.findById(id).get();
        Map<String, Object> pdfMap = new HashMap<>();
        pdfMap.put("result", result);
        pdfMap.put("user", user);
        String namePdf = user.getFirstName() + "_BookingUser_" + LocalDate.now() + ".pdf";
        System.out.println(namePdf);
        pdfGenerateService.generatePdfFile("userBookings", pdfMap, namePdf);
        File file = new File(namePdf);
        return namePdf;
    }
}