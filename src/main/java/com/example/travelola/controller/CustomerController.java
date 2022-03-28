package com.example.travelola.controller;

import com.example.travelola.exception.ResourceNotFoundException;
import com.example.travelola.model.Customer;
import com.example.travelola.repository.CustomerRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("api/")
public class CustomerController {
    @Autowired
    private CustomerRepository customerRepository;

    //get all user
    @GetMapping("customers")
    public List<Customer> getAllCustomers() {
        return customerRepository.findAll();
    }

    //get user by id
    @GetMapping("customers/{id}")
    public ResponseEntity<Customer> getCustomerById(@PathVariable(value = "id") Long customerId) throws ResourceNotFoundException {
        Customer customer = customerRepository.findById(customerId)
                .orElseThrow(() -> new ResourceNotFoundException("Customer not found for this id :: " + customerId));
        return ResponseEntity.ok().body(customer);
    }

    //create user
    @PostMapping("customers")
    public Customer createCustomer(@Validated @RequestBody Customer customer) {
        return customerRepository.save(customer);
    }

    //update user
    @PutMapping("customers/{id}")
    public ResponseEntity<Customer> updateCustomer(@PathVariable(value = "id") Long customerId,
                                                   @Validated @RequestBody Customer customerDetails) throws ResourceNotFoundException {
        Customer customer = customerRepository.findById(customerId)
                .orElseThrow(() -> new ResourceNotFoundException("Customer not found for this id :: " + customerId));

        customer.setFirstname(customerDetails.getFirstname());
        customer.setLastname(customerDetails.getLastname());
        customer.setPhoneNumber(customerDetails.getPhoneNumber());
        final Customer updatedCustomer = customerRepository.save(customer);
        return ResponseEntity.ok(updatedCustomer);
    }

    //delete user
    @DeleteMapping("customers/{id}")
    public Map<String, Boolean> deleteCustomer(@PathVariable(value = "id") Long customerId) throws ResourceNotFoundException {
        Customer customer = customerRepository.findById(customerId)
                .orElseThrow(() -> new ResourceNotFoundException("Customer not found for this id :: " + customerId));

        customerRepository.delete(customer);
        Map<String, Boolean> response = new HashMap<>();
        response.put("deleted", Boolean.TRUE);
        return response;
    }
}
