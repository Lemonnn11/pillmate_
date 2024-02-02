package com.example.pillmate.unit.controller;

import com.example.pillmate.controller.QRCodeController;
import com.example.pillmate.model.Pharmacy;
import com.example.pillmate.model.QRCode;
import com.example.pillmate.service.QRCodeService;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.*;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.springframework.http.MediaType;
import org.springframework.test.context.junit.jupiter.SpringExtension;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.test.web.servlet.result.MockMvcResultMatchers;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;

import java.io.IOException;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.when;

@ExtendWith(SpringExtension.class)
public class QRCodeControllerTest {

    @TestInstance(TestInstance.Lifecycle.PER_CLASS)
    @Nested
    class TestCreateQRCode{

        @Mock
        QRCodeService qrCodeServiceMock;

        @InjectMocks
        QRCodeController qrCodeController;

        private MockMvc mockMvc;

        ObjectMapper objectMapper;

        @BeforeAll
        public void setup(){
            this.mockMvc = MockMvcBuilders.standaloneSetup(qrCodeController).build();
            objectMapper = new ObjectMapper();
        }

        @Test
        public void testCreateQRCodeSuccessful() throws Exception {
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

            mockMvc.perform(MockMvcRequestBuilders.post("/api/qrCode/create")
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(objectMapper.writeValueAsString(qrCode)))
                    .andExpect(MockMvcResultMatchers.status().isCreated())
                    .andReturn();
        }

        @Test
        public void testCreatePharmacyWithInternalException() throws Exception {
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

            when(qrCodeServiceMock.createQRCode(any(QRCode.class))).thenThrow(IOException.class);

            mockMvc.perform(MockMvcRequestBuilders.post("/api/qrCode/create")
                            .contentType(MediaType.APPLICATION_JSON)
                            .content(objectMapper.writeValueAsString(qrCode)))
                    .andExpect(MockMvcResultMatchers.status().isInternalServerError())
                    .andReturn();
        }

        @AfterEach
        public void teardown() {
            Mockito.reset(qrCodeServiceMock);
        }
    }
}
