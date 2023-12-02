package com.example.pillmate.controller;

import com.example.pillmate.model.Pharmacy;
import com.example.pillmate.service.PharmacyService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.concurrent.ExecutionException;

@RestController
@RequestMapping("/api/pharmacy")
public class PharmacyController {

    @Autowired
    PharmacyService pharmacyService;

    @CrossOrigin
    @PostMapping("/create")
    public ResponseEntity<HttpStatus> createPharmacy(@RequestBody Pharmacy pharmacy){
        try {
            Boolean res = pharmacyService.addPharmacy(pharmacy);
            if(res){
                return new ResponseEntity<>(HttpStatus.CREATED);
            }
            else {
                return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
            }
        } catch (ExecutionException | InterruptedException e) {
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

}
