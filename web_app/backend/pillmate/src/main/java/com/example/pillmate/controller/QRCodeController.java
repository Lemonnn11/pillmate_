package com.example.pillmate.controller;

import com.example.pillmate.model.QRCode;
import com.example.pillmate.service.QRCodeService;
import com.google.zxing.NotFoundException;
import com.google.zxing.WriterException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.io.IOException;

@RestController
@RequestMapping("/api/qrCode")
public class QRCodeController {

    @Autowired
    QRCodeService qrCodeService;

    @CrossOrigin
    @RequestMapping("/create")
    public ResponseEntity<String> createQRCode(@RequestBody QRCode qrCode){
        try {
            String id = qrCodeService.createQRCode(qrCode);
            return new ResponseEntity<>(id, HttpStatus.CREATED);
        } catch (IOException | WriterException e) {
            e.printStackTrace();
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
        } catch (NotFoundException e) {
            throw new RuntimeException(e);
        }
    }

}
