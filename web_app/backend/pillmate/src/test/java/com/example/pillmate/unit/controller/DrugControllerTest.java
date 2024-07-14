package com.example.pillmate.unit.controller;

import com.example.pillmate.controller.DrugController;
import com.example.pillmate.model.Drug;
import com.example.pillmate.service.DrugService;
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

import java.util.ArrayList;
import java.util.List;

import static org.mockito.Mockito.when;

@ExtendWith(SpringExtension.class)
public class DrugControllerTest {

    @TestInstance(TestInstance.Lifecycle.PER_CLASS)
    @Nested
    class testGetDrugs {

        @Mock
        DrugService drugServiceMock;

        @InjectMocks
        DrugController drugController;

        private MockMvc mockMvc;

        ObjectMapper objectMapper;

        @BeforeAll
        public void setup(){
            this.mockMvc = MockMvcBuilders.standaloneSetup(drugController).build();
            objectMapper = new ObjectMapper();
        }

        @Test
        public void testGetDrugsSuccessfully() throws Exception {
            List<Drug> drugList = new ArrayList<>();
            drugList.add(new Drug("ACT09", "Actisac Cap. 20 mg", "Fluoxetine", "Capsule", "Antidepressants", "true", "ACT09-01"));
            drugList.add(new Drug("ADA01", "Adalat Cap. 5 mg", "Nifedipine", "Capsule", "Calcium channel blockers (CCBs) / Calcium antagonists,Cardiac drugs,Anti-anginal drugs", "true", "ADA01-01"));

            when(drugServiceMock.getDrugs()).thenReturn(drugList);

            mockMvc.perform(MockMvcRequestBuilders.get("/api/drug/")
                            .param("page", "0")
                            .param("size", "2"))
                    .andExpect(MockMvcResultMatchers.status().isOk())
                    .andReturn();
        }

        @Test
        public void testGetEmptyDrug() throws Exception {
            List<Drug> drugList = new ArrayList<>();

            when(drugServiceMock.getDrugs()).thenReturn(drugList);

            mockMvc.perform(MockMvcRequestBuilders.get("/api/drug/")
                            .param("page", "0")
                            .param("size", "2"))
                    .andExpect(MockMvcResultMatchers.status().isNoContent())
                    .andReturn();
        }

        @AfterEach
        public void teardown() {
            Mockito.reset(drugServiceMock);
        }

    }

    @TestInstance(TestInstance.Lifecycle.PER_CLASS)
    @Nested
    class testGetDrugsByQuery {

        @Mock
        DrugService drugServiceMock;

        @InjectMocks
        DrugController drugController;

        private MockMvc mockMvc;

        ObjectMapper objectMapper;

        @BeforeAll
        public void setup(){
            this.mockMvc = MockMvcBuilders.standaloneSetup(drugController).build();
            objectMapper = new ObjectMapper();
        }

        @Test
        public void testGetDrugsSuccessfully() throws Exception {
            List<Drug> drugList = new ArrayList<>();
            drugList.add(new Drug("ACT09", "Actisac Cap. 20 mg", "Fluoxetine", "Capsule", "Antidepressants", "true", "ACT09-01"));
            drugList.add(new Drug("ADA01", "Adalat Cap. 5 mg", "Nifedipine", "Capsule", "Calcium channel blockers (CCBs) / Calcium antagonists,Cardiac drugs,Anti-anginal drugs", "true", "ADA01-01"));

            when(drugServiceMock.getDrugsByQuery("A")).thenReturn(drugList);

            mockMvc.perform(MockMvcRequestBuilders.get("/api/drug/get-drugs")
                            .param("page", "0")
                            .param("size", "2")
                            .param("query", "A"))
                    .andExpect(MockMvcResultMatchers.status().isOk())
                    .andReturn();
        }

        @Test
        public void testGetEmptyDrug() throws Exception {
            List<Drug> drugList = new ArrayList<>();

            when(drugServiceMock.getDrugsByQuery("A")).thenReturn(drugList);

            mockMvc.perform(MockMvcRequestBuilders.get("/api/drug/get-drugs")
                            .param("page", "0")
                            .param("size", "2")
                            .param("query", "A"))
                    .andExpect(MockMvcResultMatchers.status().isNoContent())
                    .andReturn();
        }

        @AfterEach
        public void teardown() {
            Mockito.reset(drugServiceMock);
        }

    }

    @TestInstance(TestInstance.Lifecycle.PER_CLASS)
    @Nested
    class testGetCategories {

        @Mock
        DrugService drugServiceMock;

        @InjectMocks
        DrugController drugController;

        private MockMvc mockMvc;

        ObjectMapper objectMapper;

        @BeforeAll
        public void setup(){
            this.mockMvc = MockMvcBuilders.standaloneSetup(drugController).build();
            objectMapper = new ObjectMapper();
        }

        @Test
        public void testGetDrugsSuccessfully() throws Exception {
            List<String> categories = new ArrayList<>();
            categories.add("aminoglycosides");
            categories.add("antiamoebics");

            when(drugServiceMock.getCategories()).thenReturn(categories);

            mockMvc.perform(MockMvcRequestBuilders.get("/api/drug/get-categories"))
                    .andExpect(MockMvcResultMatchers.status().isOk())
                    .andReturn();
        }

        @Test
        public void testGetEmptyDrug() throws Exception {
            List<String> categories = new ArrayList<>();

            when(drugServiceMock.getCategories()).thenReturn(categories);

            mockMvc.perform(MockMvcRequestBuilders.get("/api/drug/get-categories"))
                    .andExpect(MockMvcResultMatchers.status().isNoContent())
                    .andReturn();
        }

        @AfterEach
        public void teardown() {
            Mockito.reset(drugServiceMock);
        }

    }
}
