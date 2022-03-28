package com.example.travelola.repository;

import com.example.travelola.model.AccountUser;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface UserRepository extends JpaRepository<AccountUser, Long> {
    List<AccountUser> findByUsername(String username);
    List<AccountUser> findByEmail(String email);
}
