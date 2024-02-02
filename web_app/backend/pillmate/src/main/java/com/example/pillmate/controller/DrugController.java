package com.example.pillmate.controller;

import com.example.pillmate.model.Drug;
import com.example.pillmate.service.DrugService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.ArrayList;
import java.util.List;

@RestController
@RequestMapping("/api/drug")
public class DrugController {

    @Autowired
    DrugService drugService;

    @CrossOrigin
    @GetMapping("/get-drugs")
    public ResponseEntity<List<Drug>> getDrugs(){
        List<Drug> drugs = drugService.getDrugs();
        if(drugs == null){
            return new ResponseEntity<>(HttpStatus.NO_CONTENT);
        }else{
            return new ResponseEntity<>(drugs, HttpStatus.OK);
        }
    }

}
