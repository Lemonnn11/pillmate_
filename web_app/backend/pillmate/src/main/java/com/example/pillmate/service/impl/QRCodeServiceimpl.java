package com.example.pillmate.service.impl;

import com.example.pillmate.model.QRCode;
import com.example.pillmate.repository.QRCodeRepository;
import com.example.pillmate.service.QRCodeService;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.zxing.*;
import com.google.zxing.client.j2se.BufferedImageLuminanceSource;
import com.google.zxing.common.BitMatrix;
import com.google.zxing.common.HybridBinarizer;
import com.google.zxing.qrcode.decoder.ErrorCorrectionLevel;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.imageio.ImageIO;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.nio.charset.StandardCharsets;
import java.time.LocalDate;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

@Service
public class QRCodeServiceimpl implements QRCodeService {

    @Autowired
    QRCodeRepository qrCodeRepository;

    @Override
    public String createQRCode(QRCode qrCode) throws IOException, WriterException, NotFoundException {
        ObjectMapper objectMapper = new ObjectMapper();

        Map<String, Object> map = new HashMap<>();
        qrCode.setQrCodeID(UUID.randomUUID().toString());
        map.put("QRCodeID", qrCode.getQrCodeID());
        map.put("pharID", qrCode.getPharID());
        map.put("dosagePerTake", qrCode.getDosagePerTake());
        map.put("timePerDay", qrCode.getTimePerDay());
        map.put("timeOfMed", qrCode.getTimeOfMed());
        map.put("timePeriodForMed", qrCode.getTimePeriodForMed());
        map.put("takeMedWhen", qrCode.getTakeMedWhen());
        map.put("expiredDate", String.valueOf(qrCode.getExpiredDate()));
        map.put("date", String.valueOf(qrCode.getDate()));
        map.put("conditionOfUse", qrCode.getConditionOfUse());
        map.put("additionalAdvice", qrCode.getAdditionalAdvice());
        map.put("amountOfMeds", qrCode.getAmountOfMeds());
        map.put("quantity", qrCode.getQuantity());
        map.put("adverseDrugReaction", qrCode.getAdverseDrugReaction());
        map.put("typeOfMedicine", qrCode.getTypeOfMedicine());
        map.put("genericName", qrCode.getGenericName());
        map.put("tradeName", qrCode.getTradeName());

        String data = objectMapper.writeValueAsString(map);
        Map<EncodeHintType, ErrorCorrectionLevel> hashMap = new HashMap<EncodeHintType, ErrorCorrectionLevel>();
        hashMap.put(EncodeHintType.ERROR_CORRECTION, ErrorCorrectionLevel.L);
        String encodedString = new String(data.getBytes(StandardCharsets.UTF_8), StandardCharsets.ISO_8859_1);
        BitMatrix matrix = new MultiFormatWriter().encode(encodedString, BarcodeFormat.QR_CODE, 250, 250);
        qrCodeRepository.saveQRCode(matrix, qrCode.getQrCodeID());

        return qrCode.getQrCodeID();
    }
}
