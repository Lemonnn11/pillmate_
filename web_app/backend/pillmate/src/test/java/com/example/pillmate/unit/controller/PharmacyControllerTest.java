package com.example.pillmate.unit.controller;

import com.example.pillmate.controller.PharmacyController;
import com.example.pillmate.model.Pharmacy;
import com.example.pillmate.service.PharmacyService;
import com.fasterxml.jackson.core.JsonProcessingException;
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

import java.util.concurrent.ExecutionException;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.when;

@ExtendWith(SpringExtension.class)
public class PharmacyControllerTest {

    @TestInstance(TestInstance.Lifecycle.PER_CLASS)
    @Nested
    class testCreatePharmacy{

        @Mock
        PharmacyService pharmacyServiceMock;

        @InjectMocks
        PharmacyController pharmacyController;

        private MockMvc mockMvc;

        ObjectMapper objectMapper;
        @BeforeAll
        public void setup(){
            this.mockMvc = MockMvcBuilders.standaloneSetup(pharmacyController).build();
            objectMapper = new ObjectMapper();
        }

        @Test
        public void testCreatePharmacySuccessful() throws Exception {
            Pharmacy pharmacy = new Pharmacy(
                    "",
                    "ร้านขายยาเภสัชมหิดล สถานปฏิบัติการเภสัชกรรมชุมชน",
                    "447 Thanon Si Ayutthaya, Thung Phaya Thai, Ratchathewi, Bangkok 10400",
                    "13.77765254802144",
                    "100.52532826905029",
                    "0968123561",
                    "8:00 - 17:00",
                    "Mon - Fri",
                    "ราชเทวี",
                    "กรุงเทพมหานคร",
                    "lemonn123@gmail.com"
            );

            when(pharmacyServiceMock.addPharmacy(any(Pharmacy.class))).thenReturn("59THxHDqc5i6tBIKWQ5p");


            mockMvc.perform(MockMvcRequestBuilders.post("/api/pharmacy/create")
                            .contentType(MediaType.APPLICATION_JSON)
                            .content(objectMapper.writeValueAsString(pharmacy)))
                    .andExpect(MockMvcResultMatchers.status().isCreated())
                    .andReturn();
        }

        @Test
        public void testCreatePharmacyWithNull() throws Exception {
            Pharmacy pharmacy = null;

            when(pharmacyServiceMock.addPharmacy(pharmacy)).thenReturn(null);

            mockMvc.perform(MockMvcRequestBuilders.post("/api/pharmacy/create")
                            .contentType(MediaType.APPLICATION_JSON)
                            .content(objectMapper.writeValueAsString(pharmacy)))
                    .andExpect(MockMvcResultMatchers.status().isBadRequest())
                    .andReturn();
        }

        @Test
        public void testCreatePharmacyWithInternalException() throws Exception {
            Pharmacy pharmacy = new Pharmacy(
                    "",
                    "ร้านขายยาเภสัชมหิดล สถานปฏิบัติการเภสัชกรรมชุมชน",
                    "447 Thanon Si Ayutthaya, Thung Phaya Thai, Ratchathewi, Bangkok 10400",
                    "13.77765254802144",
                    "100.52532826905029",
                    "0968123561",
                    "8:00 - 17:00",
                    "Mon - Fri",
                    "ราชเทวี",
                    "กรุงเทพมหานคร",
                    "lemonn123@gmail.com"
            );

            when(pharmacyServiceMock.addPharmacy(any(Pharmacy.class))).thenThrow(InterruptedException.class);

            mockMvc.perform(MockMvcRequestBuilders.post("/api/pharmacy/create")
                            .contentType(MediaType.APPLICATION_JSON)
                            .content(objectMapper.writeValueAsString(pharmacy)))
                    .andExpect(MockMvcResultMatchers.status().isInternalServerError())
                    .andReturn();
        }

        @AfterEach
        public void teardown() {
            Mockito.reset(pharmacyServiceMock);
        }

    }

    @TestInstance(TestInstance.Lifecycle.PER_CLASS)
    @Nested
    class testUpdatePharmacy{

        @Mock
        PharmacyService pharmacyServiceMock;

        @InjectMocks
        PharmacyController pharmacyController;

        private MockMvc mockMvc;

        ObjectMapper objectMapper;
        @BeforeAll
        public void setup(){
            this.mockMvc = MockMvcBuilders.standaloneSetup(pharmacyController).build();
            objectMapper = new ObjectMapper();
        }

        @Test
        public void testUpdatePharmacySuccessful() throws Exception {
            Pharmacy pharmacy = new Pharmacy(
                    "Fy751CumG69MLZfZLvqe",
                    "ร้านขายยาเภสัชมหิดล สถานปฏิบัติการเภสัชกรรมชุมชน",
                    "447 Thanon Si Ayutthaya, Thung Phaya Thai, Ratchathewi, Bangkok 10400",
                    "13.77765254802144",
                    "100.52532826905029",
                    "0968123561",
                    "8:00 - 17:00",
                    "Mon - Fri",
                    "ราชเทวี",
                    "กรุงเทพมหานคร",
                    "lemonn123@gmail.com"
            );

            when(pharmacyServiceMock.editPharmacy(any(Pharmacy.class))).thenReturn("59THxHDqc5i6tBIKWQ5p");


            mockMvc.perform(MockMvcRequestBuilders.put("/api/pharmacy/update")
                            .contentType(MediaType.APPLICATION_JSON)
                            .content(objectMapper.writeValueAsString(pharmacy)))
                    .andExpect(MockMvcResultMatchers.status().isOk())
                    .andReturn();
        }

        @Test
        public void testCreatePharmacyWithNull() throws Exception {
            Pharmacy pharmacy = null;

            when(pharmacyServiceMock.editPharmacy(pharmacy)).thenReturn(null);

            mockMvc.perform(MockMvcRequestBuilders.put("/api/pharmacy/update")
                            .contentType(MediaType.APPLICATION_JSON)
                            .content(objectMapper.writeValueAsString(pharmacy)))
                    .andExpect(MockMvcResultMatchers.status().isBadRequest())
                    .andReturn();
        }

        @Test
        public void testCreatePharmacyWithInternalException() throws Exception {
            Pharmacy pharmacy = new Pharmacy(
                    "Fy751CumG69MLZfZLvqe",
                    "ร้านขายยาเภสัชมหิดล สถานปฏิบัติการเภสัชกรรมชุมชน",
                    "447 Thanon Si Ayutthaya, Thung Phaya Thai, Ratchathewi, Bangkok 10400",
                    "13.77765254802144",
                    "100.52532826905029",
                    "0968123561",
                    "8:00 - 17:00",
                    "Mon - Fri",
                    "ราชเทวี",
                    "กรุงเทพมหานคร",
                    "lemonn123@gmail.com"
            );

            when(pharmacyServiceMock.editPharmacy(any(Pharmacy.class))).thenThrow(InterruptedException.class);

            mockMvc.perform(MockMvcRequestBuilders.put("/api/pharmacy/update")
                            .contentType(MediaType.APPLICATION_JSON)
                            .content(objectMapper.writeValueAsString(pharmacy)))
                    .andExpect(MockMvcResultMatchers.status().isInternalServerError())
                    .andReturn();
        }

        @AfterEach
        public void teardown() {
            Mockito.reset(pharmacyServiceMock);
        }

    }

    @TestInstance(TestInstance.Lifecycle.PER_CLASS)
    @Nested
    class testGetPharmacyByAccount{

        @Mock
        PharmacyService pharmacyServiceMock;

        @InjectMocks
        PharmacyController pharmacyController;

        private MockMvc mockMvc;

        ObjectMapper objectMapper;
        @BeforeAll
        public void setup(){
            this.mockMvc = MockMvcBuilders.standaloneSetup(pharmacyController).build();
            objectMapper = new ObjectMapper();
        }

        @Test
        public void testGetPharmacySuccessful() throws Exception {
            Pharmacy pharmacy = new Pharmacy(
                    "Fy751CumG69MLZfZLvqe",
                    "ร้านขายยาเภสัชมหิดล สถานปฏิบัติการเภสัชกรรมชุมชน",
                    "447 Thanon Si Ayutthaya, Thung Phaya Thai, Ratchathewi, Bangkok 10400",
                    "13.77765254802144",
                    "100.52532826905029",
                    "0968123561",
                    "8:00 - 17:00",
                    "Mon - Fri",
                    "ราชเทวี",
                    "กรุงเทพมหานคร",
                    "lemonn123@gmail.com"
            );

            when(pharmacyServiceMock.getPharmacyByAccount("lemonn123@gmail.com")).thenReturn(pharmacy);


            mockMvc.perform(MockMvcRequestBuilders.get("/api/pharmacy/get-pharmacy")
                            .param("email","lemonn123@gmail.com"))
                    .andExpect(MockMvcResultMatchers.status().isOk())
                    .andReturn();
        }

        @Test
        public void testGetPharmacyWithNonExistingAccount() throws Exception {
            Pharmacy pharmacy = null;

            when(pharmacyServiceMock.getPharmacyByAccount("mon123@gmail.com")).thenReturn(null);

            mockMvc.perform(MockMvcRequestBuilders.get("/api/pharmacy/get-pharmacy")
                            .param("email","mon123@gmail.com"))
                    .andExpect(MockMvcResultMatchers.status().isBadRequest())
                    .andReturn();
        }

        @Test
        public void testGetPharmacyWithInternalException() throws Exception {
            Pharmacy pharmacy = new Pharmacy(
                    "Fy751CumG69MLZfZLvqe",
                    "ร้านขายยาเภสัชมหิดล สถานปฏิบัติการเภสัชกรรมชุมชน",
                    "447 Thanon Si Ayutthaya, Thung Phaya Thai, Ratchathewi, Bangkok 10400",
                    "13.77765254802144",
                    "100.52532826905029",
                    "0968123561",
                    "8:00 - 17:00",
                    "Mon - Fri",
                    "ราชเทวี",
                    "กรุงเทพมหานคร",
                    "lemonn123@gmail.com"
            );

            when(pharmacyServiceMock.getPharmacyByAccount("lemonn123@gmail.com")).thenThrow(InterruptedException.class);

            mockMvc.perform(MockMvcRequestBuilders.get("/api/pharmacy/get-pharmacy")
                            .param("email","lemonn123@gmail.com"))
                    .andExpect(MockMvcResultMatchers.status().isInternalServerError())
                    .andReturn();
        }

        @AfterEach
        public void teardown() {
            Mockito.reset(pharmacyServiceMock);
        }

    }
}
