package com.example.pillmate.service;


import com.example.pillmate.model.QRCode;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.google.zxing.NotFoundException;
import com.google.zxing.WriterException;

import java.io.IOException;
import java.io.UnsupportedEncodingException;

public interface QRCodeService {
    String createQRCode(QRCode qrCode) throws IOException, WriterException, NotFoundException;
}
