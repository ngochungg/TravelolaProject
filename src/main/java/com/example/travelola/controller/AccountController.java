package com.example.travelola.controller;


import com.example.travelola.model.AccountUser;
import com.example.travelola.model.ResponseObject;
import com.example.travelola.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("api/")
public class AccountController {
    @Autowired
    private UserRepository userRepository;
    //get all user
    @GetMapping("Account")
    public List<AccountUser> getAllAccountUser() {
        return userRepository.findAll();
    }


    //insert new product with POST method
    @PostMapping("Account")
    ResponseEntity<ResponseObject> CreateAccount(@RequestBody AccountUser newAccount) {
        List<AccountUser> foundAccountName = userRepository.findByUsername(newAccount.getUsername().trim());
        List<AccountUser> foundAccountEmail = userRepository.findByEmail(newAccount.getEmail().trim());
        if (foundAccountName.size() > 0) {
            return ResponseEntity.status(HttpStatus.NOT_IMPLEMENTED).body(
                    new ResponseObject("failed", "Username already taken", "")
            );
        }
        if (foundAccountEmail.size() > 0) {
            return ResponseEntity.status(HttpStatus.NOT_IMPLEMENTED).body(
                    new ResponseObject("failed", "Email already taken", "")
            );
        }
        AccountUser user = new AccountUser();

        user.setUsername(newAccount.getUsername());
        user.setEmail(newAccount.getEmail());

        user.setPassword(newAccount.getPassword());

        newAccount.setRole_id(3);
        user.setRole_id(newAccount.getRole_id());

        newAccount.setActive(true);
        user.setActive(newAccount.isActive());
        return ResponseEntity.status(HttpStatus.OK).body(
                new ResponseObject("oke", "Insert User successfully", userRepository.save(newAccount))
        );
    }
}
