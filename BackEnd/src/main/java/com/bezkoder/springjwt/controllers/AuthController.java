package com.bezkoder.springjwt.controllers;

import java.time.LocalDate;
import java.util.*;
import java.util.stream.Collectors;

import javax.validation.Valid;

import com.bezkoder.springjwt.models.*;
import com.bezkoder.springjwt.payload.request.*;
import com.bezkoder.springjwt.repository.*;
import com.bezkoder.springjwt.security.services.IStorageService;
import com.bezkoder.springjwt.services.EmailSenderService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;

import com.bezkoder.springjwt.payload.response.JwtResponse;
import com.bezkoder.springjwt.payload.response.MessageResponse;
import com.bezkoder.springjwt.security.jwt.JwtUtils;
import com.bezkoder.springjwt.security.services.UserDetailsImpl;
import org.springframework.web.multipart.MultipartFile;

@CrossOrigin(origins = "*", maxAge = 3600)
@RestController
@RequestMapping("/api/auth")
public class AuthController {
    @Autowired
    AuthenticationManager authenticationManager;

    @Autowired
    UserRepository userRepository;

    @Autowired
    RoleRepository roleRepository;

    @Autowired
    PasswordEncoder encoder;

    @Autowired
    JwtUtils jwtUtils;

    @Autowired
    IStorageService storageService;

    @Autowired
    EmailSenderService emailSenderService;

    @Autowired
    private BookingRepository hotelBookingRepository;

    @Autowired
    private WardRepository wardRepository;

    @Autowired
    private ProvinceRepository provinceRepository;

    @Autowired
    private DistrictRepository districtRepository;

    @Autowired
    private HotelFeedBackRepository hotelFeedBackRepository;

    @Autowired
    private HotelRepository hotelRepository;



    //login
    @PostMapping("/signin")
    public ResponseEntity<?> authenticateUser(@Valid @RequestBody LoginRequest loginRequest) {

        Authentication authentication = authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(loginRequest.getUsername(), loginRequest.getPassword()));

        SecurityContextHolder.getContext().setAuthentication(authentication);
        String jwt = jwtUtils.generateJwtToken(authentication);

        UserDetailsImpl userDetails = (UserDetailsImpl) authentication.getPrincipal();
        List<String> roles = userDetails.getAuthorities().stream()
                .map(item -> item.getAuthority())
                .collect(Collectors.toList());
        if(userDetails.getIsActive() == false) {
            return ResponseEntity
                    .badRequest()
                    .body(new MessageResponse("Error: Username disabled!"));
        }

        return ResponseEntity.ok(new JwtResponse(jwt,
                userDetails.getId(),
                userDetails.getUsername(),
                userDetails.getEmail(),
                userDetails.getLastName(),
                userDetails.getFirstName(),
                userDetails.getPhone(),
                userDetails.getImageUrl(),
                userDetails.getIsActive(),
                roles));
    }
    //Register
    @PostMapping("/signup")
    public ResponseEntity<?> registerUser(@Valid @RequestBody SignupRequest signUpRequest) {
        if (userRepository.existsByUsername(signUpRequest.getUsername())) {
            return ResponseEntity
                    .badRequest()
                    .body(new MessageResponse("Error: Username is already taken!"));
        }

        if (userRepository.existsByEmail(signUpRequest.getEmail())) {
            return ResponseEntity
                    .badRequest()
                    .body(new MessageResponse("Error: Email is already in use!"));
        }

        // Create new user's account
        User user = new User(signUpRequest.getUsername(),
                signUpRequest.getEmail(),
                encoder.encode(signUpRequest.getPassword()),
                signUpRequest.getFirstName(), signUpRequest.getLastName(),
                signUpRequest.getPhone(), signUpRequest.getImageUrl(),signUpRequest.isActive());

        Set<String> strRoles = signUpRequest.getRole();
        Set<Role> roles = new HashSet<>();

        if (strRoles == null) {
            Role userRole = roleRepository.findByName(ERole.ROLE_USER)
                    .orElseThrow(() -> new RuntimeException("Error: Role is not found."));
            roles.add(userRole);
        } else {
            strRoles.forEach(role -> {
                switch (role) {
                    case "admin":
                        Role adminRole = roleRepository.findByName(ERole.ROLE_ADMIN)
                                .orElseThrow(() -> new RuntimeException("Error: Role is not found."));
                        roles.add(adminRole);

                        break;
                    case "mod":
                        Role modRole = roleRepository.findByName(ERole.ROLE_MODERATOR)
                                .orElseThrow(() -> new RuntimeException("Error: Role is not found."));
                        roles.add(modRole);

                        break;
                    default:
                        Role userRole = roleRepository.findByName(ERole.ROLE_USER)
                                .orElseThrow(() -> new RuntimeException("Error: Role is not found."));
                        roles.add(userRole);
                }
            });
        }

        user.setRoles(roles);
        userRepository.save(user);

        return ResponseEntity.ok(new MessageResponse("User registered successfully!"));
    }
    //upload image
    @PostMapping("/uploadImage/{id}")
    public ResponseEntity<?> uploadFile(@RequestParam("file") MultipartFile file, @PathVariable Long id) {
            String generatedFileName = storageService.storeFile(file);
            User updateImage = userRepository.findById(id).orElseThrow(() -> new RuntimeException("Error: User not found."));
            updateImage.setImageUrl(generatedFileName);
            userRepository.save(updateImage);
            return ResponseEntity.ok(new MessageResponse("User updated image successfully!"));
    }
    //get image's url
    @GetMapping("/getImage/{fileName:.+}")
    public ResponseEntity<byte[]> readDetailFile(@PathVariable String fileName) {
        try {
            byte[] bytes = storageService.readFileContent(fileName);
            return ResponseEntity
                    .ok()
                    .contentType(MediaType.IMAGE_JPEG)
                    .body(bytes);
        }catch (Exception exception) {
            return ResponseEntity.noContent().build();
        }
    }
    //Change password
    @PostMapping("/updatePassword/{id}")
    public ResponseEntity<?> updatePassword(@RequestBody PasswordRequest passwordRequest, @PathVariable Long id) {
        User user = userRepository.findById(id).orElseThrow(() -> new RuntimeException("Error: User not found."));
        if (!encoder.matches(passwordRequest.getOldPassword(), user.getPassword())) {
            return ResponseEntity.ok(new MessageResponse("Old password is not correct!"));
        }
        user.setPassword(encoder.encode(passwordRequest.getNewPassword()));
        userRepository.save(user);
        return ResponseEntity.ok(new MessageResponse("Password updated successfully!"));
    }
    //update user
    @PostMapping("/updateUser/{id}")
    public ResponseEntity<?> updateUser(@RequestBody UpdateRequest UpdateRequest, @PathVariable Long id) {
        User user = userRepository.findById(id).orElseThrow(() -> new RuntimeException("Error: User not found."));
        if (userRepository.existsByEmail(UpdateRequest.getEmail())) {
            return ResponseEntity
                    .badRequest()
                    .body(new MessageResponse("Error: Email is already in use!"));
        }
        user.setFirstName(UpdateRequest.getFirstName());
        user.setLastName(UpdateRequest.getLastName());
        user.setEmail(UpdateRequest.getEmail());
        user.setPhone(UpdateRequest.getPhone());
        userRepository.save(user);
        return ResponseEntity.ok(new MessageResponse("User updated successfully!"));
    }
    //lock user
    @PostMapping("/lockUser/{id}")
    public ResponseEntity<?> lockUser(@PathVariable Long id) {
        User user = userRepository.findById(id).orElseThrow(() -> new RuntimeException("Error: User not found."));
        user.setStatus(false);
        userRepository.save(user);
        return ResponseEntity.ok(new MessageResponse("User locked successfully!"));
    }
    //unlock user
    @PostMapping("/unlockUser/{id}")
    public ResponseEntity<?> unlockUser(@PathVariable Long id) {
        User user = userRepository.findById(id).orElseThrow(() -> new RuntimeException("Error: User not found."));
        user.setStatus(true);
        userRepository.save(user);
        return ResponseEntity.ok(new MessageResponse("User unlocked successfully!"));
    }
    //delete user
    @DeleteMapping("/deleteUser/{id}")
    public ResponseEntity<?> deleteUser(@PathVariable Long id) {
        User user = userRepository.findById(id).orElseThrow(() -> new RuntimeException("Error: User not found."));
        userRepository.delete(user);
        return ResponseEntity.ok(new MessageResponse("User deleted successfully!"));
    }
    //get all user
    @GetMapping("/getAllUser")
    public ResponseEntity<?> getAllUser() {
        List<User> users = userRepository.findAll();

        return ResponseEntity.ok(users);
    }
    //Forgot password
    @PostMapping("/forgotPassword/{email}")
    public ResponseEntity<?> forgotPassword(@PathVariable String email) {
        User user = userRepository.findByEmail(email);
        if (user == null) {
            return ResponseEntity.ok(new MessageResponse("Error: User not found."));
        }
        String newPassword = emailSenderService.randomString();
        user.setPassword(encoder.encode(newPassword));
        userRepository.save(user);
        Map<String, Object> emailMap = new HashMap<>();
        emailMap.put("newPassword", newPassword);
        emailMap.put("name", user.getFirstName()+" "+user.getLastName());
        String templateHtml = emailSenderService.templateResolve("NewPassword", emailMap);
        emailSenderService.sendTemplateMessage(email, null, "New Password", templateHtml);

        return ResponseEntity.ok(new MessageResponse("New password sent to your email!"));
    }
    //login facebook
    @PostMapping("/loginFacebook")
    public ResponseEntity<?> loginFacebook( @RequestBody LoginSocialRequest loginSocialRequest) {
        User user = userRepository.findByEmail(loginSocialRequest.getEmail());
        if (user == null) {
            //create new user
            user = new User();
            user.setEmail(loginSocialRequest.getEmail());
            user.setFirstName(loginSocialRequest.getFirstName());
            user.setLastName(loginSocialRequest.getLastName());
            user.setPassword(encoder.encode(loginSocialRequest.getId()));
            user.setImageUrl(loginSocialRequest.getPhotoUrl());
            user.setStatus(true);
            user.setUsername("Facebook"+ loginSocialRequest.getId());
            user.setPhone("Null");
            Role userRole = roleRepository.findByName(ERole.ROLE_USER)
                    .orElseThrow(() -> new RuntimeException("Error: Role is not found."));
            user.setRoles(Collections.singleton(userRole));
            userRepository.save(user);
        }
        String Username = user.getUsername();
        //cut 8 characters first of username
        String Password = Username.substring(8);
        //login
        Authentication authentication = authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(Username, Password));
        SecurityContextHolder.getContext().setAuthentication(authentication);
        String jwt = jwtUtils.generateJwtToken(authentication);
        UserDetailsImpl userDetails = (UserDetailsImpl) authentication.getPrincipal();
        List<String> roles = userDetails.getAuthorities().stream()
                .map(item -> item.getAuthority())
                .collect(Collectors.toList());
        if(userDetails.getIsActive() == false) {
            return ResponseEntity
                    .badRequest()
                    .body(new MessageResponse("Error: Username disabled!"));
        }
        return ResponseEntity.ok(new JwtResponse(jwt,
                userDetails.getId(),
                userDetails.getUsername(),
                userDetails.getEmail(),
                userDetails.getLastName(),
                userDetails.getFirstName(),
                userDetails.getPhone(),
                userDetails.getImageUrl(),
                userDetails.getIsActive(),
                roles));
    }

    //login google
    @PostMapping("/loginGoogle")
    public ResponseEntity<?> loginGoogle( @RequestBody LoginSocialRequest loginSocialRequest) {
    User user = userRepository.findByEmail(loginSocialRequest.getEmail());
        if (user == null) {
            //create new user
            user = new User();
            user.setEmail(loginSocialRequest.getEmail());
            user.setFirstName(loginSocialRequest.getFirstName());
            user.setLastName(loginSocialRequest.getLastName());
            user.setPassword(encoder.encode(loginSocialRequest.getId()));
            user.setImageUrl(loginSocialRequest.getPhotoUrl());
            user.setStatus(true);
            user.setUsername("Google"+ loginSocialRequest.getId());
            user.setPhone("Null");
            Role userRole = roleRepository.findByName(ERole.ROLE_USER)
                    .orElseThrow(() -> new RuntimeException("Error: Role is not found."));
            user.setRoles(Collections.singleton(userRole));
            userRepository.save(user);
        }
        String Username = user.getUsername();
        //cut 8 characters first of username
        String Password = Username.substring(6);
        //login
        Authentication authentication = authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(Username, Password));
        SecurityContextHolder.getContext().setAuthentication(authentication);
        String jwt = jwtUtils.generateJwtToken(authentication);
        UserDetailsImpl userDetails = (UserDetailsImpl) authentication.getPrincipal();
        List<String> roles = userDetails.getAuthorities().stream()
                .map(item -> item.getAuthority())
                .collect(Collectors.toList());
        if(userDetails.getIsActive() == false) {
            return ResponseEntity
                    .badRequest()
                    .body(new MessageResponse("Error: Username disabled!"));
        }
        return ResponseEntity.ok(new JwtResponse(jwt,
                userDetails.getId(),
                userDetails.getUsername(),
                userDetails.getEmail(),
                userDetails.getLastName(),
                userDetails.getFirstName(),
                userDetails.getPhone(),
                userDetails.getImageUrl(),
                userDetails.getIsActive(),
                roles));
    }
    //view profile by id

    @GetMapping("/viewProfile/{id}")
    public ResponseEntity<?> viewProfile(@PathVariable Long id) {
        User user = userRepository.findById(id).orElseThrow(() -> new RuntimeException("Error: User not found."));
        return ResponseEntity.ok(user);
    }

    @GetMapping("/getAllAdmin")
    public ResponseEntity<?> getAllAdmin() {
        List<User> users = userRepository.findAll();
        return ResponseEntity.ok(users);
    }
    //get booking by user id
    @GetMapping("/getBooking/{id}")
    public ResponseEntity<?> getBooking(@PathVariable Long id) {
        List<HotelBooking> bookings = hotelBookingRepository.findByUserId(id);
        return ResponseEntity.ok(bookings);
    }

    // get all ward
    @GetMapping("/getAllWard")
    public ResponseEntity<?> getAllWard() {
        List<Ward> wards = wardRepository.findAll();
        return ResponseEntity.ok(wards);
    }
    // get all district
    @GetMapping("/getAllDistrict")
    public ResponseEntity<?> getAllDistrict() {
        List<District> districts = districtRepository.findAll();
        return ResponseEntity.ok(districts);
    }
    // get all province
    @GetMapping("/getAllProvince")
    public ResponseEntity<?> getAllProvince() {
        List<Province> provinces = provinceRepository.findAll();
        return ResponseEntity.ok(provinces);
    }
    //feedback by booking
    @PostMapping("/feedback")
    public ResponseEntity<?> feedback(@RequestBody FeedbackRequest feedbackRequest) {
            HotelBooking hotelBooking = hotelBookingRepository.findById(feedbackRequest.getHotel_booking_id()).get();
            Hotel hotel = hotelRepository.findById(hotelBooking.getRoom().getHotel().getId()).get();
            if(hotelBooking.isStatus() == false) {
                return ResponseEntity
                        .badRequest()
                        .body(new MessageResponse("Error: Booking is not confirmed!"));
            }
            //check user check out date
            if(hotelBooking.getCheckOutDate().before(new Date())) {
                return ResponseEntity
                        .badRequest()
                        .body(new MessageResponse("Error: User check out date is before today!"));
            }
            HotelFeedBack hotelFeedBack = new HotelFeedBack();
            hotelFeedBack.setFeedback(feedbackRequest.getFeedback());
            hotelFeedBack.setRating(feedbackRequest.getRating());
            hotelFeedBack.setHotel(hotelBooking.getRoom().getHotel());
            hotelFeedBack.setUser(hotelBooking.getUser());
            hotelFeedBack.setRetired(true);
            hotelFeedBackRepository.save(hotelFeedBack);
            //rating hotel
            //calculate rating
            double rating = 0;
            //get list rating hotel
            List<HotelFeedBack> hotelFeedBacks = hotelFeedBackRepository.findByHotelId(hotel.getId());
            if (hotelFeedBacks.size() > 0) {
                for (HotelFeedBack hotelFeedBack1 : hotelFeedBacks) {
                    rating += hotelFeedBack1.getRating();
                }
                rating = rating / hotelFeedBacks.size();
            }
            hotel.setHotelRating((float) rating);
            hotelRepository.save(hotel);
            return ResponseEntity.ok(new MessageResponse("Feedback success!"));
    }
    //show feedback of user
    @GetMapping("/showFeedback/{id}")
    public ResponseEntity<?> showFeedback(@PathVariable Long id) {
        List<HotelFeedBack> hotelFeedBacks = hotelFeedBackRepository.findByUserId(id);
        return ResponseEntity.ok(hotelFeedBacks);
    }
}
