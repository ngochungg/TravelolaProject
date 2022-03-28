package com.example.travelola.model;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import javax.persistence.*;

@Entity
@Table(name="Useraccount")
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class AccountUser {
    @Id
    @Column(name="userID")
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long userID;
    @Column(name="username")
    private String username;
    @Column(name="password")
    private String password;
    @Column(name="email")
    private String email;
    @Column(name="role_id")
    private int role_id;
    @Column(name="active")
    private boolean active;

}
