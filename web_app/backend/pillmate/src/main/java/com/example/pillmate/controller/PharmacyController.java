package com.example.pillmate.controller;

import com.example.pillmate.model.Pharmacy;
import com.example.pillmate.service.PharmacyService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.concurrent.ExecutionException;

@RestController
@RequestMapping("/api/pharmacy")
public class PharmacyController {

    @Autowired
    PharmacyService pharmacyService;

    @CrossOrigin
    @PostMapping("/create")
    public ResponseEntity<HashMap<String, String>> createPharmacy(@RequestBody Pharmacy pharmacy){
        try {
            String res = pharmacyService.addPharmacy(pharmacy);
            if(res == null){
                return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
            }
            else {
                HashMap<String, String> map = new HashMap<>();
                map.put("id", res);
                return new ResponseEntity<>(map, HttpStatus.CREATED);
            }
        } catch (ExecutionException | InterruptedException e) {
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @CrossOrigin
    @PutMapping("/update")
    public ResponseEntity<HashMap<String, String>> updatePharmacy(@RequestBody Pharmacy pharmacy){
        try {
            String res = pharmacyService.editPharmacy(pharmacy);
            if(res == null){
                return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
            }
            else {
                HashMap<String, String> map = new HashMap<>();
                map.put("timestamp", res);
                return new ResponseEntity<>(map, HttpStatus.OK);
            }
        } catch (ExecutionException | InterruptedException e) {
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @CrossOrigin
    @GetMapping("/get-pharmacy")
    public  ResponseEntity<Pharmacy> getPharmacyByAccount(@RequestParam("email") String email){
        System.out.println(email);
        try{
            Pharmacy pharmacy = pharmacyService.getPharmacyByAccount(email);
            if(pharmacy == null){
                return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
            }else{
                return new ResponseEntity<>(pharmacy, HttpStatus.OK);
            }
        }catch (ExecutionException | InterruptedException e){
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

}
