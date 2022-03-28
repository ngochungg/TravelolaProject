package com.example.travelola.model;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import javax.persistence.*;

@Entity
@Table(name="Customer")
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class Customer {
    @Id
    @Column(name="customerID")
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long customerID;
    @Column(name="userID")
    private int userID;
    @Column(name="firstname")
    private String firstname;
    @Column(name="lastname")
    private String lastname;
    @Column(name="email")
    private String email;
    @Column(name="phonenumber")
    private String phoneNumber;
}
