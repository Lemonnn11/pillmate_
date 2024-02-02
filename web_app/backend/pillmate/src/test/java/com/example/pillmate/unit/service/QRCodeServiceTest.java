package com.example.pillmate.unit.service;

import com.example.pillmate.model.Pharmacy;
import com.example.pillmate.model.QRCode;
import com.example.pillmate.service.QRCodeService;
import com.google.zxing.NotFoundException;
import com.google.zxing.WriterException;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.mockito.Mock;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.test.web.servlet.result.MockMvcResultMatchers;

import java.io.IOException;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.when;

@SpringBootTest
public class QRCodeServiceTest {

    @Mock
    private QRCodeService qrCodeServiceMock;

    @Nested
    class  TestCreateQRCode{

        @Test
        public void testCreateQRCodeSuccess() throws NotFoundException, IOException, WriterException {
            QRCode qrCode = new QRCode(
                    "",
                    "I8piP5C9Weqz37gI37vX",
                    1,
                    2,
                    "ก่อนอาหาร",
                    "",
                    "เช้า กลางวัน เย็น",
                    "2024-06-25T00:00:00",
                    "2023-12-02T00:00:00",
                    "ลดคลื่นไส้อาเจียน",
                    "ยานี้อาจระคายเคืองกระเพาะอาหาร ให้รับประทานหลังอาหารทันที",
                    10,
                    250,
                    "หากมีอาการผื่นแพ้ เยื่อบุผิวลอก ให้หยุดใช้ยาและหากมีอาการหนักควรปรึกษาแพทย์ทันที",
                    "แคปซูล",
                    "Paracetamol",
                    "Paracap Tab. 500 mg"
            );

            when(qrCodeServiceMock.createQRCode(any(QRCode.class))).thenReturn("bd3d8c6e-e502-4e49-99ae-569a004f7225");

            assertEquals("bd3d8c6e-e502-4e49-99ae-569a004f7225", qrCodeServiceMock.createQRCode(qrCode));
        }

        @Test
        public void testCreateQRCodeThrowsException() throws NotFoundException, IOException, WriterException {
            QRCode qrCode = new QRCode(
                    "",
                    "I8piP5C9Weqz37gI37vX",
                    1,
                    2,
                    "ก่อนอาหาร",
                    "",
                    "เช้า กลางวัน เย็น",
                    "2024-06-25T00:00:00",
                    "2023-12-02T00:00:00",
                    "ลดคลื่นไส้อาเจียน",
                    "ยานี้อาจระคายเคืองกระเพาะอาหาร ให้รับประทานหลังอาหารทันที",
                    10,
                    250,
                    "หากมีอาการผื่นแพ้ เยื่อบุผิวลอก ให้หยุดใช้ยาและหากมีอาการหนักควรปรึกษาแพทย์ทันที",
                    "แคปซูล",
                    "Paracetamol",
                    "Paracap Tab. 500 mg"
            );

            when(qrCodeServiceMock.createQRCode(qrCode)).thenThrow(IOException.class);

            assertThrows(IOException.class, () -> {
                qrCodeServiceMock.createQRCode(qrCode);
            });
        }

    }
}
