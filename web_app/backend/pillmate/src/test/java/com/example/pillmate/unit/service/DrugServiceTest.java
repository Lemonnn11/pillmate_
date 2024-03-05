package com.example.pillmate.unit.service;

import com.example.pillmate.model.Drug;
import com.example.pillmate.service.DrugService;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.mockito.Mock;
import org.springframework.boot.test.context.SpringBootTest;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNull;
import static org.mockito.Mockito.when;

@SpringBootTest
public class DrugServiceTest {

    @Mock
    private DrugService drugServiceMock;

    @Nested
    class testGetDrugs {

        @Test
        public void testGetDrugsSuccessfully(){
            List<Drug> drugList = new ArrayList<>();
            drugList.add(new Drug("ACT09", "Actisac Cap. 20 mg", "Fluoxetine", "Capsule", "Antidepressants", "true", "ACT09-01"));
            drugList.add(new Drug("ADA01", "Adalat Cap. 5 mg", "Nifedipine", "Capsule", "Calcium channel blockers (CCBs) / Calcium antagonists,Cardiac drugs,Anti-anginal drugs", "true", "ADA01-01"));

            when(drugServiceMock.getDrugs()).thenReturn(drugList);

            assertEquals(drugList, drugServiceMock.getDrugs());
        }

        @Test
        public void testGetEmptyDrug(){
            List<Drug> drugList = new ArrayList<>();

            when(drugServiceMock.getDrugs()).thenReturn(drugList);

            assertEquals(Collections.emptyList(),drugServiceMock.getDrugs());
        }

    }

    @Nested
    class getDrugsByQuery {

        @Test
        public void testGetDrugsSuccessfully(){
            List<Drug> drugList = new ArrayList<>();
            drugList.add(new Drug("ACT09", "Actisac Cap. 20 mg", "Fluoxetine", "Capsule", "Antidepressants", "true", "ACT09-01"));
            drugList.add(new Drug("ADA01", "Adalat Cap. 5 mg", "Nifedipine", "Capsule", "Calcium channel blockers (CCBs) / Calcium antagonists,Cardiac drugs,Anti-anginal drugs", "true", "ADA01-01"));

            when(drugServiceMock.getDrugsByQuery("A")).thenReturn(drugList);

            assertEquals(drugList, drugServiceMock.getDrugsByQuery("A"));
        }

        @Test
        public void testNotGetDrug(){
            List<Drug> drugList = new ArrayList<>();

            when(drugServiceMock.getDrugsByQuery("A")).thenReturn(drugList);

            assertEquals( Collections.emptyList(),drugServiceMock.getDrugsByQuery("A"));
        }

    }

    @Nested
    class getCategories {

        @Test
        public void testGetCategoriesSuccessfully(){
            List<String> categories = new ArrayList<>();
            categories.add("aminoglycosides");
            categories.add("antiamoebics");

            when(drugServiceMock.getCategories()).thenReturn(categories);

            assertEquals(categories, drugServiceMock.getCategories());
        }

        @Test
        public void testGetEmptyCategories(){
            List<String> categories = new ArrayList<>();

            when(drugServiceMock.getCategories()).thenReturn(categories);

            assertEquals( Collections.emptyList(),drugServiceMock.getCategories());
        }

    }

}
