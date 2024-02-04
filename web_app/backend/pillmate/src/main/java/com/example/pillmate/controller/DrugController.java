package com.example.pillmate.controller;

import com.example.pillmate.model.Drug;
import com.example.pillmate.service.DrugService;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.apache.poi.ss.formula.functions.T;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Objects;

@RestController
@RequestMapping("/api/drug")
public class DrugController {

    @Autowired
    DrugService drugService;

    @CrossOrigin
    @GetMapping("/")
    public ResponseEntity<Object> getDrugs(@RequestParam("page") int page, @RequestParam("size") int size){
        List<Drug> drugs =  drugService.getDrugs();
        if(drugs == null){
            return new ResponseEntity<>(HttpStatus.NO_CONTENT);
        }
        List<Drug> pageDrugs  = new ArrayList<>();
        int lastPage =(int) Math.ceil((double) drugs.size() / size);
        if(page == lastPage - 1){
            for(int i = page*size; i < drugs.size(); i++){
                pageDrugs.add(drugs.get(i));
            }
        }else{
            for(int i = page*size; i < size+(page*size); i++){
                pageDrugs.add(drugs.get(i));
            }
        }
        HashMap<String, Object> map = new HashMap<>();
        map.put("drugs", pageDrugs);
        map.put("totalDrugs", drugs.size());
        map.put("totalPages", lastPage);
        return new ResponseEntity<>(map, HttpStatus.OK);
    }

    @CrossOrigin
    @GetMapping("/get-drugs")
    public ResponseEntity<Object> getDrugsByQuery(@RequestParam("page") int page, @RequestParam("size") int size, @RequestParam("query") String query){
        List<Drug> drugs = drugService.getDrugsByQuery(query);
        if(drugs == null){
            return new ResponseEntity<>(HttpStatus.NO_CONTENT);
        }
        List<Drug> pageDrugs  = new ArrayList<>();
        int lastPage =(int) Math.ceil((double) drugs.size() / size);
        if(page == lastPage - 1){
            for(int i = page*size; i < drugs.size(); i++){
                pageDrugs.add(drugs.get(i));
            }
        }else{
            for(int i = page*size; i < size+(page*size); i++){
                pageDrugs.add(drugs.get(i));
            }
        }
        HashMap<String, Object> map = new HashMap<>();
        map.put("drugs", pageDrugs);
        map.put("totalDrugs", drugs.size());
        map.put("totalPages", lastPage);
        return new ResponseEntity<>(map, HttpStatus.OK);
    }
}
